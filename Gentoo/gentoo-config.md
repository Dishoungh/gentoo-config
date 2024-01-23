# Hardware (UEFI)

- CPU: Ryzen 7 5800X (8 Cores / 16 Threads)
- RAM: 32 GB (DDR4-3200)
- GPU: AMD Radeon RX 6900XT
- Storage: Samsung 2TB NVMe SSD
- Monitors: 3x 2560x1440p Monitors (G-Sync IPS 1ms)

# Part I: Booting into the USB Boot Media

1. Downloaded iso image from https://www.gentoo.org/downloads/
2. Used Rufus to make USB drive into boot media
3. Booted into LiveCD.
4. livecd ~ # ping www.gentoo.org -c3
5. livecd ~ # lsblk
6. livecd ~ # fdisk (DEVICE)
7. livecd ~ # mkfs.vfat -F 32 (BOOT)
8. livecd ~ # mkfs.ext4 (ROOT)
9. livecd ~ # mkswap (SWAP)
10. livecd ~ # swapon (SWAP)
11. livecd ~ # mount (ROOT) /mnt/gentoo
12. livecd ~ # cd /mnt/gentoo/
13. livecd /mnt/gentoo # links https://www.gentoo.org/downloads/mirrors
14. livecd /mnt/gentoo # tar xpvf ./stage3-\*.tar.xz --xattrs-include="\*.\*" --numeric-owner
15. livecd /mnt/gentoo # rm -f ./stage3-amd64-*
15. Clone gentoo-config in mount
16. livecd /mnt/gentoo # nano /mnt/gentoo/etc/portage/make.conf **COPY make.conf file**
17. livecd /mnt/gentoo # mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf (I basically picked all the mirrors located in the U.S)
18. livecd /mnt/gentoo # mkdir --parents /mnt/gentoo/etc/portage/repos.conf
19. livecd /mnt/gentoo # cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
20. livecd /mnt/gentoo # cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

# Part II: Chroot
1. livecd /mnt/gentoo # mount --types proc /proc /mnt/gentoo/proc
2. livecd /mnt/gentoo # mount --rbind /sys /mnt/gentoo/sys
3. livecd /mnt/gentoo # mount --make-rslave /mnt/gentoo/sys
4. livecd /mnt/gentoo # mount --rbind /dev /mnt/gentoo/dev
5. livecd /mnt/gentoo # mount --make-rslave /mnt/gentoo/dev
6. livecd /mnt/gentoo # mount --bind /run /mnt/gentoo/run
7. livecd /mnt/gentoo # mount --make-slave /mnt/gentoo/run
8. livecd /mnt/gentoo # chroot /mnt/gentoo /bin/bash
9. livecd / # source /etc/profile
10. livecd / # export PS1="(chroot) ${PS1}"
11. livecd / # mount (BOOT) /boot
12. (chroot) livecd / # lsblk
    - Check to make sure the boot and root partitions are properly mounted

