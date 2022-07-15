# Backstory (don't read this unless you actually want to lol)

I have installed Gentoo (barely) on a virtual machine on a Arch Linux host. That's the "gentoo-vm-config" you'll see in this repo. One day, I wanted to get rid of my Windows 10 that was installed in one of my SSDs because I wasn't really using it anymore. My Arch Linux host was on my M.2 SSD. Unfortunately, while trying to install Gentoo on my SATA SSD, it somehow corrupted my Arch Linux (my main OS). It's not a big deal since, actually:

1. I have a back up of all the critical stuff on an external hard drive thankfully
2. I messed up my partitions in my Arch and it's been bothering me for 2 years now so I guess now is the time to try something new

Yeah, this means I can't use my desktop right now but meh, I don't care. Point is, I can get all my stuff back in case if you were wondering :)

Now, I'm trying to move to Gentoo and try it out on baremetal. I find Gentoo cool and want to see if I can main it for a while.

Since my stuff is all messed up, I'll do this in the same way I did to build my virtual machine. Document everything I'm doing on a Github README and cry out for help when I need it 😂

# Hardware (UEFI of course)

- CPU: Ryzen 7 2700X (8 Cores / 16 Threads)
- RAM: 32 GB (DDR4-3200)
- GPU: Nvidia Geforce GTX 1080 Ti
- Storage: Samsung 960 EVO (500GB M.2 SSD)
- Monitors: 3x 2560x1440p Monitors (G-Sync IPS 1ms)

I have 3 other storage drives but I'll be using those as extra storage drives for VMs and other stuff. I'm including the information about the 3 monitors I'm using just in case if it would be important.

I'm employing these recommendations as well: ![image](https://user-images.githubusercontent.com/47036723/178797920-0b63ea1c-76be-4874-bf58-3ee5aa91ad9b.png)

# What I Want

Basically a similar desktop to my Arch build. I don't really use much. Here's pretty much all I want

1. KDE Plasma Desktop Environment (with Konsole as my terminal and of course Dolphin as my file explorer; pretty sure that comes with the package by default)
2. Want to be able to get back my Sweet theme (the cool looking neon theme)
3. Steam (need to play games of course; as far as I remember, I had to install proton, wine, vulkan, vulkan-headers, and other things related to that)
4. To be able to use QEMU/KVM + Virt-Manager to use virtual machines

I'll try to build Gentoo to meet these requirements. My intended init system will be OpenRC since that is what I used for my vm last time and I will try to switch to pipewire (something I should have done a long time ago; I'm sick of PulseAudio). There are other stuff I would want to do with my Gentoo build, but that will be later. This are my goals for right now. Most of the steps I use come from #2 in Resources.

Yes, my kernel will be custom. Yes, I know there are pre-made kernels but I want to make my own. Why? Because I have no life. I don't know.

# Part I: Booting into the USB Boot Media

