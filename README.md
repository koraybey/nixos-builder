Obtain the minimal ISO image required to boot and install on UTM:https://nixos.org/download/#minimal-iso-image

Create partitions

```shell
cfdisk /dev/vda
# Choose gpt then create 3 partitions
# 1) EFI system for boot, 1G
# 2) Swap partition, 5G
# 3) Linux filesystem, 16G
# Write and quit
```

Create and mount filesystems

```shell
# use /dev/vda for the ARM64 machine, and /dev/sda for the x86_64 machine
mkfs.fat -F 32 -n boot /dev/vda1
mkswap -L swap /dev/vda2
mkfs.ext4 -L nixos /dev/vda3
# mount
mount /dev/vda3 /mnt
mkdir -p /mnt/boot
mount /dev/vda1 /mnt/boot
# enable swap
swapon /dev/vda2
```

Move nebula certs and make them readable: https://nixos.wiki/wiki/Nebula

```shell
# Move certs to /etc/nebula, then
sudo chmod --reference /etc/nix /etc/nebula
sudo chmod --reference /etc/nix/nix.conf /etc/nebula/*
```

Clone configuration and install

```shell
git clone https://github.com/koraybey/nixos-builder
cd nixos-builder && nixos-install --root /mnt --flake .#builder-aarch64
# shutdown
shutdown now
```

Remove the image and boot the UTM VM!

Generate the key on the client so that we can authorize it on the build machine
```shell
ssh-keygen
eval "$(ssh-agent -s)"
ssh-add /home/admin/.ssh/id_ed25519
# Obtain the public key
cat /home/admin/.ssh/.ssh/id_ed25519.pub
# Add it to authorizedKeys
```