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
10. (chroot) livecd / # eselect profile set 8 (Select whichever one that has plasma/openrc)
11. (chroot) livecd / # emerge -1 sys-libs/glibc
12. (chroot) livecd / # emerge --noreplace app-editors/nano
13. (chroot) livecd / # emerge -uvDN @world
14. (chroot) livecd / # emerge -vq acct-group/libvirt app-admin/bitwarden-desktop-bin app-admin/doas app-admin/sysklogd app-arch/lz4 app-backup/timeshift app-editors/nano app-editors/vim app-emulation/libvirt app-emulation/qemu app-emulation/virt-manager app-emulation/vkd3d-proton app-misc/neofetch app-misc/screen app-office/libreoffice app-portage/gentoolkit app-shells/fish dev-qt/qtwebengine dev-util/ccache games-emulation/dolphin games-emulation/pcsx2 games-util/steam-meta gui-libs/display-manager-init kde-plasma/plasma-meta kde-plasma/sddm-kcm media-fonts/fonts-meta media-gfx/feh media-plugins/alsa-plugins media-sound/audacity media-sound/pavucontrol media-sound/pulseaudio media-sound/spotify media-video/libva-utils media-video/obs-studio media-video/pipewire media-video/vlc net-fs/samba net-im/discord net-misc/chrony net-misc/dhcpcd net-misc/netifrc net-misc/networkmanager net-misc/openssh sys-apps/lm-sensors sys-apps/pciutils sys-apps/usbutils sys-auth/pambase sys-boot/efibootmgr sys-boot/grub:2 sys-boot/os-prober sys-devel/llvm sys-fs/btrfs-progs sys-fs/dosfstools sys-fs/udisks sys-kernel/gentoo-sources sys-kernel/linux-firmware sys-power/suspend sys-process/cronie sys-process/htop sys-process/lsof virtual/wine www-client/chromium x11-apps/mesa-progs x11-apps/setxkbmap x11-apps/xhost x11-apps/xrandr x11-apps/xsetroot x11-base/xorg-drivers x11-base/xorg-server x11-drivers/xf86-video-amdgpu x11-misc/sddm x11-misc/sxhkd
10. (chroot) livecd / # emerge -ac
11. (chroot) livecd / # echo "America/Chicago" > /etc/timezone
12. (chroot) livecd / # emerge --config sys-libs/timezone-data
13. (chroot) livecd / # vim /etc/locale.gen
    - Uncomment:
        - en_US ISO-8859-1
        - en_US.UTF-8 UTF-8
14. (chroot) livecd / # locale-gen
15. (chroot) livecd / # eselect locale set 6
    - This selects en_US.utf8
16. (chroot) livecd / # env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
17. (chroot) livecd / # eselect kernel list
18. (chroot) livecd / # eselect kernel set (KERNEL)
19. Copy kernel config to /usr/src/linux
20. Make sure settings are in using `make menuconfig` (Make sure there are no modules)
21. BUILD NVME DRIVERS IN KERNEL!!!!!! The current config doesn't support it.
21. (chroot) livecd /usr/src/linux # make && make install (There should be no modules)
22. (chroot) 






# Part IV: Fstab + Networking
1. (chroot) livecd / # vim /etc/fstab (COPY FSTAB)
    - \# Boot Partition
    - PARTUUID={BOOT}    /boot   vfat    defaults    1 2
    - \# Swap Partition
    - PARTUUID={SWAP}    none    swap    sw          0 0
    - \# Root Partition
    - PARTUUID={ROOT}    /       ext4    noatime     0 1
    - (INCLUDE SECONDARY MOUNTS HERE: COPY FILE FROM ARCH BUILD)
2. (chroot) livecd / # vim /etc/conf.d/hostname
    - hostname="trinity"
3. (chroot) livecd / # rc-update add dhcpcd default
4. (chroot) livecd / # rc-service dhcpcd start
    - /sbin/dhcpcd may be already running so it may spit out an error about the DHCP Client Daemon already running. Don't worry about it if you get this error.
6. (chroot) livecd / # vim /etc/conf.d/net
    - config_{INTERFACE}="dhcp"
    - You can find {INTERFACE} with "ls /sys/class/net"
