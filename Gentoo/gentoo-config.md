# Backstory (don't read this unless you actually want to lol)

I have installed Gentoo (barely) on a virtual machine on a Arch Linux host. That's the "gentoo-vm-config" you'll see in this repo. One day, I wanted to get rid of my Windows 10 that was installed in one of my SSDs because I wasn't really using it anymore. My Arch Linux host was on my M.2 SSD. Unfortunately, while trying to install Gentoo on my SATA SSD, it somehow corrupted my Arch Linux (my main OS). It's not a big deal since, actually:

1. I have a back up of all the critical stuff on an external hard drive thankfully
2. I messed up my partitions in my Arch and it's been bothering me for 2 years now so I guess now is the time to try something new

Yeah, this means I can't use my desktop right now but meh, I don't care. Point is, I can get all my stuff back in case if you were wondering :)

Now, I'm trying to move to Gentoo and try it out on baremetal. I find Gentoo cool and want to see if I can main it for a while.

Since my stuff is all messed up, I'll do this in the same way I did to build my virtual machine. Document everything I'm doing on a Github README and cry out for help when I need it 😂

# Hardware (UEFI of course)

CPU: Ryzen 7 2700X (8 Cores / 16 Threads)
RAM: 32 GB (DDR4-3200)
GPU: Nvidia Geforce GTX 1080 Ti
Storage: Samsung 960 EVO (500GB M.2 SSD)
Monitors: 3x 2560x1440p Monitors (G-Sync IPS 1ms)

I have 3 other storage drives but I'll be using those as extra storage drives for VMs and other stuff. I'm including the information about the 3 monitors I'm using just in case if it would be important.

# What I Want

Basically a similar desktop to my Arch build. I don't really use much. Here's pretty much all I want

1. KDE Plasma Desktop Environment (with Konsole as my terminal and of course Dolphin as my file explorer; pretty sure that comes with the package by default)
2. Want to be able to get back my Sweet theme (the cool looking neon theme)
3. Steam (need to play games of course; as far as I remember, I had to install proton, wine, vulkan, vulkan-headers, and other things related to that)
4. To be able to use QEMU/KVM + Virt-Manager to use virtual machines

I'll try to build Gentoo to meet these requirements. My intended init system will be OpenRC since that is what I used for my vm last time and I will try to switch to pipewire (something I should have done a long time ago; I'm sick of PulseAudio). There are other stuff I would want to do with my Gentoo build, but that will be later. This are my goals for right now. Most of the steps I use come from #2 in Resources.

# Part I: Booting into the USB Boot Media

