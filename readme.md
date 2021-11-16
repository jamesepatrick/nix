# Nil Install Guide

This is the nix configuration for a 2021 Thinkpad T14 AMD g2 machine named `nil`.

The boot media looks like

```
NAME                          TYPE     MOUNTPOINT
nvme0n1                       disk
├─nvme0n1p1                   part     /boot
└─nvme0n1p2                   part
  └─crypt                     crypt    /dev/mapper/root
    └─partitions              lvm
      ├─swap                  swap     /dev/partitions/swap
      └─lvm_root              lvm      /dev/partitions/lvm_root
        └─rpool               zpool
          ├─rpool/root        zfs
          ├─rpool/root/nixos  zfs      /
          └─rpool/home        zfs      /home
```

## Install

A makefile is used for ease of use. To set this up on a new machine you will need the following:

```bash
nix-env -iA nixos.gnumake
nix-env -iA nixos.git
```

then checkout this repo, create & modify the `.env` file

```bash
git clone https://git.jpatrick.io/james/nil.git /tmp/install
cd /tmp/install
cp .env_sample .env
```

Once you have set the `PASSPHRASE` & `DISK` vars run

```bash
sudo make nix_install
```

## TODO

- Document setting the `networking.hostId` variable.
- Use [NixOS Hardware](https://github.com/NixOS/nixos-hardware) Modules.
- Fix wireless driver issue :: This uses the Realtek 8852AE 802.11AX WWAN.

## References

- [Installing NixOS with encrypted ZFS on a netcup.de root server](https://florianfranke.dev/posts/2020/03/installing-nixos-with-encrypted-zfs-on-a-netcup.de-root-server/)
- [NixOS on Framework laptop](http://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html)
- [NixOS with ZFS on LUKS](https://gist.github.com/ixmatus/7dcd56c8e878e8d98ee6d266f7949d11)
- [Yubikey based Full Disk Encryption (FDE) on NixOS](<https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS>)
- [LUKS-Encrypted Filesystem with Yubikey PBA](https://github.com/sgillespie/nixos-yubikey-luks)
- [Encrypted /boot on ZFS with NixOS](https://elvishjerricco.github.io/2018/12/06/encrypted-boot-on-zfs-with-nixos.html)