# Part III: Configuring Portage and Installing Core Packages
1. (chroot) livecd / # emerge-webrsync && emerge --sync --quiet
2. (chroot) livecd / # emerge -vq app-eselect/eselect-repository app-portage/cpuid2cpuflags dev-vcs/git
3. (chroot) livecd / # git clone https://github.com/Dishoungh/gentoo-config.git
4. (chroot) livecd / # rm -rf /etc/portage/package.*/
5. (chroot) livecd / # Copy make.conf, package.use, package.mask, package.accept_keywords
6. (chroot) livecd / # echo "\*/\* $(cpuid2cpuflags)" >> /etc/portage/package.use (Don't do this if you copied file)
7. (chroot) livecd / # eselect repository enable guru && emerge --sync
8. (chroot) livecd / # eselect repository enable pf4public && emerge --sync
9. (chroot) livecd / # eselect repository enable steam-overlay && emerge --sync
10. (chroot) livecd / # eselect profile set 9 (Select whichever one that has plasma/openrc)
11. (chroot) livecd / # emerge -1 sys-libs/glibc
12. (chroot) livecd / # emerge --noreplace app-editors/nano
13. (chroot) livecd / # emerge -uvDN @world
14. (chroot) livecd / # emerge -vq acct-group/libvirt app-admin/bitwarden-desktop-bin app-admin/doas app-admin/sysklogd app-arch/lz4 app-backup/timeshift app-editors/nano app-editors/vim app-emulation/libvirt app-emulation/qemu app-emulation/virt-manager app-emulation/vkd3d-proton app-misc/neofetch app-misc/screen app-office/libreoffice app-portage/gentoolkit app-shells/fish dev-qt/qtwebengine dev-util/ccache games-emulation/dolphin games-emulation/pcsx2 games-util/steam-meta gui-libs/display-manager-init kde-apps/konsole kde-plasma/plasma-meta kde-plasma/sddm-kcm media-fonts/fonts-meta media-gfx/feh media-plugins/alsa-plugins media-sound/audacity media-sound/pavucontrol media-sound/pulseaudio media-sound/spotify media-video/libva-utils media-video/obs-studio media-video/pipewire media-video/vlc net-fs/samba net-im/discord net-misc/chrony net-misc/dhcpcd net-misc/netifrc net-misc/networkmanager net-misc/openssh sys-apps/lm-sensors sys-apps/pciutils sys-apps/usbutils sys-auth/pambase sys-boot/efibootmgr sys-boot/grub:2 sys-boot/os-prober sys-devel/llvm sys-fs/btrfs-progs sys-fs/dosfstools sys-fs/udisks sys-kernel/gentoo-sources sys-kernel/linux-firmware sys-power/suspend sys-process/cronie sys-process/htop sys-process/lsof virtual/wine www-client/chromium x11-apps/mesa-progs x11-apps/setxkbmap x11-apps/xhost x11-apps/xrandr x11-apps/xsetroot x11-base/xorg-drivers x11-base/xorg-server x11-drivers/xf86-video-amdgpu x11-misc/sddm x11-misc/sxhkd
10. (chroot) livecd / # emerge -ac
11. (chroot) livecd / # cp /gentoo-config/Gentoo/Every_File_For_Transfer/03-doas.conf /etc/doas.conf
12. (chroot) livecd / # cp /gentoo-config/Gentoo/Every_File_For_Transfer/15-X11-xorg.conf /etc/X11/xorg.conf

# Part IV: Time Zone and Locale Configuration
1. (chroot) livecd / # echo "America/Chicago" > /etc/timezone
2. (chroot) livecd / # emerge --config sys-libs/timezone-data
3. (chroot) livecd / # vim /etc/locale.gen
    - Uncomment:
        - en_US ISO-8859-1
        - en_US.UTF-8 UTF-8
4. (chroot) livecd / # locale-gen
5. (chroot) livecd / # eselect locale set 6
    - This selects en_US.utf8
6. (chroot) livecd / # env-update
7. (chroot) livecd / # source /etc/profile
8. livecd / # export PS1="(chroot) ${PS1}"

# Part V: Kernel Configuration
1. (chroot) livecd / # eselect kernel list
2. (chroot) livecd / # eselect kernel set 1
3. (chroot) livecd / # cd /usr/src/linux
4. (chroot) livecd / # cp /gentoo-config/Gentoo/Every_File_For_Transfer/01-kernel-config.config ./.config
5. (chroot) livecd / # make menuconfig
    a. Make sure settings are in using `make menuconfig` (Make sure there are no modules)
    b. BUILD NVME DRIVERS IN KERNEL!!!!!! The current config doesn't support it. CONFIG_BLK_DEV_NVME=y
6. (chroot) livecd /usr/src/linux # make && make install (There should be no modules)

# Part VI: Fstab + Networking
1. (chroot) livecd / # vim /etc/fstab (COPY FSTAB)
    - \# Boot Partition
    - PARTUUID={BOOT}    /boot   vfat    defaults    1 2
    - \# Swap Partition
    - PARTUUID={SWAP}    none    swap    sw          0 0
    - \# Root Partition
    - PARTUUID={ROOT}    /       ext4    noatime     0 1
    - (INCLUDE SECONDARY MOUNTS HERE: COPY FILE FROM ARCH BUILD)
2. (chroot) livecd / # vim /etc/conf.d/hostname
    - hostname="{HOSTNAME}"
        - Choose a hostname  