1. Downloaded install-amd64-minimal-20220710T170538Z.iso
2. Used Rufus to make USB drive into boot media
3. Booted into LiveCD.
4. livecd ~ # ping www.gentoo.org -c3
5. livecd ~ # lsblk
    - ![WIN_20220711_12_04_46_Pro](https://user-images.githubusercontent.com/47036723/178319092-600d8d9e-3680-4ec5-9c02-eec2ff63f696.jpg)
6. livecd ~ # fdisk /dev/nvme0n1
    - ![WIN_20220711_12_10_08_Pro](https://user-images.githubusercontent.com/47036723/178319900-f39c6671-f853-49a7-833b-7151332ffaf5.jpg)  
7. livecd ~ # mkfs.vfat -F 32 /dev/nvme0n1p1
8. livecd ~ # mkfs.ext4 /dev/nvme0n1p3
9. livecd ~ # mkswap /dev/nvme0n1p2
10. livecd ~ # swapon /dev/nvme0n1p2
11. livecd ~ # mount /dev/nvme0n1p3 /mnt/gentoo
12. livecd ~ # cd /mnt/gentoo/
13. livecd /mnt/gentoo # wget https://mirror.leaseweb.com/gentoo/releases/amd64/autobuilds/20220710T170538Z/stage3-amd64-desktop-openrc-20220710T170538Z.tar.xz
14. livecd /mnt/gentoo # tar xpvf ./stage3-amd64-desktop-openrc-20220710T170538Z.tar.xz --xattrs-include="\*.\*" --numeric-owner
15. livecd /mnt/gentoo # rm -f ./stage3-amd64-desktop-openrc-20220710T170538Z.tar.xz
16. livecd /mnt/gentoo # nano /mnt/gentoo/etc/portage/make.conf
    - CHOST="x86_64-pc-linux-gnu"
    - COMMON_FLAGS="-O2 -march=znver1 -pipe"
    - MAKEOPTS="-j16 -l14"
    - PORTAGE_NICENESS=19
    - EMERGE_DEFAULT_OPTS="--jobs=16 --load-average=14 --with-bdeps=y --complete-graph=y"
    - ACCEPT_KEYWORDS="amd64"
    - ACCEPT_LICENSE="*"
    - VIDEO_CARDS="nvidia"
    - ABI_X86="64 32"
    - QEMU_SOFTMMU_TARGETS="arm x86_64 sparc"
    - QEMU_USER_TARGETS="x86_64"
    - USE="-systemd -gnome networkmanager sddm pipewire dist-kernel X kde pipewire-alsa xinerama -gpm elogind dbus osmesa vulkan"
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
11. (chroot) livecd / # mount /dev/nvme0n1p1 /boot

# Part III: Configuring Portage and Kernel
1. (chroot) livecd / # emerge-webrsync && emerge --sync
2. (chroot) livecd / # rm -rf /etc/portage/package.use/ && rm -rf /etc/portage/package.accept_keywords/ && rm -rf /etc/portage/package.mask/
3. (chroot) livecd / # touch /etc/portage/package.use && touch /etc/portage/package.accept_keywords && touch /etc/portage/package.mask
4. (chroot) livecd / # nano /etc/portage/package.use
    - sys-auth/pambase passwdqc
5. livecd / # emerge -avq app-portage/cpuid2cpuflags
6. (chroot) livecd / # echo "\*/\* $(cpuid2cpuflags)" >> /etc/portage/package.use
7. livecd / # emerge -1 sys-libs/glibc && emerge -uqDN @world
8. livecd / # emerge -avq sys-kernel/gentoo-kernel-bin  sys-kernel/linux-firmware sys-apps/pciutils net-misc/dhcpcd app-admin/sysklogd sys-fs/e2fsprogs sys-fs/dosfstools sys-boot/grub:2 net-misc/chrony net-misc/networkmanager x11-drivers/nvidia-drivers
9. (chroot) livecd / # echo "America/Chicago" > /etc/timezone
10. (chroot) livecd / # emerge --config sys-libs/timezone-data
11. (chroot) livecd / # nano /etc/locale.gen
    - Uncomment:
        - en_US ISO-8859-1
        - en_US.UTF-8 UTF-8
12. (chroot) livecd / # locale-gen
13. (chroot) livecd / # eselect locale set 6
    - This selects en_US.utf8
14. (chroot) livecd / # env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

# Part IV: Fstab + Networking
1. (chroot) livecd / # nano /etc/fstab
    - \# Boot Partition (/dev/nvme0n1p1)
    - UUID={nvme0n1p1}    /boot   vfat    defaults    1 2
    - \# Swap Partition (/dev/nvme0n1p2)
    - UUID={nvme0n1p2}    none    swap    sw          0 0
    - \# Root Partition (/dev/nvme0n1p3)
    - UUID={nvme0n1p3}    /       ext4    noatime     0 1
2. (chroot) livecd / # nano /etc/conf.d/hostname
    - hostname="nexus2"
3. (chroot) livecd / # rc-update add dhcpcd default
4. (chroot) livecd / # rc-service dhcpcd start
    - /sbin/dhcpcd may be already running so it may spit out an error about the DHCP Client Daemon already running. Don't worry about it if you get this error.
5. (chroot) livecd / # emerge --ask --noreplace net-misc/netifrc
6. (chroot) livecd / # nano /etc/conf.d/net
    - config_{INTERFACE}="dhcp"
    - You can find {INTERFACE} with "ls /sys/class/net"
7. (chroot) livecd / # cd /etc/init.d
8. (chroot) livecd /etc/init.d # ln -s net.lo net.enp6s0
9. (chroot) livecd /etc/init.d # rc-update add net.enp6s0 default
10. (chroot) livecd /etc/init.d # nano /etc/hosts
    - 127.0.0.1     nexus2.homenetwork      nexus2  localhost
    - ::1           localhost
11. (chroot) livecd /etc/init.d # passwd
12. (chroot) livecd /etc/init.d # rc-update add sysklogd default
13. (chroot) livecd /etc/init.d # rc-update add NetworkManager default
14. (chroot) livecd /etc/init.d # rc-update add chronyd default
15. (chroot) livecd /etc/init.d # rc-update add elogind boot
16. (chroot) livecd /etc/init.d # rc-update add udev sysinit
17. (chroot) livecd /etc/init.d # rc-update add dbus default

# Part V: Bootloader and Reboot
1. (chroot) livecd /etc/init.d # emerge --config gentoo-kernel-bin
2. (chroot) livecd /etc/init.d # cd / && echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
3. (chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot
4. (chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg
5. (chroot) livecd / # nano /etc/default/grub
    - Uncomment the line: GRUB_DISABLE_LINUX_UUID=true
6. (chroot) livecd / # exit
7. livecd /mnt/gentoo # cd
8. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
9. livecd ~ # umount -R /mnt/gentoo
10. livecd ~ # reboot

# Part VI: User Administration and Desktop Installation
1. nexus2 ~ # cd /
2. nexus2 / # useradd -m -G users,wheel,audio -s /bin/bash dishoungh
3. nexus2 / # passwd dishoungh
4. nexus2 / # emerge -avq app-admin/sudo app-editors/vim
5. nexus2 / # vim /etc/sudoers
    - %wheel ALL=(ALL:ALL) ALL
    - dishoungh  ALL=(root) NOPASSWD: /sbin/reboot
    - dishoungh  ALL=(root) NOPASSWD: /sbin/halt
    - dishoungh  ALL=(root) NOPASSWD: /sbin/poweroff
    - dishoungh  ALL=(root) NOPASSWD: /sbin/shutdown
6. nexus2 / # eselect profile set 8
    - This selects default/linux/amd64/17.1/desktop/plasma (stable)
7. nexus2 / # emerge -uDNpv @world
8. nexus2 / # emerge -uvDN @world
9. nexus2 / # vim /etc/portage/package.accept_keywords
    - \# app-admin
    - app-admin/bitwarden-desktop-bin
    
    - \# app-emulation
    - app-emulation/vkd3d-proton
    
    - \# games-util
    - games-util/lutris
    - games-util/game-device-udev-rules

    - \# media-tv
    - media-tv/plex-media-server

    - \# media-video
    - media-video/makemkv
    - media-video/obs-studio

    - \# net-im
    - net-im/discord-bin
    
    - \# steam-overlay
    - */*::steam-overlay
10. nexus2 / # emerge -avq app-eselect/eselect-repository dev-vcs/git
11. nexus2 / # eselect repository enable steam-overlay && emerge --sync
12. nexus2 / # emerge -avq x11-base/xorg-x11 media-fonts/fonts-meta www-client/firefox-bin sys-fs/udisks x11-base/xorg-drivers kde-plasma/plasma-meta kde-apps/kdecore-meta x11-misc/sddm gui-libs/display-manager-init kde-plasma/sddm-kcm net-im/discord-bin app-office/libreoffice-bin games-util/lutris x11-apps/setxkbmap kde-apps/kdegraphics-meta kde-apps/kdemultimedia-meta kde-apps/kdenetwork-meta kde-apps/kdeutils-meta media-video/vlc media-video/obs-studio games-util/steam-meta virtual/wine games-emulation/dolphin games-emulation/pcsx2 app-emulation/qemu app-emulation/libvirt app-emulation/virt-manager app-admin/bitwarden-desktop-bin media-video/makemkv media-video/handbrake media-tv/plex-media-server app-emulation/vkd3d-proton media-video/pipewire app-misc/screen net-misc/openssh net-fs/samba sys-apps/usbutils
    - To rectify "The following USE changes are necessary to proceed" do this:
        - Add the USE flags needed in the /etc/portage/package.use file
13. nexus2 / # usermod -aG video sddm
14. nexus2 / # usermod -aG libvirt dishoungh
15. nexus2 / # vim /etc/libvirt/libvirtd.conf
    - Uncomment these lines
        - auth_unix_ro = "none"
        - auth_unix_rw = "none"
        - unix_sock_group = "libvirt"
        - unix_sock_ro_perms = "0777"
        - unix_sock_rw_perms = "0770"
16. nexus2 / # rc-service libvirtd start
17. nexus2 / # rc-update add libvirtd default
22. nexus2 / # vim /etc/conf.d/display-manager
    - CHECKVT=7
    - DISPLAYMANAGER="sddm"
23. nexus2 / # rc-update add display-manager default
24. nexus2 / # rc-service display-manager start

# Part VII: Post Installation

# Resources
1. [Gentoo Downloads Page](https://www.gentoo.org/downloads/)
2. [Gentoo AMD64 Full Installation Guide](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation)
3. [Gentoo VM Gentoo "Guide"](https://github.com/Dishoungh/gentoo-config/blob/master/Gentoo/gentoo-vm-config.md)
4. [Tarball Directory](https://mirror.leaseweb.com/gentoo/releases/amd64/autobuilds/20220710T170538Z/)
5. [Ryzen Gentoo Wiki](https://wiki.gentoo.org/wiki/Ryzen)
6. [MAKEOPTS](https://wiki.gentoo.org/wiki/MAKEOPTS)
7. [Pipewire Packages](https://packages.gentoo.org/useflags/pipewire)
8. [NVIDIA Drivers Wiki](https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers)
9. [Virt-Manager Wiki](https://wiki.gentoo.org/wiki/Virt-manager)
10. [QEMU Wiki](https://wiki.gentoo.org/wiki/QEMU#BIOS_and_UEFI_firmware)
11. [Xorg Guide](https://wiki.gentoo.org/wiki/Xorg/Guide#Make.conf)
12. [ASUS ROG String X470-F Gaming Motherboard Page](https://rog.asus.com/us/motherboards/rog-strix/rog-strix-x470-f-gaming-model/)
13. [Gentoolkit Wiki](https://wiki.gentoo.org/wiki/Gentoolkit)
14. [KDE Apps](https://packages.gentoo.org/categories/kde-apps)
15. [Steam](https://wiki.gentoo.org/wiki/Steam)
16. [Wine](https://wiki.gentoo.org/wiki/Wine)
17. [SDDM](https://wiki.gentoo.org/wiki/SDDM)
18. [VLC](https://wiki.gentoo.org/wiki/VLC)
19. [KDE](https://wiki.gentoo.org/wiki/KDE)
