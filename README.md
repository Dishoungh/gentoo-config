# gentoo-vm-config

This is a work-in-progress guide to build Gentoo Linux. I'm mapping out EXACTLY what I did to my VM to make it easier for others to help me troubleshoot.

This setup has been done on a QEMU KVM hypervisor on a Arch Linux host. This is my host setup:
![image](https://user-images.githubusercontent.com/47036723/158039894-8337d0db-e63c-43e1-afd9-fc81e0f41b4d.png)

I'm not intending on passing through much of my host hardware except my CPU configuration. I'm trying to create a fairly generic Gentoo VM, so I don't care about passing through my GPU or getting graphics drivers for it in the kernel.

QEMU/KVM Virt-manager Versions: 4.0.0

Gentoo ISO File Used: install-amd64-minimal-20220227T170528Z.iso

Links to guides and tutorials I used:
   - [Gentoo Linux amd64 Handbook: Installing Gentoo](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Introduction)
   - [QEMU/Linux guest - Gentoo Wiki](https://wiki.gentoo.org/wiki/QEMU/Linux_guest)
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
9. Overview<br>![image](https://user-images.githubusercontent.com/47036723/158040301-a3be05b8-057a-45bb-a9c9-8c4e95c743b2.png)
10. CPUs<br>![image](https://user-images.githubusercontent.com/47036723/158040344-e9d9d2b1-70ef-494e-95df-ae1e7c6952fb.png)
11. Memory<br>![image](https://user-images.githubusercontent.com/47036723/158041720-0f32638f-7b1e-400e-94da-d703cba3b1a9.png)
12. Boot Options<br>![image](https://user-images.githubusercontent.com/47036723/158041737-d89b2720-f90d-4279-8ce5-ae775e551a45.png)
13. Disk 1<br>![image](https://user-images.githubusercontent.com/47036723/158041777-d774b61d-e5b0-431a-9524-ac2ed5d89344.png)
14. SATA CDROM 1<br>![image](https://user-images.githubusercontent.com/47036723/158040569-7dc93b94-9bac-46f1-910c-137791a81fa1.png)
15. NIC<br>![image](https://user-images.githubusercontent.com/47036723/158040585-c18ec545-802f-41a5-8d01-e560fa43799c.png)
16. Video<br>![image](https://user-images.githubusercontent.com/47036723/158041882-5a01d059-a078-468f-b146-4538b0750bcb.png)<br>&emsp;Other Settings (Information that I don't think is important but in case if it would be)<br>&emsp;&emsp;- Tablet: EvTouch USB Graphics Tablet (Type), Absolute Movement (Mode)<br>&emsp;&emsp;- Sound: HDA (ICH9)<br>&emsp;&emsp;- Console Device Type: pty<br>&emsp;&emsp;- Display Spice Type: Spice server<br>
17. Click "Begin Installation"
18. After clicking "Begin Installation", Virt-Manager should automatically start the Virtual Machine. Boot into "LiveCD (kernel: gentoo)<br>![image](https://user-images.githubusercontent.com/47036723/158042060-6a6a2221-9746-42a4-a266-b4f8a60e36bb.png)


# Installing Gentoo
After booting into the live CD, the screen should look like this:<br>![image](https://user-images.githubusercontent.com/47036723/158042119-2c2fee6a-1d1a-4bbf-be3b-cefacd3f4f90.png)

The following contains commands exactly as I typed them in order. I'll occasionally show screenshots to show some important information. I'll try to be as transparent as possible, but I'll try to not use so many screenshots

1. **livecd ~ # ping -c3 www.gentoo.org**<br>
   Note: This command failed for me because for some reason, the default IP address saved on resolv.conf isn't a valid DNS. I solved this by these commands:<br>
      a. **livecd ~ # nano /etc/resolv.conf**<br>
      b. Original file:<br>![image](https://user-images.githubusercontent.com/47036723/158042284-bd2e3f27-76df-4e76-af94-5262f9abda5f.png)<br>
      c. Edits:<br>![image](https://user-images.githubusercontent.com/47036723/158042349-15188150-2e74-416e-9a6b-daeadd1481b3.png)<br>
2. **livecd ~ # ping -c3 www.gentoo.org**<br>
   Note: Command worked this time<br>![image](https://user-images.githubusercontent.com/47036723/158042681-7bda119f-2243-4c00-a41e-8bcd87393966.png)<br>
