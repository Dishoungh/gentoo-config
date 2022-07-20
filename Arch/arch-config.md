# Part I: Booting into USB Boot Media
1. Get ISO from https://archlinux.org/download/
2. Burn iso into USB drive and boot into it
  - I struggled to get into boot by getting stuck in a black screen. If this happens, get into the grub command line and add "nomodeset" at the end of the line starting with "linux" (before "initrd").
3. root@archiso ~ # ping archlinux.org

# Part II: Setting up Disks
1. root@archiso ~ # timedatectl set-ntp true
2. root@archiso ~ # fdisk /dev/nvme0n1
  - nvme0n1p1 - Boot - 512MB
  - nvme0n1p2 - Swap - 32GB
  - nvme0n1p3 - Root - Remainder
3. root@archiso ~ # mkfs.fat -F 32 /dev/nvme0n1p1
4. root@archiso ~ # mkswap /dev/nvme0n1p2
5. root@archiso ~ # swapon /dev/nvme0n1p2
6. root@archiso ~ # mkfs.ext4 /dev/nvme0n1p3
7. root@archiso ~ # mkdir /mnt/boot
8. root@archiso ~ # mkdir /mnt/etc
9. root@archiso ~ # mount /dev/nvme0n1p3 /mnt
10. root@archiso ~ # mount /dev/nvme0n1p1 /mnt/boot
  - Make sure your lsblk shows your root partition being mounted on /mnt and your boot partition being mounted on /mnt/boot
11. root@archiso ~ # genfstab -U -p /mnt >> /mnt/etc/fstab

# Part III: Installing Base System
1. root@archiso ~ # pacstrap -i /mnt base linux linux-firmware
2. root@archiso ~ # arch-chroot /mnt
3. [root@archiso /] # ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
4. [root@archiso /] # hwclock --systohc
5. [root@archiso /] # pacman -S linux linux-headers linux-lts linux-lts-headers vim base-devel openssh networkmanager git sudo
5. [root@archiso /] # systemctl enable sshd
6. [root@archiso /] # systemctl enable NetworkManager

# Part IV: Networking and User Administration
1. [root@archiso /] # vim /etc/locale.gen
  - Uncomment en_US.UTF-8 UTF-8
2. [root@archiso /] # locale-gen
3. [root@archiso /] # vim /etc/locale.conf
  - LANG=en_US.UTF-8
4. [root@archiso /] # vim /etc/hostname
  - nexus2
5. [root@archiso /] # vim /etc/hosts
  - 127.0.0.1 localhost
  - ::1       localhost
  - 127.0.1.1 nexus2
5. [root@archiso /] # passwd
6. [root@archiso /] # useradd -m -g users -G wheel,audio,video,optical dishoungh
7. [root@archiso /] # passwd dishoungh
8. [root@archiso /] # visudo
  - Uncomment %wheel ALL=(ALL) ALL

# Part V: Bootloader & Exit
1. [root@archiso /] # pacman -S grub dosfstools os-prober mtools amd-ucode efibootmgr
2. [root@archiso /] # grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH --removable
3. [root@archiso /] # grub-mkconfig -o /boot/grub/grub.cfg
4. [root@archiso /] # exit
5. [root@archiso /] # umount -R /mnt
6. [root@archiso /] # reboot

# Part VI: Desktop Installation
1. [root@archlinux ~] # vim /etc/pacman.conf
  - Uncomment
    - [multilib]
    - Include = /etc/pacman.d/mirrorlist
2. [root@archlinux ~] # pacman -Syyy 
3. [root@archlinux ~] # pacman -S xorg-server mesa nvidia nvidia-settings nvidia-lts nvidia-libgl vulkan-icd-loader fish sddm plasma konsole dolphin vulkan-headers vkd3d firefox discord steam audacity ark bitwarden dolphin-emu filelight gwenview handbrake kate kdenlive libreoffice-still obs-studio pcsx2 okular vlc libvirt qemu-desktop virt-manager dnsmasq vde2 edk2-ovmf bridge-utils openbsd-netcat desmume wine samba wget rsync nasm lib32-libxkbcommon lib32-libvpx steam-native-runtime ebtables iptables-nft libguestfs virt-viewer spectacle neofetch
4. [root@archlinux ~] # systemctl enable sddm
5. [root@archlinux ~] # reboot

# Part VII: Post-Installation
1. To automount secondary drives on Fstab
  - UUID=(UUID) /media/(UUID) ext4 defaults 0 2
2. dishoungh@nexus2 ~> mkdir custom_packages && cd custom_packages
3. dishoungh@nexus2 ~> git clone https://aur.archlinux.org/proton.git
4. dishoungh@nexus2 ~> git clone https://aur.archlinux.org/timeshift.git
5. dishoungh@nexus2 ~> git clone https://aur.archlinux.org/makemkv.git
6. Make all those packages
  - You may come into missing dependencies. Just install those dependencies.
  - To rectify GPG errors: gpg --recv-key (KEY)
7. To enable VMs
  - sudo systemctl enable libvirtd.service
  - sudo systemctl start libvirtd.service
  - sudo systemctl status libvirtd.service
  - sudo vim /etc/libvirt/libvirtd.conf
    - unix_sock_group = "libvirt"
    - unix_sock_rw_perms = "0770"
  - sudo usermod -aG libvirt dishoungh
  - newgrp libvirt
  - sudo systemctl restart libvirtd.service
  - sudo modprobe kvm-amd
  - reboot

Follow these guides:
1. [Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
2. [How to Set Up Arch Linux For Gaming - nVidia, Intel & AMD GPU Drivers, Steam Proton & Lutris](https://www.youtube.com/watch?v=rH-IiKxoozw&list=LL&index=8&t=89s)
3. [Getting Started with Arch Linux 04 - Installing Desktop Environments (Minor Correction)](https://www.youtube.com/watch?v=jLJO-PKyDAk&list=LL&index=100&t=626s)
