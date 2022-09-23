# Hardware (UEFI)

- CPU: Ryzen 7 2700X (8 Cores / 16 Threads)
- RAM: 32 GB (DDR4-3200)
- GPU: Nvidia Geforce GTX 1080 Ti
- Storage: Samsung 850 EVO (250GB SATA SSD)
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
16. livecd /mnt/gentoo # nano /mnt/gentoo/etc/portage/make.conf
    - CHOST="x86_64-pc-linux-gnu"
    - COMMON_FLAGS="-O2 -march=znver1 -pipe"
    - MAKEOPTS="-j14 -l14"
    - PORTAGE_NICENESS=19
    - EMERGE_DEFAULT_OPTS="--jobs=16 --load-average=14 --with-bdeps=y --complete-graph=y"
    - ACCEPT_KEYWORDS="amd64"
    - ACCEPT_LICENSE="*"
    - VIDEO_CARDS="nvidia"
    - ABI_X86="64 32"
    - QEMU_SOFTMMU_TARGETS="arm x86_64 sparc"
    - QEMU_USER_TARGETS="x86_64"
    - INPUT_DEVICES="udev libinput joystick"
    - PYTHON_TARGETS="python3_11 python3_10 python3_9"
    - FEATURES="ccache"
    - CCACHE_DIR="/var/cache/ccache"
    - USE="-bluetooth -systemd -gnome networkmanager sddm pipewire X kde pipewire-alsa xinerama -gpm dist-kernel elogind dbus osmesa vulkan -verify-sig"
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
2. (chroot) livecd / # rm -rf /etc/portage/package.*/
3. (chroot) livecd / # touch /etc/portage/package.use /etc/portage/package.accept_keywords /etc/portage/package.mask
4. (chroot) livecd / # nano /etc/portage/package.use
    - sys-auth/pambase -passwdqc
    - sys-kernel/gentoo-kernel savedconfig
    - sys-boot/grub mount
5. (chroot) livecd / # emerge -avq app-portage/cpuid2cpuflags
6. (chroot) livecd / # echo "\*/\* $(cpuid2cpuflags)" >> /etc/portage/package.use
7. (chroot) livecd / # emerge -1 sys-libs/glibc
8. (chroot)) livecd / # emerge -auvDN @world
9. (chroot) livecd / # emerge -avq sys-kernel/gentoo-kernel sys-kernel/dracut sys-kernel/linux-firmware sys-apps/pciutils net-misc/dhcpcd app-admin/sysklogd sys-fs/e2fsprogs sys-fs/dosfstools sys-fs/btrfs-progs sys-boot/grub:2 sys-boot/efibootmgr sys-boot/os-prober net-misc/chrony net-misc/networkmanager sys-apps/usbutils app-editors/vim app-arch/lz4 dev-vcs/git sys-process/cronie app-eselect/eselect-repository x11-drivers/nvidia-drivers
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
    - Make sure linux-*-gentoo-dist is selected

# Part IV: Fstab + Networking
1. (chroot) livecd / # vim /etc/fstab
    - \# Boot Partition
    - UUID={BOOT}    /boot   vfat    defaults    1 2
    - \# Swap Partition
    - UUID={SWAP}    none    swap    sw          0 0
    - \# Root Partition
    - UUID={ROOT}    /       ext4    noatime     0 1
2. (chroot) livecd / # vim /etc/conf.d/hostname
    - hostname="nexus2"
3. (chroot) livecd / # rc-update add dhcpcd default
4. (chroot) livecd / # rc-service dhcpcd start
    - /sbin/dhcpcd may be already running so it may spit out an error about the DHCP Client Daemon already running. Don't worry about it if you get this error.
5. (chroot) livecd / # emerge -an net-misc/netifrc
6. (chroot) livecd / # vim /etc/conf.d/net
    - config_{INTERFACE}="dhcp"
    - You can find {INTERFACE} with "ls /sys/class/net"