3. (chroot) livecd / # rc-update add dhcpcd default
4. (chroot) livecd / # rc-service dhcpcd start
    - /sbin/dhcpcd may be already running so it may spit out an error about the DHCP Client Daemon already running. Don't worry about it if you get this error.
6. (chroot) livecd / # vim /etc/conf.d/net
    - config_{INTERFACE}="dhcp"
    - You can find {INTERFACE} with "ls /sys/class/net"
7. (chroot) livecd / # cd /etc/init.d
8. (chroot) livecd /etc/init.d # ln -s net.lo net.{INTERFACE}
9. (chroot) livecd /etc/init.d # rc-update add net.{INTERFACE} default
10. (chroot) livecd /etc/init.d # vim /etc/hosts
    - 127.0.0.1     {HOSTNAME}.homenetwork      {HOSTNAME}  localhost
    - ::1           localhost
11. (chroot) livecd /etc/init.d # passwd
12. (chroot) livecd /etc/init.d # rc-update add sysklogd default
13. (chroot) livecd /etc/init.d # rc-update add NetworkManager default
14. (chroot) livecd /etc/init.d # rc-update add chronyd default
15. (chroot) livecd /etc/init.d # rc-update add elogind boot
16. (chroot) livecd /etc/init.d # rc-update add udev sysinit
17. (chroot) livecd /etc/init.d # /etc/init.d/dbus start
18. (chroot) livecd /etc/init.d # rc-update add dbus default
19. (chroot) livecd /etc/init.d # rc-update add cronie default

# Part VII: User Creation
1. (chroot) livecd /etc/init.d # useradd -m -G users,wheel,audio,video -s /bin/fish dishoungh
2. (chroot) livecd /etc/init.d # passwd dishoungh
3. (chroot) livecd /etc/init.d # usermod -aG video sddm
4. (chroot) livecd /etc/init.d # usermod -aG libvirt dishoungh
5. (chroot) livecd /etc/init.d # vim /etc/sudoers (I'm using doas instead but just for reference if I was to install sudo)
        - %wheel ALL=(ALL:ALL) ALL
        - dishoungh ALL=(root) NOPASSWD: /sbin/reboot
        - dishoungh ALL=(root) NOPASSWD: /sbin/halt
        - dishoungh ALL=(root) NOPASSWD: /sbin/poweroff
        - dishoungh ALL=(root) NOPASSWD: /sbin/shutdown
6. (chroot) livecd /etc/init.d # ln -s /opt/Bitwarden/bitwarden /usr/bin/bitwarden
7. (chroot) livecd /etc/init.d # vim /etc/conf.d/display-manager
    - CHECKVT=7
    - DISPLAYMANAGER="sddm"
8. (chroot) livecd /etc/init.d # vim /etc/libvirt/libvirtd.conf
    - Uncomment these lines
        - auth_unix_ro = "none"
        - auth_unix_rw = "none"
        - unix_sock_group = "libvirt"
        - unix_sock_ro_perms = "0777"
        - unix_sock_rw_perms = "0770"
9. (chroot) livecd /etc/init.d # rc-update add libvirtd default

# Part VIII: Bootloader and Reboot
1. (chroot) livecd /etc/init.d # cd / && echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf (DON'T DO THIS IF YOU COPIED ALREADY)
2. (chroot) livecd / # cp /gentoo-config/Gentoo/Every_File_For_Transfer/05-default-grub /etc/default/grub
2. (chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot --removable
3. (chroot) livecd / # vim /etc/default/grub (If it hasn't been copied already)
    - GRUB_DISABLE_LINUX_UUID=true
    - GRUB_DISABLE_LINUX_PARTUUID=false
4. (chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg
5. (chroot) livecd / # exit
6. livecd /mnt/gentoo # cd
7. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
8. livecd ~ # umount -R /mnt/gentoo
9. livecd ~ # reboot

# Part IX: Finishing Touches
1. Login
2. dishoungh@trinity ~> doas cp /gentoo-config/Gentoo/Every_File_For_Transfer/10-vimrc ~/.vimrc
3. dishoungh@trinity ~> doas cp /gentoo-config/Gentoo/Every_File_For_Transfer/13-config.fish ~/.config/fish/fish.config
4. dishoungh@trinity ~> doas rc-update add display-manager default
5. dishoungh@trinity ~> doas rc-service display-manager start
