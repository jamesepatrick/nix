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