7. (chroot) livecd / # cd /etc/init.d
8. (chroot) livecd /etc/init.d # ln -s net.lo net.enp6s0
9. (chroot) livecd /etc/init.d # rc-update add net.enp6s0 default
10. (chroot) livecd /etc/init.d # vim /etc/hosts
    - 127.0.0.1     trinity.homenetwork      trinity  localhost
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

# Part V: Bootloader and Reboot
1. (chroot) livecd /etc/init.d # cd / && echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf (DON'T DO THIS IF YOU COPIED ALREADY)
2. (chroot) livecd / # Copy grub default config
2. (chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot --removable
3. (chroot) livecd / # vim /etc/default/grub
    - GRUB_DISABLE_LINUX_UUID=true
    - GRUB_DISABLE_LINUX_PARTUUID=false
4. (chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg
5. (chroot) livecd / # exit
6. livecd /mnt/gentoo # cd
7. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
8. livecd ~ # umount -R /mnt/gentoo
9. livecd ~ # reboot

# Part VI: User Administration and Desktop Installation
1. nexus2 ~ # cd /
2. nexus2 / # useradd -m -G users,wheel,audio,video -s /bin/bash dishoungh
3. nexus2 / # passwd dishoungh
4. nexus2 / # emerge -avq app-admin/doas
5. nexus2 / # vim /etc/doas.conf (COPY DOAS.CONF FILE)
    - permit :wheel
6. nexus2 / # vim /etc/portage/package.accept_keywords **COPY files**
    - \# app-admin
    - app-admin/bitwarden-desktop-bin
    
    - \# app-emulation
    - app-emulation/vkd3d-proton
    
    - \# games-util
    - games-util/game-device-udev-rules
    - games-util/lutris
    - games-util/xpadneo

    - \# media-video
    - media-video/makemkv
    - media-video/obs-studio

    - \# net-im
    - net-im/discord-bin
    
    - \# overlays
    - \*/\*::pf4public
    - \*/\*::steam-overlay
10. nexus2 / # eselect repository enable steam-overlay
11. nexus2 / # emerge --sync
12. nexus2 / # emerge -auvDN @world
13. nexus2 / # emerge -avq x11-base/xorg-server app-shells/fish media-fonts/fonts-meta www-client/firefox-bin sys-fs/udisks x11-base/xorg-drivers net-im/discord app-office/libreoffice-bin x11-apps/setxkbmap media-video/vlc media-video/obs-studio games-util/steam-meta virtual/wine games-emulation/dolphin games-emulation/pcsx2 app-emulation/qemu app-emulation/libvirt app-emulation/virt-manager app-admin/bitwarden-desktop-bin media-video/makemkv media-video/handbrake app-emulation/vkd3d-proton media-sound/pavucontrol media-sound/pulseaudio  media-video/pipewire media-plugins/alsa-plugins app-misc/screen net-misc/openssh net-fs/samba media-sound/audacity app-misc/neofetch x11-apps/mesa-progs x11-apps/xrandr
    - To rectify "The following USE changes are necessary to proceed" do this:
        - Add the USE flags needed in the /etc/portage/package.use file
        - Use COPIED FILES to INSTALL MISSING PACKAGES
14. Copy these files to their respective locations (You may want to temporarily comment out any calls to start the window manager since it's not installed yet)
    - vimrc
    - User Xinitrc
    - System Xinitrc
    - User fish shell config
    - User .profile (You may want to temporarily comment out startx since dwm isn't installed yet)
    - X11 Config (xorg.conf)
14. nexus2 / # ln -s /opt/Bitwarden/bitwarden /usr/bin/bitwarden
14. nexus2 / # emerge -ac
15. nexus2 / # usermod -aG video sddm
16. nexus2 / # usermod -aG libvirt dishoungh
17. nexus2 / # vim /etc/libvirt/libvirtd.conf
    - Uncomment these lines
        - auth_unix_ro = "none"
        - auth_unix_rw = "none"
        - unix_sock_group = "libvirt"
        - unix_sock_ro_perms = "0777"
        - unix_sock_rw_perms = "0770"
18. nexus2 / # rc-service libvirtd start
19. nexus2 / # rc-update add libvirtd default
24. nexus2 / # reboot
25. dishoungh@nexus2 ~ # chsh -s $(which fish)

## Finishing It Off
1. Clone customized packages into ~/Custom_Packages
2. Go into each and `make clean install`
3. Go into the files that dwm or startx were commented out and uncomment.
4. It should work.
