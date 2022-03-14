# gentoo-vm-config

This is a work-in-progress guide for me to build a Gentoo VM. I'm mapping out EXACTLY what I did to my VM to make it easier for others to help me troubleshoot.

Depending on how large this gets, I'll probably separate this README to multiple READMEs or keep it as one depending on which one is easiest to read.

This setup has been done on a QEMU KVM hypervisor on a Arch Linux host. This is my host setup:
![image](https://user-images.githubusercontent.com/47036723/158039894-8337d0db-e63c-43e1-afd9-fc81e0f41b4d.png)

I'm not intending on passing through much of my host hardware except my CPU configuration. I'm trying to create a fairly generic Gentoo VM, so I don't care about passing through my GPU or getting graphics drivers for it in the kernel (at least not yet anyway). The goal here is to minimize the variability aside from the actual kernel configuration later.

QEMU/KVM Virt-manager Versions: 4.0.0

Gentoo ISO File Used: install-amd64-minimal-20220227T170528Z.iso

Links to guides and tutorials I used:
   - [Gentoo Linux amd64 Handbook: Installing Gentoo](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Introduction)
   - [QEMU/Linux guest - Gentoo Wiki](https://wiki.gentoo.org/wiki/QEMU/Linux_guest)
   - [Ryzen Gentoo Wiki](https://wiki.gentoo.org/wiki/Ryzen)
   - [Full Gentoo Installation - Big Brain Edition](https://www.youtube.com/watch?v=6yxJoMa05ZM&t)
   - [Configuring a Custom Linux Kernel (5.6.7-gentoo)](https://www.youtube.com/watch?v=NVWVHiLx1sU&t)

# Creating the Virtual Machine on Virt-Manager

1. Create a new virtual machine<br>![image](https://user-images.githubusercontent.com/47036723/158039966-403e8835-8871-4c33-a915-6542802c8259.png)
2. Select "Local install media (ISO image or CDROM)<br>![image](https://user-images.githubusercontent.com/47036723/158040033-4f539e53-a665-44c0-94d6-0f81bd4e4c9c.png)
3. Choose "install-amd64-minimal-20220227T170528Z.iso" file<br>![image](https://user-images.githubusercontent.com/47036723/158040074-63e2a2e3-518d-47e0-a7f1-c742d13e4ce9.png)
4. Memory: 16384 MiB (16 GB)<br>&nbsp;CPUs (Threads): 8 <br>![image](https://user-images.githubusercontent.com/47036723/158040123-367645b3-d6d9-4c4e-8047-6de5af83bc03.png)
5. I'm using a secondary hard drive that is 500GB but I'll use 100GB for the VM. I'm not sure what "Allocate entire volume now" means, but I'll check it because that seems to make sense to do.<br>![image](https://user-images.githubusercontent.com/47036723/158040209-523fabeb-069c-4c1c-b152-9c73c2b04e54.png)
6. After clicking "Finish", the storage will be allocated.
7. Choose the allocated storage volume for the Gentoo VM (mine is called "gentoo.qcow2")
8. Check "Customize configuration before install" then click "Finish"<br>![image](https://user-images.githubusercontent.com/47036723/158040262-89a3ad74-c50c-41f2-849e-28ed773b335b.png)
9. Overview<br>![image](https://user-images.githubusercontent.com/47036723/158042928-8f619c00-2e11-4b58-b717-27864cac0baf.png)
10. CPUs<br>![image](https://user-images.githubusercontent.com/47036723/158043080-c05b8217-47e2-4511-bf5f-2c3cace8e23e.png)
11. Memory<br>![image](https://user-images.githubusercontent.com/47036723/158042969-b2a8b000-0946-4300-870a-e02a0024a4f1.png)
12. Boot Options<br>![image](https://user-images.githubusercontent.com/47036723/158042978-baaa6a0d-f41c-4f80-a94f-2f72028b72ce.png)
13. VirtIO Disk 1<br>![image](https://user-images.githubusercontent.com/47036723/158042992-f009f18a-4883-47a2-8aa9-9372ac46cbf0.png)
14. SATA CDROM 1<br>![image](https://user-images.githubusercontent.com/47036723/158043013-30d12337-bc24-4885-801a-21d758707a16.png)
15. NIC<br>![image](https://user-images.githubusercontent.com/47036723/158043022-078e7d62-622c-406b-a732-3ceef37943c9.png)
16. Video<br>![image](https://user-images.githubusercontent.com/47036723/158175376-f897e4d5-b2b2-4d04-be25-15533e07623f.png)<br>&emsp;Other Settings (Information that I don't think is important but in case if it would be)<br>&emsp;&emsp;- Tablet: EvTouch USB Graphics Tablet (Type), Absolute Movement (Mode)<br>&emsp;&emsp;- Sound: HDA (ICH9)<br>&emsp;&emsp;- Console Device Type: pty<br>&emsp;&emsp;- Display Spice Type: Spice server<br>
17. Click "Begin Installation"
18. After clicking "Begin Installation", Virt-Manager should automatically start the Virtual Machine. Boot into "LiveCD (kernel: gentoo)<br>![image](https://user-images.githubusercontent.com/47036723/158042060-6a6a2221-9746-42a4-a266-b4f8a60e36bb.png)


# Installing Gentoo

The following contains commands exactly as I typed them in order. I'll occasionally show screenshots to show some important information and I'll try to be as transparent as possible while trying not to show a bunch of unnecessary commands.

1. **livecd ~ # ping -c3 www.gentoo.org**<br>
   Note: This command failed for me because for some reason, the default IP address saved on resolv.conf isn't a valid DNS. This was fixed by this:<br>
      a. **livecd ~ # nano /etc/resolv.conf**<br>
      b. Original file:<br>![image](https://user-images.githubusercontent.com/47036723/158042284-bd2e3f27-76df-4e76-af94-5262f9abda5f.png)<br>
      c. Edits:<br>![image](https://user-images.githubusercontent.com/47036723/158042349-15188150-2e74-416e-9a6b-daeadd1481b3.png)<br>
2. **livecd ~ # ping -c3 www.gentoo.org**<br>
   Note: Command worked this time. If there is a better solution, let me know.<br>![image](https://user-images.githubusercontent.com/47036723/158042681-7bda119f-2243-4c00-a41e-8bcd87393966.png)<br>
3. **livecd ~ # lsblk**<br>
   Note: Below is what shows for my list of block devices<br>![image](https://user-images.githubusercontent.com/47036723/158043217-f2c64054-abd3-41d8-a83d-f1bb989a726f.png)
4. **livecd ~ # fdisk /dev/vda**<br>
   Note: This is how I partitioned /dev/vda. I likely don't need that much swap, but I doubt the swap will cause any issues<br>![image](https://user-images.githubusercontent.com/47036723/158043398-01dc03f4-2384-45a6-8f70-7549a6df5dec.png)

5. **livecd ~ # mkfs.vfat -F 32 /dev/vda1**<br>
6. **livecd ~ # mkfs.ext4 /dev/vda3**<br>
7. **livecd ~ # mkswap /dev/vda2**<br>
8. **livecd ~ # swapon /dev/vda2**<br>
   Note: Screenshot to show the UUIDs assigned to these partitions.<br>![image](https://user-images.githubusercontent.com/47036723/158043496-4b8143a8-04bd-4d51-8633-791c94c509d0.png)
9. **livecd ~ # mount /dev/vda3 /mnt/gentoo**<br>
10. **livecd ~ # cd /mnt/gentoo**<br>
11. **livecd /mnt/gentoo # wget http://www.gtlib.gatech.edu/pub/gentoo/releases/amd64/autobuilds/20220227T170528Z/stage3-amd64-desktop-openrc-20220227T170528Z.tar.xz**<br>
12. **livecd /mnt/gentoo # tar xpvf ./stage3-amd64-desktop-openrc-20220227T170528Z.tar.xz --xattrs-include='*.*' --numeric-owner**<br>
13. **livecd /mnt/gentoo # nano /mnt/gentoo/etc/portage/make.conf**<br>
   Note: This is what I have for my make.conf after this command<br>![image](https://user-images.githubusercontent.com/47036723/158043959-f8fb9f62-07b4-42f1-93d9-00ab955178b7.png)
14. **livecd /mnt/gentoo # mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf**
   Note: If the DNS problem happens again, change the DNS values back like shown before. Here is my make.conf now (I basically selected every mirror in the U.S)<br>![image](https://user-images.githubusercontent.com/47036723/158045042-87f96a1e-1b8c-4af2-99fa-1861d4b39d99.png)
15. **livecd /mnt/gentoo # mkdir --parents /mnt/gentoo/etc/portage/repos.conf**
16. **livecd /mnt/gentoo # cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf**
17. **livecd /mnt/gentoo # cat /mnt/gentoo/etc/portage/repos.conf/gentoo.conf**
   Output:<br>![image](https://user-images.githubusercontent.com/47036723/158044281-44cbc935-2db9-4d6f-bbc1-ef70c2f9b3b6.png)
18. **livecd /mnt/gentoo # cp --dereference /etc/resolv.conf /mnt/gentoo/etc/**
   Note: Make sure the DNS information in the file hasn't been reset
19. **livecd /mnt/gentoo # mount --types proc /proc /mnt/gentoo/proc**
20. **livecd /mnt/gentoo # mount --rbind /sys /mnt/gentoo/sys**
21. **livecd /mnt/gentoo # mount --make-rslave /mnt/gentoo/sys**
22. **livecd /mnt/gentoo # mount --rbind /dev /mnt/gentoo/dev**
23. **livecd /mnt/gentoo # mount --make-rslave /mnt/gentoo/dev**
24. **livecd /mnt/gentoo # mount --bind /run /mnt/gentoo/run**
25. **livecd /mnt/gentoo # mount --make-slave /mnt/gentoo/run**
26. **livecd /mnt/gentoo # chroot /mnt/gentoo /bin/bash**
27. **livecd / # source /etc/profile**
28. **livecd / # export PS1="(chroot) ${PS1}"**
29. **(chroot) livecd / # mount /dev/vda1 /boot**
30. **(chroot) livecd / # emerge-webrsync**
31. **(chroot) livecd / # emerge --sync --quiet**
32. **(chroot) livecd / # eselect profile list**
33. **(chroot) livecd / # eselect profile set 8**
34. **(chroot) livecd / # emerge -avuDN @world && (emerge --info | grep ^USE)**<br>
   Note: Command took about 3 hours to complete. I could have added more USE flags to decrease the emerge time and size of the whole system, but I want to make sure my USE flags aren't messing things up. Once I get my vm up right, I'll perhaps mess with the USE flags later?<br>Output of USE Flags:<br>![image](https://user-images.githubusercontent.com/47036723/158071253-0b886a5b-e5fd-4818-a55b-5ac1a7057a42.png)
35. **(chroot) livecd / # emerge -aq app-editors/vim**
36. **(chroot) livecd / # echo "America/Chicago" > /etc/timezone**
37. **(chroot) livecd / # emerge --config sys-libs/timezone-data**
38. **(chroot) livecd / # echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen**
39. **(chroot) livecd / # locale-gen**
40. **(chroot) livecd / # eselect locale list**
41. **(chroot) livecd / # eselect locale set 4**
42. **(chroot) livecd / # env-update && source /etc/profile && export PS1="(chroot) ${PS1}"**
43. **(chroot) livecd / # emerge -aq sys-kernel/linux-firmware sys-kernel/gentoo-sources**
44. **(chroot) livecd / # eselect kernel list**
45. **(chroot) livecd / # eselect kernel set 1**<br>
  Note: Kernel version is 5.16.14-gentoo 
46. **(chroot) livecd / # emerge -aq sys-apps/pciutils app-arch/lzop app-arch/lz4**
47. **(chroot) livecd / # cd /usr/src/linux && make menuconfig**<br>
  Note: [Here is the text file for the .config](https://github.com/Dishoungh/gentoo-config/blob/master/kernel_config.txt)
49. **(chroot) livecd /usr/src/linux # make && make modules_install && make install**
50. **(chroot) livecd /usr/src/linux # emerge -aq dev-vcs/git sys-kernel/dracut**
51. **(chroot) livecd /usr/src/linux # dracut --kver=5.16.14-gentoo**<br>
   Note: Here is what shows up on /boot<br>![image](https://user-images.githubusercontent.com/47036723/158161486-1731096d-2053-4722-b556-e7a4c5c9159c.png)
52. **(chroot) livecd /usr/src/linux # (echo -e "UUID=$(blkid -s UUID -o value /dev/vda1)\t\t\t\t\t/boot/efi\tvfat\tdefaults\t0 2" >> /etc/fstab) && (echo -e "UUID=$(blkid -s UUID -o value /dev/vda2)\tnone\t\tswap\tsw\t\t0 0" >> /etc/fstab) && (echo -e "UUID=$(blkid -s UUID -o value /dev/vda3)\t/\t\text4\tnoatime\t\t0 1" >> /etc/fstab)**
53. **(chroot) livecd /usr/src/linux # echo "hostname=\"gentoo-vm\"" > /etc/conf.d/hostname**
54. **(chroot) livecd /usr/src/linux # emerge --noreplace --quiet net-misc/netifrc**
55. **(chroot) livecd /usr/src/linux # emerge -aq net-misc/dhcpcd**
56. **(chroot) livecd /usr/src/linux # rc-update add dhcpcd default**
57. **(chroot) livecd /usr/src/linux # cd /etc/init.d**
58. **(chroot) livecd /etc/init.d # ln -s net.lo net.enp1s0**
59. **(chroot) livecd /etc/init.d # rc-update add net.enp1s0 default**
60. **(chroot) livecd /etc/init.d # (echo -e "127.0.0.1\tgentoo-vm.homenetwork\tgentoo-vm\tlocalhost" > /etc/hosts) && (echo -e "::1\t\tlocalhost" >> /etc/hosts)**
61. **(chroot) livecd /etc/init.d # passwd**
62. **(chroot) livecd /etc/init.d # emerge -aq app-admin/sysklogd && rc-update add sysklogd default**
63. **(chroot) livecd /etc/init.d # emerge -avq sys-fs/e2fsprogs sys-fs/dosfstools sys-boot/grub:2**
64. **(chroot) livecd /etc/init.d # echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf**
65. **(chroot) livecd /etc/init.d # cd /**
66. **(chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot**<br>
   Output:<br>
      ![image](https://user-images.githubusercontent.com/47036723/158171503-4a552bbc-8f90-42de-9d12-5e656824b7c9.png)
67. **(chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg**<br>
   Output:<br>
      ![image](https://user-images.githubusercontent.com/47036723/158171740-c7cdb14d-9f90-4932-af63-0eac8521bd70.png)
68. **(chroot) livecd / # exit**
69. **livecd /mnt/gentoo # cd**
70. **livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}**
71. **livecd ~ # umount -R /mnt/gentoo**
72. **livecd ~ # reboot**
   Note: During the reboot, I actually shut down my VM to remove the ISO disk from the boot menu. This is the boot menu now:<br>
      ![image](https://user-images.githubusercontent.com/47036723/158173094-943c3fc3-1ecc-4e3e-af40-18f09f13005d.png)
      
# Post-Installation

1. Start gentoo VM (and hope the login screen pops up)
2. If error, cry yourself to sleep...
