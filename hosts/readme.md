# What's this?

This directory contains the specific host configuration for each machine that uses this nix setup. Description and hardware of each machine will be listed as a comment block at the start of each `.nix` file.

# So you want to add a machine?

This will get flushed out as a move more of my systems over to NixOS. 

## Setup

`cp .env_sample .env`

Update the variables. run `make echo` to verify all values are set correctly.

If all looks good run `make install`. This will

1. Wipe the specified drive.
2. Partition the drive using `gdisk`
3. Setup the boot drive
4. Configure the LUKS partition
5. Setup the LVM inside the LUKS Partition
6. Setup Swap inside the LVM.
7. Setup a ZFS pool & create ZFS mount points
8. Generate then install the NixOS configuration.

Note: Step 8 is now outdated and should be updated to work with this configuration format and flakes. 

This should leave you with a system formatted like the below

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
