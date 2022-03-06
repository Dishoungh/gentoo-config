# gentoo-config

This is a work-in-progress guide to build Gentoo Linux

This setup has been done on a QEMU KVM hypervisor on a Arch Linux host. Follow these commands


On Arch Linux host:
1. qemu-img create -f qcow2 {PATH TO STORAGE FILE}.img/qcow2 {SIZE (e.g. 100G)}
2. qemu-system-x86_64 -enable-kvm -cpu host -drive file={PATH_TO_STORAGE}.img/qcow2,if=virtio -netdev user,id=vmnic,hostname={NAME} -device virtio-net,netdev=vmnic -device virtio-rng-pci -m 512M -smp 2 -monitor stdio -name "{NAME}" -boot d -cdrom {PATH TO GENTOO ISO FILE}.iso

On Gentoo guest:
Note: We will boot on BIOS, not UEFI. 
1. ping www.gentoo.org -c3
    If the ping doesn't work, either you're not connected to the internet or your DNS resolver is incorrectly setup. Try:
    # ping 8.8.8.8 -c3
    
    If that is successful but the ping with the URL wasn't, then you need to change your DNS resolver.

    # nano /etc/resolv.conf
    
    Change the "nameserver" value to something like 8.8.8.8 or 8.8.8.4 (these are common DNS servers provided by Google)
    
    The ping should work now
    
2. fdisk /dev/{DEVICE} (I'm using /dev/vda as a VirtIO drive in the VM)
    a. DOS/MBR is the disklabel by default (Type "g" if you're using UEFI to write the GPT disklabel)
    b. Type n for new partition
    c. Type p for primary
    d. Type 1 for Partition #1
    e. Press Enter for first sector
    f. Type "+256M" to allocate 256M of space to this partition
    g. Type n for new partition
    h. Type p for primary
    i. Type 2 for Partition #2
    j. Press Enter for first sector
    k. Type "+4G"
    l. Type t for type
    m. Type 2 for Partition #2
    n. Type 82 to assign /dev/{DEVICE}2's type as Linux swap
    o. Type n for new partition
    p. Type p for primary
    q. Type 3 for Partition #3
    r. Press Enter for first sector
    s. Press Enter for last sector to allocate the rest of the overall disk space
    t. Type p to print partitions and you should see 3 partitions.
    u. Type w to write the partitions into the disk

3. mkfs.ext4 /dev/{DEVICE}1
  a. # mkfs.vfat -F 32 /dev/{DEVICE}1 (if you're using UEFI)

4. mkfs.ext4 /dev/{DEVICE}3
5. mkswap /dev/{DEVICE}2
6. swapon /dev/{DEVICE}2
7. 
