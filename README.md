# gentoo-config

This is a work-in-progress guide to build Gentoo Linux. I'm mapping out EXACTLY what I did to my VM to make it easier for others to help me solve problems.

This setup has been done on a QEMU KVM hypervisor on a Arch Linux host. This is my host setup:
![image](https://user-images.githubusercontent.com/47036723/158039894-8337d0db-e63c-43e1-afd9-fc81e0f41b4d.png)

QEMU/KVM Virt-manager Versions: 4.0.0

Gentoo ISO File Used: install-amd64-minimal-20220227T170528Z.iso

# Setting Up Virtual Machine on Virt-Manager

1. Create a new virtual machine

![image](https://user-images.githubusercontent.com/47036723/158039966-403e8835-8871-4c33-a915-6542802c8259.png)

a. Select "Local install media (ISO image or CDROM)
![image](https://user-images.githubusercontent.com/47036723/158040033-4f539e53-a665-44c0-94d6-0f81bd4e4c9c.png)
     
b. Choose "install-amd64-minimal-20220227T170528Z.iso" file
   ![image](https://user-images.githubusercontent.com/47036723/158040074-63e2a2e3-518d-47e0-a7f1-c742d13e4ce9.png)

c. Memory: 16384 MiB (16 GB)
   CPUs (Threads): 8
   ![image](https://user-images.githubusercontent.com/47036723/158040123-367645b3-d6d9-4c4e-8047-6de5af83bc03.png)

d. I'm using a secondary hard drive that is 500GB but I'll use 100GB for the VM
   I'm not sure what "Allocate entire volume now" means, but I'll check it because that seems to make sense to do.
   ![image](https://user-images.githubusercontent.com/47036723/158040209-523fabeb-069c-4c1c-b152-9c73c2b04e54.png)

e. After clicking "Finish", the storage will be allocated.

f. Choose the allocated storage volume for the Gentoo VM (mine is called "gentoo.qcow2")

g. Check "Customize configuration before install" then click "Finish"
   ![image](https://user-images.githubusercontent.com/47036723/158040262-89a3ad74-c50c-41f2-849e-28ed773b335b.png)

h. Overview:
   ![image](https://user-images.githubusercontent.com/47036723/158040301-a3be05b8-057a-45bb-a9c9-8c4e95c743b2.png)

i. CPUs:
   ![image](https://user-images.githubusercontent.com/47036723/158040344-e9d9d2b1-70ef-494e-95df-ae1e7c6952fb.png)

j. Memory:
   ![image](https://user-images.githubusercontent.com/47036723/158040505-88a7ec4f-f1b4-4352-8494-d112f49664bf.png)

k. Boot Options:
   ![image](https://user-images.githubusercontent.com/47036723/158040514-c3e77aee-312e-4a15-ad2d-e679749054b3.png)

l. Disk 1: 
   ![image](https://user-images.githubusercontent.com/47036723/158040544-f9b8f811-8746-4cd8-81a3-8169a155d11d.png)

m. SATA CDROM 1:
   ![image](https://user-images.githubusercontent.com/47036723/158040569-7dc93b94-9bac-46f1-910c-137791a81fa1.png)

n. NIC:
   ![image](https://user-images.githubusercontent.com/47036723/158040585-c18ec545-802f-41a5-8d01-e560fa43799c.png)

o. Video:
   ![image](https://user-images.githubusercontent.com/47036723/158040652-8c5c75a4-8094-4833-9653-8196a0569f5f.png)

p. Other Settings (Information that I don't think is important but in case if it would be):
    - Tablet: EvTouch USB Graphics Tablet (Type), Absolute Movement (Mode)
    - Sound: HDA (ICH9)
    - Console Device Type: pty
    - Display Spice Type: Spice server
      
     
