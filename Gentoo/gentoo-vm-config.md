# gentoo-vm-config

This is a work-in-progress guide for me to build a Gentoo VM. I'm mapping out EXACTLY what I did to my VM to make it easier for others to help me troubleshoot.

Depending on how large this gets, I'll probably separate this README to multiple READMEs or keep it as one depending on which one is easiest to read.

This setup has been done on a QEMU+KVM+Virt-Manager hypervisor on a Arch Linux host...because of course I would be on Arch. This is my host setup:<br>
![image](https://user-images.githubusercontent.com/47036723/158039894-8337d0db-e63c-43e1-afd9-fc81e0f41b4d.png)

I'm not intending on passing through much of my host hardware except my CPU configuration. I'm trying to create a fairly generic Gentoo VM, so I don't care about passing through my GPU or getting graphics drivers for it in the kernel (at least not yet anyway). The goal here is to minimize the variability aside from the actual kernel configuration later.

Using this as a reference as well: <br>
![image](https://user-images.githubusercontent.com/47036723/158282862-1617c3a7-3a65-4aa3-afbb-00c36ebea260.png)

QEMU/KVM Virt-manager Versions: 4.0.0

Gentoo ISO File Used: install-amd64-minimal-20220314T175555Z.iso

Links to guides and tutorials I used:
   - [Gentoo Linux amd64 Handbook: Installing Gentoo](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Introduction)
   - [QEMU/Linux guest - Gentoo Wiki](https://wiki.gentoo.org/wiki/QEMU/Linux_guest)
   - [Ryzen Gentoo Wiki](https://wiki.gentoo.org/wiki/Ryzen)
   - [Install Gentoo Linux (Part 2) to the desktop](https://www.youtube.com/watch?v=wQxBsunITaA)
   - [Configuring a Custom Linux Kernel (5.6.7-gentoo)](https://www.youtube.com/watch?v=NVWVHiLx1sU&t)

# Creating the Virtual Machine on Virt-Manager

1. Create a new virtual machine<br>![image](https://user-images.githubusercontent.com/47036723/158039966-403e8835-8871-4c33-a915-6542802c8259.png)
2. Select "Local install media (ISO image or CDROM)<br>![image](https://user-images.githubusercontent.com/47036723/158040033-4f539e53-a665-44c0-94d6-0f81bd4e4c9c.png)
3. Choose "install-amd64-minimal-20220314T175555Z.iso" file<br>![image](https://user-images.githubusercontent.com/47036723/158040074-63e2a2e3-518d-47e0-a7f1-c742d13e4ce9.png)
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


# Installing Gentoo (WORK IN PROGRESS)

The following contains commands exactly as I typed them in order. I'll occasionally show screenshots to show some important information and I'll try to be as transparent as possible while trying not to show a bunch of unnecessary commands. As it states, this is a work in progress.

1. **livecd ~ # ping -c3 www.gentoo.org**<br>
   Note: This command failed for me because for some reason, the default IP address saved on resolv.conf isn't a valid DNS. This was fixed by this:<br>
      a. **livecd ~ # nano /etc/resolv.conf**<br>
      b. Original file:<br>![image](https://user-images.githubusercontent.com/47036723/158042284-bd2e3f27-76df-4e76-af94-5262f9abda5f.png)<br>
      c. Edits:<br>![image](https://user-images.githubusercontent.com/47036723/158042349-15188150-2e74-416e-9a6b-daeadd1481b3.png)<br>
      d. **livecd ~ # ping -c3 www.gentoo.org**<br>
      e. **livecd ~ # chattr +i /etc/resolv.conf**<br>
   Note: Command worked this time. The chattr command ensures that whatever service that the file is attached to DOESN'T change it again. If there is a better solution, let me know.<br>![image](https://user-images.githubusercontent.com/47036723/158042681-7bda119f-2243-4c00-a41e-8bcd87393966.png)<br>
2. **livecd ~ # lsblk**<br>
   Note: Below is what shows for my list of block devices<br>![image](https://user-images.githubusercontent.com/47036723/158043217-f2c64054-abd3-41d8-a83d-f1bb989a726f.png)
3. **livecd ~ # fdisk /dev/vda**<br>
   Note: This is how I partitioned /dev/vda. I likely don't need that much swap, but I doubt the swap will cause any issues<br>![image](https://user-images.githubusercontent.com/47036723/158709713-ea7742af-0609-44ef-a6ea-2a10c2582935.png)

4. **livecd ~ # mkfs.vfat -F 32 /dev/vda1**<br>
5. **livecd ~ # mkfs.ext4 /dev/vda3**<br>
6. **livecd ~ # mkswap /dev/vda2**<br>
7. **livecd ~ # swapon /dev/vda2**<br>
   Note: Screenshot to show the UUIDs assigned to these partitions.<br>![image](https://user-images.githubusercontent.com/47036723/158710066-47a6528c-9839-4b13-9618-611fb27d9f34.png)
8. **livecd ~ # mount /dev/vda3 /mnt/gentoo**<br>
9. **livecd ~ # cd /mnt/gentoo**<br>
10. **livecd /mnt/gentoo # wget http://www.gtlib.gatech.edu/pub/gentoo/releases/amd64/autobuilds/20220314T175555Z/stage3-amd64-desktop-openrc-20220314T175555Z.tar.xz**<br>
11. **livecd /mnt/gentoo # tar xpvf ./stage3-amd64-desktop-openrc-20220227T170528Z.tar.xz --xattrs-include='*.*' --numeric-owner**<br>
12. **livecd /mnt/gentoo # nano /mnt/gentoo/etc/portage/make.conf**<br>
   Note: Copy the make.conf file<br>![image](https://user-images.githubusercontent.com/47036723/158923947-def5b606-97ea-4acb-a1f1-3ab2b9030098.png)
13. **livecd /mnt/gentoo # mkdir --parents /mnt/gentoo/etc/portage/repos.conf**
14. **livecd /mnt/gentoo # cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf**
15. **livecd /mnt/gentoo # cat /mnt/gentoo/etc/portage/repos.conf/gentoo.conf**<br>
   Output:<br>![image](https://user-images.githubusercontent.com/47036723/158044281-44cbc935-2db9-4d6f-bbc1-ef70c2f9b3b6.png)
16. **livecd /mnt/gentoo # cp --dereference /etc/resolv.conf /mnt/gentoo/etc/**
   Note: Make sure the DNS information in the file is valid
17. **livecd /mnt/gentoo # mount --types proc /proc /mnt/gentoo/proc**
18. **livecd /mnt/gentoo # mount --rbind /sys /mnt/gentoo/sys**
19. **livecd /mnt/gentoo # mount --make-rslave /mnt/gentoo/sys**
20. **livecd /mnt/gentoo # mount --rbind /dev /mnt/gentoo/dev**
21. **livecd /mnt/gentoo # mount --make-rslave /mnt/gentoo/dev**
22. **livecd /mnt/gentoo # mount --bind /run /mnt/gentoo/run**
23. **livecd /mnt/gentoo # mount --make-slave /mnt/gentoo/run**
24. **livecd /mnt/gentoo # chroot /mnt/gentoo /bin/bash**
25. **livecd / # source /etc/profile**
26. **livecd / # export PS1="(chroot) ${PS1}"**
27. **(chroot) livecd / # mount /dev/vda1 /boot**
28. **(chroot) livecd / # emerge-webrsync**
29. **(chroot) livecd / # emerge --sync --quiet**
30. **(chroot) livecd / # eselect profile set 8**
31. **(chroot) livecd / # emerge -vuDN @world**<br>
32. **(chroot) livecd / # echo "America/Chicago" > /etc/timezone**
33. **(chroot) livecd / # emerge --config sys-libs/timezone-data**
34. **(chroot) livecd / # echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen**
35. **(chroot) livecd / # locale-gen**
36. **(chroot) livecd / # eselect locale set 4**
37. **(chroot) livecd / # env-update && source /etc/profile && export PS1="(chroot) ${PS1}"**
38. **(chroot) livecd / # emerge -q --autounmask app-editors/vim sys-kernel/linux-firmware sys-kernel/gentoo-sources sys-apps/pciutils app-arch/lzop app-arch/lz4 dev-vcs/git sys-kernel/dracut**
39. **(chroot) livecd / # eselect kernel set 1**<br>
40. **(chroot) livecd / # cd /usr/src/linux**<br>
   Note: I'm doing this the lazy way since I don't feel like setting up my kernel config again. DO NOT DO IT THIS WAY. Only reason I'm doing it is because I'm lazy lol.<br>
   (git clone https://github.com/Dishoungh/gentoo-config) && ((cat ./gentoo-config/kernel_config_v2.txt) > ./linux/.config) && rm -rf ./gentoo-config/<br>
41. **(chroot) livecd /usr/src/linux # make menuconfig**<br>
   Note: If you've imported an old kernel config, still look through and make sure the appropriate options are selected/deselected and SAVE to update the .config to align with the newer build
42. **(chroot) livecd /usr/src/linux # make && make modules_install && make install**
43. **(chroot) livecd /usr/src/linux # dracut --kver=5.16.14-gentoo**<br>
   Note: Here is what shows up on /boot<br>![image](https://user-images.githubusercontent.com/47036723/158161486-1731096d-2053-4722-b556-e7a4c5c9159c.png)
50. **(chroot) livecd /usr/src/linux # echo -e "/dev/vda1\t/boot\tvfat\tdefaults\t0 2\n/dev/vda2\tnone\tswap\tsw\t\t0 0\n/dev/vda\t/\text4\tnoatime\t\t0 1" >> /etc/fstab**
   Note: My fstab looks like this:<br>![image](https://user-images.githubusercontent.com/47036723/158912686-5fdb2b3a-7786-4ab4-bea8-98fe74fafdd5.png)
52. **(chroot) livecd /usr/src/linux # echo -e "hostname=\"gentoo-vm\"" > /etc/conf.d/hostname**
53. **(chroot) livecd /usr/src/linux # emerge --noreplace --quiet net-misc/netifrc**
54. **(chroot) livecd /usr/src/linux # emerge -q net-misc/dhcpcd**
55. **(chroot) livecd /usr/src/linux # rc-update add dhcpcd default**
56. **(chroot) livecd /usr/src/linux # echo -e "config_{INTERFACE ID}=\"dhcp\"" > /etc/conf.d/net
57. **(chroot) livecd /usr/src/linux # cd /etc/init.d**
58. **(chroot) livecd /etc/init.d # ln -s net.lo net.{INTERFACE ID}**
59. **(chroot) livecd /etc/init.d # rc-update add net.{INTERFACE ID} default**
60. **(chroot) livecd /etc/init.d # (echo -e "127.0.0.1\tgentoo-vm.homenetwork\tgentoo-vm\tlocalhost\n::1\t\tlocalhost" > /etc/hosts)**
61. **(chroot) livecd /etc/init.d # passwd**
62. **(chroot) livecd /etc/init.d # emerge -vq sys-fs/e2fsprogs sys-fs/dosfstools sys-boot/grub:2 app-admin/sysklogd**
63. **(chroot) livecd /etc/init.d # rc-update add sysklogd default**
64. **(chroot) livecd /etc/init.d # echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf**
65. **(chroot) livecd /etc/init.d # cd /**
66. **(chroot) livecd / # grub-install --target=x86_64-efi --efi-directory=/boot**<br>
   Output:<br>
      ![image](https://user-images.githubusercontent.com/47036723/158171503-4a552bbc-8f90-42de-9d12-5e656824b7c9.png)
65. **(chroot) livecd / # grub-mkconfig -o /boot/grub/grub.cfg**<br>
   Output:<br>
      ![image](https://user-images.githubusercontent.com/47036723/158171740-c7cdb14d-9f90-4932-af63-0eac8521bd70.png)
66. **(chroot) livecd / # vim /etc/default/grub**<br>
   Note: Due to me being on a virtual machine, the real UUID of the root device will be different from the UUID reported in the blkid in the livecd. It's a strange bug, but I got around this by uncommenting a disable flag in the default grub config file here:<br>![image](https://user-images.githubusercontent.com/47036723/158910933-1c5a38e4-e4b1-455d-ab9a-cd3c4ef44ccf.png)
68. **(chroot) livecd / # exit**
69. **livecd /mnt/gentoo # cd**
70. **livecd ~ # umount -l /mnt/gentoo/dev{/shm,/pts,}**
71. **livecd ~ # umount -R /mnt/gentoo**
72. **livecd ~ # reboot**
   Note: During the reboot, I actually shut down my VM to remove the ISO disk from the boot menu. This is the boot menu now:<br>
      ![image](https://user-images.githubusercontent.com/47036723/158173094-943c3fc3-1ecc-4e3e-af40-18f09f13005d.png)
      
# Post-Installation (Setting Up Desktop)

1. Start gentoo VM (and hope the login screen pops up)
   Should look like this:<br>![image](https://user-images.githubusercontent.com/47036723/158914164-a18e4a99-4189-46e4-83e6-39f00d2c7e33.png)
2. **gentoo-vm ~ # cd /**
3. **gentoo-vm / # emerge -q app-admin/sudo**
4. **gentoo-vm / # visudo**<br>
   Uncomment: "%wheel ALL=(ALL) ALL
5. **gentoo-vm / # useradd -m -G users,wheel,audio,video -s /bin/bash noob**
6. **gentoo-vm / # passwd noob**
7. **gentoo-vm / # emerge -q gentoolkit**
8. **gentoo-vm / # rc-update add elogind boot**
9. **gentoo-vm / # rc-update add udev sysinit**
10. **gentoo-vm / # rc-update add dbus default**
11. **gentoo-vm / # emerge -q udisks**
12. **gentoo-vm / # emerge -q x11-base/xorg-drivers**
13. **gentoo-vm / # emerge -q kde-plasma/plasma-meta kde-apps/kdecore-meta www-client/firefox**<br>
   Note: You may get dependency errors. To fix this, respond yes to saving the config file then send command:<br>
      **dispatch-conf**<br>
      Type 'u' for the package dependency page<br>
      Re-run the command<br>
      This will take a while to execute<br>
14. **gentoo-vm / # echo -e "[X11]\nDisplayCommand=/etc/sddm/scripts/Xsetup" > /etc/sddm.conf**
15. **gentoo-vm / # mkdir -p /etc/sddm/scripts**
16. **gentoo-vm / # echo "setxkbmap us" > /etc/sddm/scripts/Xsetup**
17. **gentoo-vm / # chmod a+x /etc/sddm/scripts/Xsetup**
18. **gentoo-vm / # emerge -q gui-libs/display-manager-init**
19. **gentoo-vm / # vim /etc/conf.d/display-manager**<br>
   Note: Change DISPLAYMANAGER to "sddm"<br>![image](https://user-images.githubusercontent.com/47036723/159036719-6aa49aa9-cd50-4c0c-b6f8-ffacfdbbd2b2.png)
20. **gentoo-vm / # rc-update add display-manager default**
21. **gentoo-vm / # rc-service display-manager start**
22. **gentoo-vm / # echo 'DISPLAYMANAGER="sddm"' > /etc/conf.d/xdm**
23. **gentoo-vm / # rc-update add xdm default**
24. **gentoo-vm / # /etc/init.d/xdm start**

# Desktop Configuration
You should have a Desktop login screen.
1. Login
2. Optional: Since I have a 2560x1440 monitor, that option isn't available (for some reason even though 1440p monitors are pretty common nowadays). To add that and have it be a permanent change, do this:<br>
   **noob@gentoo-vm ~ $ sudo echo -e *<br>![image](https://user-images.githubusercontent.com/47036723/159077964-0391bec3-36c2-4c8e-b637-ed6ab66b1973.png)


