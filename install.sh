#!/bin/bash

cd /tmp
git clone https://github.com/ondasd/disko-setup
lsblk
echo "================================="
echo "choose your disk.default=/dev/sda"
echo "================================="
echo "change disk?"
echo "yes/no"
read answer
case $answer in
    yes|y|Y|YES)
        nano /tmp/disko-setup/disko-conf.nix
        ;;
    no|n|N|NO
        echo "ok"
        ;;
    *)
        echo "wrong answer"
esac
touch Disko.nix
cd disko-setup
cp disko-conf.nix /tmp/Disko.nix
cd ..
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/Disko.nix
lsblk
mkdir -p /mnt/etc/nixos
cp /tmp/Disko.nix /mnt/etc/nixos/disko.nix
cd /mnt/etc/nixos
nixos-generate-config --no-filesystems --root /mnt
sed -i '10a "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"' configuration.nix
sed -i '14 s/.*/boot.loader.limine.enable = true;' configuration.nix
sed -i '15d' configuration.nix
nixos-install
