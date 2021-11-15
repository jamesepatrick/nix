ifeq ($(shell $(MAKE) -v | grep GNU),)
  $(error I need gnumake not bsdmake)
endif
REQUIRED_V := 3.82
ifneq ($(REQUIRED_V),$(firstword $(sort $(MAKE_VERSION) $(REQUIRED_V))))
  $(error For .ONESHELL to work I need at least version $(REQUIRED_V))
endif

.PHONY:  format \
	partitios
	configure_boot \
	configure_luks \
	configure_lvm \
	format_swap \
	format_zpool \
	mount \
	nix_install \
	install

include .env
ifndef DRIVE
  $(error Missing Drive Argument)
endif

.ONESHELL:

format:
	$(info clearing disk)
	sgdisk --zap-all "$(DRIVE)"
	partprobe "$(DRIVE)" >/dev/null || true

partition:
	$(info partition drive into boot & luks partition)
	sgdisk -n 0:0:+300MiB -t 0:ef00 -c 0:boot  "$(DRIVE)"
	sgdisk -n 0:0:0       -t 0:8300 -c 0:crypt "$(DRIVE)"
	partprobe "$(DRIVE)" >/dev/null || true

configure_boot:
	$(info setting up boot drive)
	sleep 4
	partprobe "$(DRIVE)" >/dev/null || true
	mkfs.vfat /dev/disk/by-partlabel/boot

configure_luks:
	$(info setting up luks)
	dd if=/dev/urandom of=/tmp/keyfile bs=1k count=8
	echo "YES" | cryptsetup luksFormat \
	    /dev/disk/by-partlabel/crypt \
	    --key-size 512 \
	    --hash sha512 \
	    --key-file /tmp/keyfile
	echo $(PASSPHRASE) | cryptsetup luksAddKey \
	    /dev/disk/by-partlabel/crypt \
	    --key-file /tmp/keyfile
	cryptsetup luksOpen /dev/disk/by-partlabel/crypt root
	cryptsetup luksRemoveKey /dev/disk/by-partlabel/crypt /tmp/keyfile

configure_lvm:
	$(info Setting up LVM 10G for swap the rest for lvm_root)
	pvcreate "/dev/mapper/root"
	vgcreate "partitions" "/dev/mapper/root"
	lvcreate -L 10G -n swap "partitions"
	lvcreate -l 100%FREE -n lvm_root "partitions"

format_swap:
	$(info making swap)
	mkswap -L swap /dev/partitions/swap

format_zpool:
	$(info making zfs part)
	zpool create        \
	-O atime=on         \
	-O relatime=on      \
	-O compression=lz4  \
	-O snapdir=visible  \
	-O xattr=sa         \
	-o ashift=12        \
	-o altroot=/mnt     \
	rpool               \
	/dev/partitions/lvm_root
	zfs create -o mountpoint=none rpool/root
	zfs create -o mountpoint=legacy rpool/root/nixos
	zfs create -o copies=2 -o mountpoint=legacy rpool/home
	zpool set bootfs=rpool/root/nixos rpool
	zfs set com.sun:auto-snapshot=true rpool/home

mount:
	$(info mounting devices)
	mkswap -L swap /dev/partitions/swap
	swapon /dev/partitions/swap
	mount -t zfs rpool/root/nixos /mnt
	mkdir -p /mnt/{home,boot}
	mount -t zfs rpool/home /mnt/home
	mount /dev/disk/by-partlabel/boot /mnt/boot

nix_install:
	nixos-generate-config --root /mnt
	cp -i nixos/* /mnt/etc/nixos/


install: |  format \
	partition \
	configure_boot \
	configure_luks \
	configure_lvm \
	format_swap \
	format_zpool \
	mount \
	nix_install

echo:
	echo $(PASSPHRASE)
	echo $(DRIVE)

remove:
	swapoff /dev/partitions/swap      >/dev/null || true
	umount /mnt/home                  >/dev/null || true
	umount /mnt/boot                  >/dev/null || true
	umount /mnt/rpool                  >/dev/null || true
	umount /mnt                       >/dev/null || true
	yes | lvremove /dev/partitions/*  >/dev/null || true
	cryptsetup close root             >/dev/null || true
	partprobe "$(DRIVE)"              >/dev/null || true
