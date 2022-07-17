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
2. [root@archiso /] #
2. [root@archiso /] # grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
3. [root@archiso /] # grub-mkconfig -o /boot/grub/grub.cfg
4. [root@archiso /] # exit
5. [root@archiso /] # umount -R /mnt
6. [root@archiso /] # reboot

# Part VI: Desktop Installation
1. [root@archlinux ~] # pacman -S xorg-server mesa nvidia nvidia-settings nvidia-lts nvidia-libgl vulkan-icd-loader fish sddm plasma konsole dolphin vulkan-headers vkd3d 
2. [root@archlinux ~] # systemctl enable sddm
3. [root@archlinux ~] # reboot

# Part VII: Post-Installation
1. Install the rest of this

- Ungoogled Chromium Binary
- Ark
- Audacity
- Bitwarden
- Discord
- Dolphin (File Explorer)
- Dolphin Emulator
- Filelight
- FontForge
- Gwenview
- Handbrake
- Kate
- Kdenlive
- Konsole
- Libreoffice
- MakeMKV
- OBS Studio
- Okular
- PCSX2
- KsysGuard
- Vim
- Virt-Manager
- VLC
- steam
- nvidia, nvidia-utils, nvidia-lts
- vkd3d, vulkan-headers, vulkan-icd-loader, wine, proton, libdxvk, wine

Follow these guides:
1. [Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
2. [How to Set Up Arch Linux For Gaming - nVidia, Intel & AMD GPU Drivers, Steam Proton & Lutris](https://www.youtube.com/watch?v=rH-IiKxoozw&list=LL&index=8&t=89s)
3. [Getting Started with Arch Linux 04 - Installing Desktop Environments (Minor Correction)](https://www.youtube.com/watch?v=jLJO-PKyDAk&list=LL&index=100&t=626s)
