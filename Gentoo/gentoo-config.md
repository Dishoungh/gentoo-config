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

I'll try to build Gentoo to meet these requirements. My intended init system will be OpenRC since that is what I used for my vm last time and I will try to switch to pipewire (something I should have done a long time ago; I'm sick of PulseAudio). Most of the steps I use come from #2 in Resources.

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
15. nano /mnt/gentoo/etc/portage/make.conf
    - make.conf: ![WIN_20220711_13_17_39_Pro](https://user-images.githubusercontent.com/47036723/178331224-279dc43a-0b45-4900-b8d1-fbbf3e16bcde.jpg)
16. 

# Resources
1. [Gentoo Downloads Page](https://www.gentoo.org/downloads/)
2. [Gentoo AMD64 Full Installation Guide](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation)
3. [Gentoo VM Gentoo "Guide"](https://github.com/Dishoungh/gentoo-config/blob/master/Gentoo/gentoo-vm-config.md)
4. [Tarball Directory](https://mirror.leaseweb.com/gentoo/releases/amd64/autobuilds/20220710T170538Z/)
5. [Ryzen Gentoo Wiki](https://wiki.gentoo.org/wiki/Ryzen)
6. [MAKEOPTS](https://wiki.gentoo.org/wiki/MAKEOPTS)
7. [Pipewire Packages](https://packages.gentoo.org/useflags/pipewire)