7. (chroot) livecd / # cd /etc/init.d
8. (chroot) livecd /etc/init.d # ln -s net.lo net.enp6s0
9. (chroot) livecd /etc/init.d # rc-update add net.enp6s0 default
10. (chroot) livecd /etc/init.d # vim /etc/hosts
    - 127.0.0.1     nexus2.homenetwork      nexus2  localhost
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
1. (chroot) livecd /etc/init.d # cd / && echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
2. (chroot) livecd / # emerge --config sys-kernel/gentoo-kernel
2. (chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot --removable
3. (chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg
    - Change all the instances of the root UUID in this file to the PARTUUID version and change root=UUID= to root=PARTUUID=. I don't know why, but it just works for me. I would like to address this to where I don't have to do that, but somehow, doing this fixes Kernel panics for me.
4. (chroot) livecd / # exit
5. livecd /mnt/gentoo # cd
6. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
7. livecd ~ # umount -R /mnt/gentoo
8. livecd ~ # reboot

# Part VII: User Administration and Desktop Installation
1. nexus2 ~ # cd /
2. nexus2 / # useradd -m -G users,wheel,audio,video -s /bin/bash dishoungh
3. nexus2 / # passwd dishoungh
4. nexus2 / # emerge -avq app-admin/sudo
5. nexus2 / # vim /etc/sudoers
    - %wheel ALL=(ALL:ALL) ALL
    - dishoungh  ALL=(root) NOPASSWD: /sbin/reboot
    - dishoungh  ALL=(root) NOPASSWD: /sbin/halt
    - dishoungh  ALL=(root) NOPASSWD: /sbin/poweroff
    - dishoungh  ALL=(root) NOPASSWD: /sbin/shutdown
    - Add alias command='sudo command' lines in /home/(USER)/.bashrc
6. nexus2 / # eselect profile set 8
    - This selects default/linux/amd64/17.1/desktop/plasma (stable)
7. nexus2 / # emerge -auvDN @world
8. nexus2 / # vim /etc/portage/package.accept_keywords
    - \# app-admin
    - app-admin/bitwarden-desktop-bin
    
    - \# app-emulation
    - app-emulation/vkd3d-proton
    
    - \# games-util
    - games-util/game-device-udev-rules

    - \# media-video
    - media-video/makemkv
    - media-video/obs-studio

    - \# net-im
    - net-im/discord-bin
    
    - \# overlays
    - \*/\*::pf4public
    - \*/\*::steam-overlay
9. nexus2 / # eselect repository enable pf4public
10. nexus2 / # eselect repository enable steam-overlay
11. nexus2 / # emerge --sync
12. nexus2 / # emerge -avq x11-base/xorg-x11 app-shells/fish media-fonts/fonts-meta www-client/ungoogled-chromium-bin sys-fs/udisks x11-base/xorg-drivers kde-plasma/plasma-meta kde-apps/kdecore-meta kde-apps/kdegraphics-meta kde-apps/kdemultimedia-meta kde-apps/kdenetwork-meta kde-apps/kdeutils-meta x11-misc/sddm gui-libs/display-manager-init kde-plasma/sddm-kcm net-im/discord-bin app-office/libreoffice-bin x11-apps/setxkbmap media-video/vlc media-video/obs-studio games-util/steam-meta virtual/wine games-emulation/dolphin games-emulation/pcsx2 app-emulation/qemu app-emulation/libvirt app-emulation/virt-manager app-admin/bitwarden-desktop-bin media-video/makemkv media-video/handbrake app-emulation/vkd3d-proton media-video/pipewire app-misc/screen net-misc/openssh net-fs/samba media-sound/audacity app-misc/neofetch x11-apps/mesa-progs
    - To rectify "The following USE changes are necessary to proceed" do this:
        - Add the USE flags needed in the /etc/portage/package.use file
13. nexus2 / # emerge -ac
14. nexus2 / # usermod -aG video sddm
15. nexus2 / # usermod -aG libvirt dishoungh
16. nexus2 / # vim /etc/libvirt/libvirtd.conf
    - Uncomment these lines
        - auth_unix_ro = "none"
        - auth_unix_rw = "none"
        - unix_sock_group = "libvirt"
        - unix_sock_ro_perms = "0777"
        - unix_sock_rw_perms = "0770"
17. nexus2 / # rc-service libvirtd start
18. nexus2 / # rc-update add libvirtd default
19. nexus2 / # vim /etc/conf.d/display-manager
    - CHECKVT=7
    - DISPLAYMANAGER="sddm"
20. nexus2 / # rc-update add display-manager default
21. nexus2 / # emerge -avq sys-kernel/gentoo-kernel
22. nexus2 / # emerge --config sys-kernel/gentoo-kernel
23. nexus2 / # reboot
