# gentoo-vm-config

This is a work-in-progress guide for me to build a Gentoo VM. I'm mapping out EXACTLY what I did to my VM to make it easier for others to help me troubleshoot.

Depending on how large this gets, I'll probably separate this README to 3 separate READMEs (1 for creating the Virtual Machine, 1 for installing Gentoo (excluding the kernel configuration part), and 1 just for the kernel config part).

This setup has been done on a QEMU KVM hypervisor on a Arch Linux host. This is my host setup:
![image](https://user-images.githubusercontent.com/47036723/158039894-8337d0db-e63c-43e1-afd9-fc81e0f41b4d.png)

I'm not intending on passing through much of my host hardware except my CPU configuration. I'm trying to create a fairly generic Gentoo VM, so I don't care about passing through my GPU or getting graphics drivers for it in the kernel.

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
16. Video<br>![image](https://user-images.githubusercontent.com/47036723/158043066-aeb45418-96bb-4baf-b7dd-e017a34691f9.png)<br>&emsp;Other Settings (Information that I don't think is important but in case if it would be)<br>&emsp;&emsp;- Tablet: EvTouch USB Graphics Tablet (Type), Absolute Movement (Mode)<br>&emsp;&emsp;- Sound: HDA (ICH9)<br>&emsp;&emsp;- Console Device Type: pty<br>&emsp;&emsp;- Display Spice Type: Spice server<br>
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
   Note: If the DNS problem happens again, change the DNS values back like shown before. Here is my make.conf now (I basically selected every mirror in the U.S)<br>![image](https://user-images.githubusercontent.com/47036723/158044098-365a9b21-3edc-4115-8389-d17645eb1ef8.png)
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
