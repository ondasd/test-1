#!/bin/sh

git clone https://github.com/ondasd/disko-setup
git clone https://github.com/ondasd/config
cd /tmp
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
    no|n|N|NO)
        echo "ok"
        ;;
    *)
        echo "wrong answer"
        ;;
esac
touch Disko.nix
cd disko-setup
cp disko-conf.nix /tmp/Disko.nix
cd ..
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/Disko.nix
lsblk
echo "work?"
echo "yes/no"
read otvet
case $otvet in
    yes|y|Y|YES)
        echo "good"
        ;;
    n|n|N|NO)
        nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/Disko.nix
        ;;
    *)
        echo "don't understand"
        ;;
esac
lsblk
mkdir -p /mnt/etc/nixos
cp /tmp/Disko.nix /mnt/etc/nixos/disko.nix
cd /mnt/etc/nixos
nixos-generate-config --no-filesystems --root /mnt
cp  ~/config/c.nix /mnt/etc/nixos/configuration.nix
nixos-install
cd ~
rm -rf config
rm -rf disko-setup
