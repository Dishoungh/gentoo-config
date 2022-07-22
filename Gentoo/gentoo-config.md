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
    - MAKEOPTS="-j16 -l16"
    - PORTAGE_NICENESS=1
    - EMERGE_DEFAULT_OPTS="--jobs=16 --load-average=16 --with-bdeps=y --complete-graph=y"
    - ACCEPT_KEYWORDS="~amd64"
    - ACCEPT_LICENSE="*"
    - VIDEO_CARDS="nvidia"
    - ABI_X86="64 32"
    - QEMU_SOFTMMU_TARGETS="arm x86_64 sparc"
    - QEMU_USER_TARGETS="x86_64"
    - USE="-systemd -gnome networkmanager sddm pipewire X kde pipewire-alsa xinerama -gpm elogind dbus osmesa vulkan -verify-sig"
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
11. (chroot) livecd / # mount (BOOT) /boot
12. (chroot) livecd / # lsblk
    - Check to make sure the boot and root partitions are properly mounted

# Part III: Configuring Portage and Installing Core Packages
1. (chroot) livecd / # emerge-webrsync && emerge --sync --quiet
2. (chroot) livecd / # rm -rf /etc/portage/package.*/
3. (chroot) livecd / # touch /etc/portage/package.use /etc/portage/package.accept_keywords /etc/portage/package.mask
4. (chroot) livecd / # nano /etc/portage/package.use
    - sys-auth/pambase -passwdqc
5. (chroot) livecd / # emerge -avq app-portage/cpuid2cpuflags
6. (chroot) livecd / # echo "\*/\* $(cpuid2cpuflags)" >> /etc/portage/package.use
7. (chroot) livecd / # emerge -1 sys-libs/glibc
8. (chroot)) livecd / # emerge -uqDN @world
9. (chroot) livecd / # emerge -avqn sys-kernel/gentoo-sources sys-kernel/dracut sys-kernel/linux-firmware sys-apps/pciutils net-misc/dhcpcd app-admin/sysklogd sys-fs/e2fsprogs sys-fs/dosfstools sys-fs/btrfs-progs sys-boot/grub:2 sys-boot/efibootmgr sys-boot/os-prober net-misc/chrony net-misc/networkmanager sys-apps/usbutils app-editors/vim app-arch/lz4 dev-vcs/git sys-process/cronie
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

# Part IV: Kernel Configuration & Build
Since manual configuration is very expansive and showing every single option will be way too tedious, even more than this already is. I'll just show what I think would be the most important settings, especially the ones I changed.

"-X-" means that the option was automatically selected as built-in and I can't deselect the option (I think).

"( )" means that the option is excluded from the kernel.