1. Downloaded install-amd64-minimal-20220710T170538Z.iso from #1 in Resources
2. Used Rufus to make USB drive into boot media
3. Booted into "LiveCD". This is what it looks like:
    - ![WIN_20220711_11_45_38_Pro](https://user-images.githubusercontent.com/47036723/178315698-909d3483-ee27-4078-9432-773a8db652f7.jpg)
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
14. livecd /mnt/gentoo # tar xpvf ./stage3-amd64-desktop-openrc-20220710T170538Z.tar.xz --xattrs-include='*.*' --numeric-owner
15. livecd /mnt/gentoo # nano /mnt/gentoo/etc/portage/make.conf
    - make.conf: ![WIN_20220711_14_37_14_Pro](https://user-images.githubusercontent.com/47036723/178344548-cc70b90d-a73e-4c35-9051-828154adce30.jpg)
16. livecd /mnt/gentoo # mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf (I basically picked all the mirrors located in the U.S)
17. livecd /mnt/gentoo # mkdir --parents /mnt/gentoo/etc/portage/repos.conf
18. livecd /mnt/gentoo # cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
19. livecd /mnt/gentoo # cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

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

# Part III: Configuring Portage
1. (chroot) livecd / # emerge-webrsync
2. (chroot) livecd / # eselect profile set 8
    - This selects default/linux/amd64/17.1/desktop/plasma (stable)
3. (chroot) livecd / # emerge -aquvDN @world
4. (chroot) livecd / # emerge -aq app-portage/cpuid2cpuflags
5. (chroot) livecd / # cpuid2cpuflags
6. (chroot) livecd / # echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
7. (chroot) livecd / # echo "America/Chicago" > /etc/timezone
8. (chroot) livecd / # emerge --config sys-libs/timezone-data
9. (chroot) livecd / # nano /etc/locale.gen
10. (chroot) livecd / # locale-gen
11. (chroot) livecd / # eselect locale set 6
    - This selects en_US.utf8
12. (chroot) livecd / # env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

# Part IV: Kernel Configuration & Build

Since manual configuration is very expansive and showing every single option will be way too tedious, even more than this already is. I'll just show what I think would be the most important settings, especially the ones I changed.

"-X-" means that the option was automatically selected as built-in and I can't deselect the option (I think).

"( )" means that the option is excluded from the kernel.

1. (chroot) livecd / # emerge -aq sys-kernel/linux-firmware sys-kernel/gentoo-sources sys-apps/pciutils app-editors/vim app-arch/lz4 dev-vcs/git sys-kernel/dracut
2. (chroot) livecd / # eselect kernel set 1
3. (chroot) livecd / # cd /usr/src/linux && make menuconfig
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
        - [*] AMD MCE features
        - Performance monitoring --->
            - [*] Intel uncore performance events
            - [*] Intel/AMD rapl performance events
            - [*] Intel cstate performance events
            - [*] AMD Processor Power Reporting Mechanism
            - [*] AMD Uncore performance events
        - [*] AMD microcode loading support
        - -X- MTRR (Memory Type Range Register) support
        - [*] EFI runtime service support
        - [*] EFI stub support
        - [*] EFI mixed-mode support
    - Power management and ACPI options --->
        - CPU Frequency scaling --->
            - Default CPUFreq governor (userspace) ---> (For some reason, it won't let me change it to "ondemand", which is what the guide recommends for Ryzen)
            - [*] 'ondemand' cpufreq policy governor
            - [*] ACPI Processor P-States driver
            - [*] Legacy cpb sysfs knob support for AMD CPUs
            - ( ) AMD Opteron/Athlon64 PowerNow!
            - [*] AMD frequency sensitivity feedback powersave bias
    - Bus options (PCI etc.) --->
    - Binary Emulations ---> 
        - ( ) IA32 Emulation
    - [*] Virtualization --->
        - [*] Kernel-based Virtual Machine (KVM) support
        - [*] KVM for AMD processors support
    - General architecture-dependent options --->
    - [*] Enable loadable module support --->
    - -X- Enable the block layer --->
        - Partition Types --->
            - [*] Advanced partition selection
            - [*] PC BIOS (MSDOS partition tables) support (NEW)
            - [*] EFI GUID Partition support (NEW)
    - IO Schedulers --->
        - [*] BFQ I/O scheduler
    - Executable file formats --->
    - Memory Management options --->
    - [*] Networking support --->
        - Networking options --->
            - [*] 802.1d Ethernet Bridging
    - Device Drivers --->
        - Generic Driver Options --->
            - Firmware loader --->
                - (amd-ucode/microcode_amd_fam17h.bin) Build named firmware blobs into the kernel binary
                - (/lib/firmware) Firmware blobs root directory (NEW)
        - NVME Support --->
            - [*] NVM Express block device
        - SCSI device support
            - [*] SCSI disk support
        - Network device support
            - [*] Network core driver support
            - [*] Universal TUN/TAP device driver support
        - Character devices
            - [*] IPMI top-level message handler
        - Hardware Monitoring support
            - [*] AMD Family 10h+ temperature sensor
            - [*] AMD Family 15h processor power
        - Graphics support --->
            - [*] /dev/agpgart (AGP Support) --->
            - -X- VGA Arbitration
            - (3) Maximum number of GPUs
            - [*] Virtio GPU driver
            - [*] Simple framebuffer driver
            - Frame buffer Devices --->
                - [*] Support for frame buffer devices --->
            - [*] Bootup logo --->
                - [*] Standard 224-color Linux logo (NEW)
        - HID support
            - -X- HID bus support
            - [*] Battery level reporting for HID devices
        - [*] Virtualization drivers --->
        - [*] VHOST drivers --->
            - [*] Host kernel accelerator for virtio net
        - [*] IOMMU Hardware Support --->
            - [*] AMD IOMMU support
            - [*] AMD IOMMU Version 2 driver
    - File systems --->
        - [*] Second extended fs support
        - [*] The Extended 3 (ext3) filesystem
        - [*] The Extended 4 (ext4) filesystem
        - [*] Reiserfs support
        - [*] JFS filesystem support
        - [*] XFS filesystem support
        - [*] Btrfs filesystem support
        - DOS/FAT/EXFAT/NT Filesystems --->
            - [*] MSDOS fs support
            - [*] VFAT (Windows-95) fs support
        - Pseudo filesystems
            - -X- /proc file system support
            - -X- Tmpfs virtual memory file system support
            - [*] EFI Variable filesystem
    - Security options --->
    - -X- Cryptographic API --->
    - Library routines --->
    - Kernel hacking --->
    - Gentoo Linux --->
4. (chroot) livecd /usr/src/linux # make && make modules_install && make install && dracut --kver=5.15.52-gentoo

# Part V: Fstab + Networking + Bootloader
1. (chroot) livecd /usr/src/linux # blkid
    - This is what shows up: ![WIN_20220711_18_56_34_Pro](https://user-images.githubusercontent.com/47036723/178377956-64fbdf38-563c-4a5c-ad7b-a219f7ddf7a4.jpg)
2. (chroot) livecd /usr/src/linux # vim /etc/fstab
    - This is my fstab: ![WIN_20220711_19_25_18_Pro](https://user-images.githubusercontent.com/47036723/178380630-f299c74f-e11f-477e-9b27-5f8c9fa1fe2a.jpg)
3. (chroot) livecd /usr/src/linux # vim /etc/conf.d/hostname (Named my PC "nexus2")
4. (chroot) livecd /usr/src/linux # emerge -avq net-misc/dhcpcd
5. (chroot) livecd /usr/src/linux # rc-update add dhcpcd default
6. (chroot) livecd /usr/src/linux # rc-service dhcpcd start
7. (chroot) livecd /usr/src/linux # emerge --ask --noreplace net-misc/netifrc
8. (chroot) livecd /usr/src/linux # vim /etc/conf.d/net
    - My network interface is labeled "enp6s0"
    - I just put "config_enp6s0="dhcp"" on the file
9. (chroot) livecd /usr/src/linux # cd /etc/init.d
10. (chroot) livecd /etc/init.d # ln -s net.lo net.enp6s0
11. (chroot) livecd /etc/init.d # rc-update add net.enp6s0 default
12. (chroot) livecd /etc/init.d # vim /etc/hosts
    - This is my hosts file: ![image](https://user-images.githubusercontent.com/47036723/178381699-dc1a6fb7-38da-41ed-9333-84e285c6267f.png)
13. (chroot) livecd /etc/init.d # passwd
14. (chroot) livecd /etc/init.d # emerge -avq app-admin/sysklogd
15. (chroot) livecd /etc/init.d # rc-update add sysklogd default
16. (chroot) livecd /etc/init.d # emerge -aq net-misc/chrony && rc-update add chronyd default
17. (chroot) livecd /etc/init.d # emerge -avq sys-fs/e2fsprogs sys-fs/dosfstools sys-boot/grub:2
18. (chroot) livecd /etc/init.d # cd / && echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
19. (chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot
20. (chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg
    - Output: ![WIN_20220711_19_53_30_Pro](https://user-images.githubusercontent.com/47036723/178384886-5ff45bb4-3b39-48ae-a170-a72a902bcc6e.jpg)

# Part VI: Unmounting and Reboot
1. livecd /mnt/gentoo # exit
2. livecd /mnt/gentoo # cd
3. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
4. livecd ~ # umount -R /mnt/gentoo
5. reboot
    - Everytime I reboot in this step, I get these errors: ![image](https://user-images.githubusercontent.com/47036723/178385309-b265935d-9fb5-4c25-bfd9-2f3767fb05b5.png)
    - In case if you can't see it, the errors say:
        - Unmounting /mnt/cdrom... in use but fuser finds nothing
        - /lib/rc is not writable!
        - Unable to save dependency cache
        - Remounting /mnt/cdrom read only ... in use but fuser finds nothing
        - ERROR: mount-ro failed to start
    - I'm unsure if these errors mean anything or if I should ignore them.

# Part VII: Troubleshooting

Booting in, I got a kernel panic about "Cannot open root device": ![WIN_20220711_20_02_37_Pro](https://user-images.githubusercontent.com/47036723/178385828-6704d553-045e-4437-9f3e-5d7fe77c3c6e.jpg)

First attempt:

1. Boot back into livecd
2. livecd ~ # mount /dev/nvme0n1p3 /mnt/gentoo
3. livecd ~ # nano /mnt/gentoo/etc/default/grub
    - Uncommented the line: GRUB_DISABLE_LINUX_UUID=true
    - Looks like this: ![WIN_20220711_20_10_08_Pro](https://user-images.githubusercontent.com/47036723/178386418-7d80ab7e-a8d4-488f-8d24-bfd2fb72c564.jpg)
4. livecd ~ # nano /mnt/gentoo/etc/fstab
    - Change UUIDs to labels (probably should have done this in the first place)
    - Looks like this: ![WIN_20220711_20_12_57_Pro](https://user-images.githubusercontent.com/47036723/178386662-05648019-d776-4166-8fe6-c364c3196b4c.jpg)
5. livecd ~ # umount -R /mnt/gentoo
6. livecd ~ # reboot

Still got the kernel panic: ![WIN_20220711_20_17_20_Pro](https://user-images.githubusercontent.com/47036723/178387113-54abcfb1-eefc-4829-ab4a-73a9fd253c62.jpg)

I don't understand how a different UUID is being reported from the livecd versus the actual root partition. It was the same way with my Virtual Machine build. Since my virtual machine build's fstab had labels instead of UUIDs, I'll keep it that way.

Second attempt:

1. Boot back into livecd...again, but this time chroot back into root partition
2. livecd ~ # mount /dev/nvme0n1p3 /mnt/gentoo && cd /mnt/gentoo
3. livecd ~ # mount --types proc /proc /mnt/gentoo/proc
4. livecd ~ # mount --rbind /sys /mnt/gentoo/sys
5. livecd ~ # mount --make-rslave /mnt/gentoo/sys
6. livecd ~ # mount --rbind /dev /mnt/gentoo/dev
7. livecd ~ # mount --make-rslave /mnt/gentoo/dev
8. livecd ~ # mount --bind /run /mnt/gentoo/run
9. livecd ~ # mount --make-slave /mnt/gentoo/run
10. livecd ~ # chroot /mnt/gentoo /bin/bash
11. livecd ~ # source /etc/profile
12. livecd ~ # export PS1="(chroot) ${PS1}"
13. livecd ~ # mount /dev/nvme0n1p1 /boot
14. (chroot) livecd / # emerge -auvDN @world
15. (chroot) livecd / # cd /usr/src/linux && make menuconfig
    - Device Drivers --->
        - NVME Support --->
            - [*] NVM Express block device
            - [*] NVMe multipath support
            - [*] NVMe hardware monitoring
            - [*] NVM Express over Fabrics FC host driver
            - [*] NVM Express over Fabrics TCP host driver
        - SCSI device support --->
            - [*] SCSI low-level drivers
        - ( ) Virtio drivers
16. (chroot) livecd /usr/src/linux # make && make modules_install && make install && dracut --kver=5.15.52-gentoo --force
17. (chroot) livecd /usr/src/linux # cd / && grub-install --target=x86_64-efi --efi-directory=/boot && grub-mkconfig -o /boot/grub/grub.cfg
18. Checked /boot/grub/grub.cfg and I see this:
    - ![WIN_20220711_20_48_36_Pro](https://user-images.githubusercontent.com/47036723/178390940-300fc96b-5211-4ffe-aa86-de03275033ed.jpg)
    - I'm not sure if this is what is causing a kernel panic.
    - I still have the DISABLE UUID flag in the default/grub.
    - If this doesn't work, I'll give up and ask for help lol
19. (chroot) livecd / # exit
20. livecd /mnt/gentoo # cd
21. livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}
22. livecd ~ # umount -R /mnt/gentoo
23. reboot

Fingers crossed

 I can boot, but there's now another problem:
 
 ![WIN_20220711_20_58_11_Pro](https://user-images.githubusercontent.com/47036723/178392017-e07f5c44-0248-4b64-950a-1f64c7baaf87.jpg)

If I was to guess, I think I forgot to include some Intel ethernet drivers for my motherboard. 

My motherboard is an ASUS ROG STRIX X470-F Gaming motherboard and from their site, it's an Intel Gigabit ethernet port on the board. So, I probably have to check some option in the menuconfig. I'll do this later.

24. Log into root partition and make menuconfig
25. cd /usr/src/linux && make menuconfig
    - Device Drivers --->
        - Network device support --->
            - Ethernet driver support --->
                - I'm too lazy to type out all that so I'll just take a picture:
                - ![WIN_20220711_21_40_27_Pro](https://user-images.githubusercontent.com/47036723/178396792-df0d625c-06d3-469f-ab1a-6bd43eca927d.jpg)


# Resources
1. [Gentoo Downloads Page](https://www.gentoo.org/downloads/)
2. [Gentoo AMD64 Full Installation Guide](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation)
3. [Gentoo VM Gentoo "Guide"](https://github.com/Dishoungh/gentoo-config/blob/master/Gentoo/gentoo-vm-config.md)
4. [Tarball Directory](https://mirror.leaseweb.com/gentoo/releases/amd64/autobuilds/20220710T170538Z/)
5. [Ryzen Gentoo Wiki](https://wiki.gentoo.org/wiki/Ryzen)
6. [MAKEOPTS](https://wiki.gentoo.org/wiki/MAKEOPTS)
7. [Pipewire Packages](https://packages.gentoo.org/useflags/pipewire)
8. [NVIDIA Drivers Wiki](https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers)
9. [Virt-Manager Wiki](https://wiki.gentoo.org/wiki/Virt-manager#Kernel)
10. [QEMU Wiki](https://wiki.gentoo.org/wiki/QEMU#BIOS_and_UEFI_firmware)
11. [Xorg Guide](https://wiki.gentoo.org/wiki/Xorg/Guide#Make.conf)
12. [ASUS ROG String X470-F Gaming Motherboard Page](https://rog.asus.com/us/motherboards/rog-strix/rog-strix-x470-f-gaming-model/)