1. (chroot) livecd / # eselect kernel set 1
2. (chroot) livecd / # cd /usr/src/linux && make menuconfig
    - General setup --->
        - Kernel compression mode (LZ4) --->
        - (nexus2) Default hostname
        - Timers subsystem --->
            - Timer tick handling (Periodic timer ticks (constant rate, no dynticks)) --->
            - ( ) Old Idle dynticks config
            - [*] High Resolution Timer Support
        - [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
        - ( ) Support initial ramdisk/ramfs compressed using gzip
        - ( ) Support initial ramdisk/ramfs compressed using bzip2
        - ( ) Support initial ramdisk/ramfs compressed using LZMA
        - ( ) Support initial ramdisk/ramfs compressed using XZ
        - ( ) Support initial ramdisk/ramfs compressed using LZO
        - [*] Support initial ramdisk/ramfs compressed using LZ4
        - ( ) Support initial ramdisk/ramfs compressed using ZSTD
    - [*] 64-bit kernel
    - Processor type and features --->
        - [*] Symmetric multi-processing support
        - [*] Support x2apic
        - [*] AMD ACPI2Platform devices support
        - [*] Linux guest support --->
            - [*] Enable paravirtualization code
            - [*] KVM Guest support (including kvmclock) (NEW)
        - Processor family (Opteron/Athlon64/Hammer/K8) --->
        - (16) Maximum number of CPUs
        - [*] Multi-core scheduler support
        - [*] Machine Check / overheating reporting
        - ( ) Intel MCE features
        - [*] AMD MCE features
        - Performance monitoring --->
            - [*] Intel uncore performance events
            - [*] Intel/AMD rapl performance events
            - [*] Intel cstate performance events
            - [*] AMD Processor Power Reporting Mechanism
            - [*] AMD Uncore performance events
        - ( ) Intel microcode loading support
        - [*] AMD microcode loading support
        - -X- MTRR (Memory Type Range Register) support
        - ( ) Memory Protection Keys
        - [*] EFI runtime service support
        - [*] EFI stub support
        - [*] EFI mixed-mode support
    - Power management and ACPI options --->
        - CPU Frequency scaling --->
            - Default CPUFreq governor (performance) ---> (For some reason, it won't let me change it to "ondemand", which is what the guide recommends for Ryzen)
            - [*] 'ondemand' cpufreq policy governor
            - [*] ACPI Processor P-States driver
            - [*] Legacy cpb sysfs knob support for AMD CPUs
            - ( ) AMD Opteron/Athlon64 PowerNow!
            - [*] AMD frequency sensitivity feedback powersave bias
    - Bus options (PCI etc.) --->
    - Binary Emulations ---> 
        - [*] IA32 Emulation
        - [*] x32 ABI for 64-bit mode
    - [*] Virtualization --->
        - [*] Kernel-based Virtual Machine (KVM) support
        - [*] KVM for AMD processors support
    - General architecture-dependent options --->
    - [*] Enable loadable module support --->
    - -X- Enable the block layer --->
        - Partition Types --->
            - [*] Advanced partition selection
            - ( ) PC BIOS (MSDOS partition tables) support (NEW)
            - [*] EFI GUID Partition support (NEW)
    - IO Schedulers --->
        - [*] BFQ I/O scheduler
    - Executable file formats --->
    - Memory Management options --->
    - [*] Networking support --->
        - Networking options --->
            - [*] 802.1d Ethernet Bridging
            - [*] Network packet filtering framework (Netfilter) --->
                - [*] Advanced netfilter configuration
                - Core Netfilter Configuration --->
                    - [*] "conntrack" connection tracking match support
                    - [*] CHECKSUM target support
                - IP: Netfilter Configuration --->
                    - [*] iptables NAT support 
                - [*] Ethernet Bridge tables (ebtables) support --->
                    - [*] ebt: nat table support
                    - [*] ebt: mark filter support
            - [*] QoS and/or fair queueing --->
                - [*] Hierarchical Token Bucket (HTB)
                - [*] Stochastic Fairness Queueing (SFQ)
                - [*] Ingress/classifier-action Qdisc
                - [*] Netfilter mark (FW)
                - [*] Universal 32bit comparisons w/ hashing (U32)
                - [*] Actions
                - [*] Traffic Policing
    - Device Drivers --->
        - PCI support --->
            - -X- VGA Arbitration
            - (2) Maximum number of GPUs
        - Generic Driver Options --->
            - Firmware loader --->
                - (amd-ucode/microcode_amd_fam17h.bin) Build named firmware blobs into the kernel binary
                - (/lib/firmware) Firmware blobs root directory (NEW)
        - Firmware Drivers
            - -X- iSCSI Boot Firmware Table Attributes
            - [*] iSCSI Boot Firmware Table Attributes module
            - [*] Mark VGA/VBE/EFI FB as generic system framebuffer
        - NVME Support --->
            - [*] NVM Express block device
        - SCSI device support
            - [*] SCSI disk support
            - ( ) SCSI tape support
            - ( ) SCSI CDROM support
            - [*] SCSI generic support
            - [*] SCSI low-level drivers --->
            - [*] SCSI Device Handlers --->
        - [*] Serial ATA and Parallel ATA drivers (libata) --->
            - [*] AHCI SATA support
            - [*] Platform AHCI SATA support
            - [*] Generic ATA Support
        - ( ) Multiple devices driver support (RAID and LVM)
        - ( ) Macintosh device drivers
        - Network device support
            - [*] Network core driver support
            - [*] Universal TUN/TAP device driver support
            - [*] Ethernet driver support --->
                - ( ) Disable everything except intel
                - [*] Intel (82586/82593/82596) devices
                - [*] Intel devices
                - [*] Intel(R) PRO/100+ support
                - [*] Intel(R) PRO/1000 Gigabit Ethernet support
                - [*] Intel(R) PRO/10GbE support
                - [*] Intel(R) Ethernet Controller XL710 Family support
                - [*] Intel(R) Ethernet Connection E800 Series Support
                - [*] Intel(R) Ethernet Controller I225-LM/I225-V support
            - ( ) Wireless LAN
        - Input device support --->
            - [*] Joysticks/Gamepads --->
                - [*] X-Box gamepad support
                - [*] X-Box gamepad rumble support
            - ( ) Tablets
            - ( ) Touchscreens
        - Character devices
            - [*] IPMI top-level message handler
        - Hardware Monitoring support
            - [*] AMD Family 10h+ temperature sensor
            - [*] AMD Family 15h processor power
            - [*] NZXT Kraken X42/X51/X62/X72 liquid coolers
        - Graphics support --->
            - [*] /dev/agpgart (AGP Support) --->
            - ( ) Intel xxx/9xx/G3x/G4x/HD Graphics
            - [*] Simple framebuffer driver
            - Frame buffer Devices --->
                - [*] Support for frame buffer devices --->
        - [*] Sound card support --->
            - [*] Advanced Linux Sound Architecture --->
                - [*] USB sound devices --->
                    - [*] USB Audio/MIDI driver
                    - [*] Virtio sound driver
        - HID support
            - -X- HID bus support
            - [*] Battery level reporting for HID devices
        - [*] Virtualization drivers --->
        - ( ) Virtio drivers
        - [*] VHOST drivers --->
            - [*] Host kernel accelerator for virtio net
        - ( ) X86 Platform Specific Device Drivers
        - ( ) Microsoft Surface Platform-Specific Device Drivers
        - [*] IOMMU Hardware Support --->
            - [*] AMD IOMMU support
            - [*] AMD IOMMU Version 2 driver
            - [*] Virtio IOMMU driver
    - File systems --->
        - [ ] Second extended fs support
        - [ ] The Extended 3 (ext3) filesystem
        - [*] The Extended 4 (ext4) filesystem
        - [ ] Reiserfs support
        - [ ] JFS filesystem support
        - [ ] XFS filesystem support
        - [*] Btrfs filesystem support
        - DOS/FAT/EXFAT/NT Filesystems --->
            - [*] MSDOS fs support
            - [*] VFAT (Windows-95) fs support
        - Pseudo filesystems
            - -X- /proc file system support
            - -X- Tmpfs virtual memory file system support
            - [*] EFI Variable filesystem
        - Network File Systems
            - [*] Network File Systems --->
                - [*] SMB3 and CIFS support (advanced network filesystem)
    - Security options --->
    - -X- Cryptographic API --->
    - Library routines --->
    - Kernel hacking --->
    - Gentoo Linux --->
3. (chroot) livecd /usr/src/linux # make modules_prepare && make && make modules_install && make install
4. (chroot) livecd /usr/src/linux # emerge -avq x11-drivers/nvidia-drivers
5. (chroot) livecd /usr/src/linux # dracut --kver=(VERSION)-gentoo --force && cd /

# Part V: Fstab + Networking
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

# Part VI: Bootloader and Reboot
1. (chroot) livecd /etc/init.d # cd / && echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
2. (chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot --removable
3. (chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg
4. (chroot) livecd / # exit
5. livecd /mnt/gentoo # cd
6. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
7. livecd ~ # umount -R /mnt/gentoo
8. livecd ~ # reboot

# Part VII: User Administration and Desktop Installation
1. nexus2 ~ # cd /
2. nexus2 / # useradd -m -G users,wheel,audio  dishoungh
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
7. nexus2 / # emerge -uDNpv @world
8. nexus2 / # emerge -auvDN @world
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
12. nexus2 / # emerge -avq x11-base/xorg-x11 app-shells/fish media-fonts/fonts-meta www-client/firefox-bin sys-fs/udisks x11-base/xorg-drivers kde-plasma/plasma-desktop x11-misc/sddm gui-libs/display-manager-init kde-plasma/sddm-kcm net-im/discord-bin app-office/libreoffice-bin x11-apps/setxkbmap media-video/vlc media-video/obs-studio games-util/steam-meta virtual/wine games-emulation/dolphin games-emulation/pcsx2 app-emulation/qemu app-emulation/libvirt app-emulation/virt-manager app-admin/bitwarden-desktop-bin media-video/makemkv media-video/handbrake app-emulation/vkd3d-proton media-video/pipewire app-misc/screen net-misc/openssh net-fs/samba media-sound/audacity app-misc/neofetch kde-plasma/systemsettings kde-plasma/plasma-workspace-wallpapers kde-plasma/powerdevil kde-plasma/systemmonitor kde-plasma/plasma-nm kde-plasma/libkscreen kde-plasma/kwin kde-plasma/kwayland-server kde-plasma/ksystemstats kde-plasma/kscreen kde-plasma/kscreenlocker kde-plasma/kdeplasma-addons kde-plasma/kmenuedit kde-plasma/drkonqi kde-plasma/hotkeys kde-plasma/kgamma kde-plasma/kde-gtk-config kde-plasma/kdecoration kde-plasma/discover kde-apps/ark kde-apps/dolphin kde-apps/filelight kde-apps/gwenview kde-apps/kate kde-apps/kdenlive kde-apps/konsole kde-apps/okular kde-apps/spectacle
    - To rectify "The following USE changes are necessary to proceed" do this:
        - Add the USE flags needed in the /etc/portage/package.use file
13. nexus2 / # usermod -aG video sddm
14. nexus2 / # usermod -aG libvirt dishoungh
15. nexus2 / # usermod -s /usr/bin/fish dishoungh
16. nexus2 / # vim /etc/libvirt/libvirtd.conf
    - Uncomment these lines
        - auth_unix_ro = "none"
        - auth_unix_rw = "none"
        - unix_sock_group = "libvirt"
        - unix_sock_ro_perms = "0777"
        - unix_sock_rw_perms = "0770"
17. nexus2 / # rc-service libvirtd start
18. nexus2 / # rc-update add libvirtd default
22. nexus2 / # vim /etc/conf.d/display-manager
    - CHECKVT=7
    - DISPLAYMANAGER="sddm"
23. nexus2 / # rc-update add display-manager default
24. nexus2 / # rc-service display-manager start

# Part VIII: Post Installation

Reboot

