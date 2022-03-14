# gentoo-vm-config

This is a work-in-progress guide for me to build a Gentoo VM. I'm mapping out EXACTLY what I did to my VM to make it easier for others to help me troubleshoot.

Depending on how large this gets, I'll probably separate this README to multiple READMEs or keep it as one depending on which one is easiest to read.

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


# Installing Gentoo (Before Make Menuconfig)

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
47. **(chroot) livecd / # cd /usr/src/linux && make menuconfig**

# Configuring Kernel (Make Menuconfig)
This is what I have configured in my Kernel config. I will try to be as detailed as possible with the EXACT changes I made so this may be very long. Keep in mind that I will have to work around Markdown's formatting to portray my changes as accurately as possible. I know I can just use genkernel to make a completely generic kernel or use a prebuilt kernel, but I think that pretty much destroys the whole point of Gentoo. I want to learn to configure the kernel myself.

Kernel Version: Linux/x86 5.16.14-gentoo

(*) = Built into the kernel<br>
(M) = Built as a module<br>
(X) = Selected
( ) = Excluded<br>

Here is what I have:

- General setup --->
   - ( ) Compile also drivers which will not load (NEW)
   - ( ) Compile the kernel with warnings as errors (NEW)
   - () Local version - append to kernel release (NEW)
   - ( ) Automatically append version information to the version string
   - () Build ID Salt (NEW)
   - Kernel compression mode (LZ4) --->
      - ( ) Gzip
      - ( ) Bzip2
      - ( ) LZMA
      - ( ) XZ
      - ( ) LZO
      - (X) LZ4
      - ( ) ZSTD
   - () Default init path (NEW)
   - ((none)) Default hostname (NEW)
   - (*) Support for paging of anonymous memory (swap) (NEW)
   - (*) System V IPC
   - ( ) POSIX Message Queues
   - ( ) General notification queue (NEW)
   - ( ) Enable process_vm_readv/writev syscalls
   - ( ) uselib syscall
   - ( ) Auditing support
   - IRQ subsystem --->
      - ( ) Expose irq internals in debugfs (NEW)  
   - Timers subsystem --->
      - Timer tick handling (Periodic timer ticks (constant rate, no dynticks))
      - ( ) Old Idle dynticks config
      - ( ) High Resolution Timer Support
   - BPF subsystem --->
      - ( ) Enable bpf() system call (NEW)
      - ( ) Enable BPF Just In Time compiler (NEW) 
   - Preemption Model (Voluntary Kernel Preemption (Desktop)) --->
      - ( ) No Forced Preemption (Server)
      - (X) Voluntary Kernel Preemption (Desktop)
      - ( ) Preemptible Kernel (Low-Latency Desktop)
   - (*) Preemption behaviour defined on boot (NEW)
   - ( ) Core Scheduling for SMT (NEW)
   - CPU/Task time and stats accounting --->
      - Cputime accounting (Simple tick based cputime accounting) --->
      - ( ) Fine granularity task level IRQ time accounting (NEW)
      - ( ) BSD Process Accounting
      - ( ) Export task/process statistics through netlink
      - ( ) Pressure stall information tracking (NEW)
   - (*) CPU isolation (NEW)
   - RCU Subsystem --->
      - ( ) Make expert-level adjustment to RCU configuration (NEW) 
   - (*) Kernel .config support
   - ( ) Enable access to .config through /proc/config.gz (NEW)
   - ( ) Enable kernel headers through /sys/kernel/kheaders.tar.xz (NEW)
   - (15) Kernel log buffer size (16 => 64KB, 17 => 128KB)
   - (15) CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)
   - (12) Temporary per-CPU printk log buffer size (12 => 4KB, 13 => 8KB)
   - ( ) Printk indexing debugfs interface (NEW)
   - Scheduler features --->
      - ( ) Enable utilization clamping for RT/FAIR tasks (NEW) 
   - (*) Control Group support --->
      - ( ) Memory controller (NEW)
      - ( ) IO controller (NEW)
      - (*) CPU controller --->
         -  (*) Group scheduling for SCHED_OTHER (NEW)
         -  ( ) CPU bandwidth provisioning for FAIR_GROUP_SCHED (NEW)
         -  Group scheduling for SCHED_RR/FIFO (NEW)
      - ( ) PIDs controller (NEW)
      - ( ) RDMA controller (NEW)
      - ( ) Freezer controller
      - ( ) HugeTLB controller (NEW)
      - (*) Cpuset controller
      - (*) Include legacy /proc/<pid>/cpuset file (NEW)
      - (*) Device controller (NEW)
      - (*) Simple CPU accounting controller
      - ( ) Perf controller (NEW)
      - ( ) Misc resource controller (NEW)
      - ( ) Debug controller (NEW)
   - (*) Namespaces support --->
      - (*) UTS namespace
      - (*) TIME namespace (NEW)
      - (*) IPC namespace
      - (*) User namespace
      - (*) PID Namespaces
      - (*) Network namespace
   - ( ) Checkpoint/restore support (NEW)
   - ( ) Automatic process group scheduling (NEW)
   - ( ) Enable deprecated sysfs features to support old userspace tools (NEW)
   - (*) Kernel->user space relay support (formerly relayfs)
   - (*) Initial RAM filesystem and RAM disk (initramfs/initrd) support
   - () Initramfs source fil(s) (NEW)
   - ( ) Support initial ramdisk/ramfs compressed using gzip
   - ( ) Support initial ramdisk/ramfs compressed using bzip2
   - ( ) Support initial ramdisk/ramfs compressed using LZMA
   - ( ) Support initial ramdisk/ramfs compressed using XZ
   - (*) Support initial ramdisk/ramfs compressed using LZO (NEW)
   - (*) Support initial ramdisk/ramfs compressed using LZ4 (NEW)
   - ( ) Support initial ramdisk/ramfs compressed using ZSTD
   - ( ) Boot config support (NEW)
   - Compiler optimization level (Optimize for performance (-O2)) --->
      - (X) Optimize for performance (-O2)
      - ( ) Optimize for size (-Os)
   - ( ) Configure standard kernel features (expert users) (NEW)
   - (*) Load all symbols for debugging/ksymoops
   - (*) Include all symbols in kallsyms
   - ( ) Enable userfaultfd() system call (NEW)
   - ( ) Embedded system (NEW)
   - Kernel Performance Events And Counters --->
      - ( ) Debug: use vmalloc to back perf mmap() buffers (NEW)
   - ( ) Disable heap randomization
   - Choose SLAB allocator (SLUB (Unqueued Allocator)) --->
      - ( ) SLAB
      - (X) SLUB (Unqueued Allocator)
   - (*) Allow slab caches to be merged (NEW)
   - ( ) Randomize slab freelist (NEW)
   - ( ) Harden slab freelist metadata (NEW)
   - ( ) Page allocator randomization (NEW)
   - (*) SLUB per cpu partial cache (NEW)
   - (*) Profiling support
- (*) 64-bit kernel (NEW)
- Processor type and features --->
   - (*) Symmetric multi-processing support
   - (*) Support x2apic
   - ( ) Enable MPS table
   - (*) Avoid speculative indirect branches in kernel (NEW)
   - ( ) x86 CPU resource control support (NEW)
   - ( ) Support for extended (non-PC) x86 platforms
   - ( ) Intel Low Power Subsystem Support (NEW)
   - (*) AMD ACPI2Platform devices support
   - ( ) Intel SoC IOSF Sideband support for SoC platforms (NEW)
   - (*) Single-depth WCHAN output (NEW)
   - (*) Linux guest support --->
      - (*) Enable paravirtualization code
      - ( ) paravirt-ops debugging (NEW)
      - ( ) Paravirtualization layer for spinlocks (NEW)
      - ( ) Xen guest support (NEW)
      - (*) KVM Guest support (including kvmclock) (NEW)
      - (*) Disable host haltpoll when loading haltpoll driver
      - ( ) Support for running PVH guests (NEW)
      - ( ) Paravirtual steal time accounting (NEW)
      - ( ) Jailhouse non-root cell support (NEW)
      - ( ) ACRN Guest support (NEW)
   - Processor family (Opteron/Athlon64/Hammer/K8) --->
      - (X) Opteron/Athlon64/Hammer/K8
      - ( ) Intel P4 / older Netburst based Xeon
      - ( ) Core 2/newer Xeon
      - ( ) Intel Atom
      - ( ) Generic-x86-64
   - ( ) Old AMD GART IOMMU support (NEW)
   - ( ) Enable Maximum number of SMP Processors and NUMA Nodes (NEW)
   - (8) Maximum number of CPUs
   - (*) Cluster scheduler support (NEW)
   - (*) Multi-core scheduler support (NEW)
   - (*) CPU core priorities scheduler support (NEW)
   - (*) Reroute for broken boot IRQs
   - (*) Machine Check /overheating reporting (NEW)
   - ( ) Support for deprecated /dev/mcelog character device (NEW)
   - ( ) Intel MCE features
   - (*) AMD MCE features (NEW)
   - ( ) Machine check injector support (NEW)
   - Performance monitoring --->
   - ( ) IOPERM and IOPL Emulation
   - ( ) Dell i8k legacy laptop support (NEW)
   - (*) CPU microcode loading support (NEW)
   - ( ) Intel microcode loading support
   - (*) AMD microcode loading support
   - ( ) Ancient loading interfadce (DEPRECATED) (NEW)
   - (*) /dev/cpu/*/msr - Model-specific register support
   - (*) /dev/cpu/*/cpuid - CPU information support
   - ( ) Enable 5-level page tables support
   - ( ) Enable statistic for Change Page Attribute (NEW)
   - ( ) AMD Secure Memory Encryption (SME) support (NEW)
   - ( ) NUMA Memory Allocation and Scheduler Support
   - ( ) Support non-standard NVDIMMs and ADR protected memory (NEW)
   - ( ) Check for low memory corruption
   - (*) MTRR (Memory Type Range Register) support
   - (*) MTRR cleanup support
   - (1) MTRR cleanup enable value (0-1)
   - (1) MTRR cleanup spare reg num (0-7) (NEW)
   - ( ) Memory Protection Keys
   - ( ) TSX enable mode (off) --->
      - (X) off
      - ( ) on
      - ( ) auto
   - ( ) Software Guard eXtensions (SGX) (NEW)
   - (*) EFI runtime service support
   - (*) EFI stub support
   - (*) EFI mixed-mode support
   - Timer frequency (1000 Hz) --->
      - ( ) 100 HZ
      - ( ) 250 HZ
      - ( ) 300 HZ
      - (X) 1000 HZ
   - (*) kexec system call
   - ( ) kexec file based system call (NEW)
   - (*) kernel crash dumps
   - ( ) kexec jump (NEW)
   - (0x1000000) Physical address where the kernel is loaded (NEW)
   - (*) Build a relocatable kernel
   - (*) Randomize the address of the kernel image (KASLR) (NEW)
   - (0x200000) Alignment value to which kernel should be aligned (NEW)
   - (*) Randomize the kernel memory sections (NEW)
   - ( ) Set default setting of cpu0_hotpluggable (NEW)
   - ( ) Debug CPU0 hotplug (NEW)
   - ( ) Disable the 32-bit vDSO (needed for glibc 2.3.3) (NEW)
   - vsyscall table for legacy applications (Emulate execution only) --->
      - ( ) Full emulation
      - (X) Emulate execution only
      - ( ) None
   - Built-in kernel command line (NEW)
   - Enforce strict size checking for sigalstack (NEW)
- Power management and ACPI options --->
   - (*) Suspend to RAM and standby (NEW)
   - (*) Hibernation (aka 'suspend to disk')
   - (*) Userspace snapshot device (NEW)
   - () Default resume partition (NEW)
   - ( ) Opportunistic sleep (NEW)
   - ( ) User space wakeup sources interface (NEW)
   - (*) Device power management core funtionality
   - ( ) Power Management Debug Support
   - ( ) Enable workqueue power-efficient mode by default (NEW)
   - ( ) Energy Model for devices with DVFS (CPUs, GPUs, etc) (NEW)
   - (*) ACPI (Advanced Configuration and Power Interface) Support (NEW) --->
      - ( ) AML debugger interface (NEW)
      - (*) ACPI Serial Port Console Redirection Support (NEW)
      - ( ) ACPI Firmware Performance Data Table (FPDT) support (NEW)
      - (*) Allow supported ACPI revision to be overridden (NEW)
      - ( ) EC read/write access through /sys/kernel/debug/ec (NEW)
      - (*) AC Adapter (NEW)
      - (*) Battery (NEW)
      - (*) Button (NEW)
      - ( ) Video (NEW)
      - (*) Fan (NEW)
      - ( ) ACPI Time and Alarm (TAD) Device Support (NEW)
      - (*) Dock
      - (*) Processor
      - ( ) Processor Aggregator (NEW)
      - (*) Thermal Zone (NEW)
      - (*) Allow upgrading ACPI tables via initrd (NEW)
      - ( ) Debug Statements (NEW)
      - ( ) PCI slot detection driver (NEW)
      - (*) Container and Module Devices
      - ( ) Smart Battery System (NEW)
      - ( ) Hardware Error Device (NEW)
      - ( ) Allow ACPI methods to be inserted/replaced at run time (NEW)
      - (*) Boottime Graphics Resource Table support
      - ( ) ACPI NVDIMM Firmware Interface Table (NFIT) (NEW) 
      - ( ) ACPI Platform Error Interface (APEI) (NEW)
      - ( ) Intel DPTF (Dynamic Platform and Thermal Framework) Support (NEW)
      - ( ) ACPI configfs support (NEW)
      - ( ) PMIC (Power Management Integrated Circuit) operation region support (NEW)
   - (*) Platform Runtime Mechanism Support (NEW)
   - CPU Frequency scaling --->
      - ( ) CPU frequency transition statistics
      - Default CPUFreq governor (userspace) --->
         - ( ) performance
         - ( ) powersave
         - (X) userspace
         - ( ) schedutil
      - (*) 'performance' governor
      - ( ) 'powersave' governor (NEW)
      - (*) 'userspace' governor for userspace frequency scaling
      - (*) 'ondemand' cpufreq policy governor
      - ( ) 'conservative' cpufreq governor (NEW)
      - (*) 'schedutil' cpufreq policy governor
         *** CPU frequency scaling drivers ***
      - (*) Intel P state control
      - ( ) Processor Clocking Control interface driver (NEW)
      - (*) ACPI Processor P-States driver
      - (*) Legacy cpb sysfs knob support for AMD CPUs (NEW)
      - ( ) AMD Operon/Athlon64 PowerNow! (NEW)
      - (*) AMD frequency sensitivity feedback powersave bias
      - ( ) Intel Enhanced SpeedStep (deprecated) (NEW)
      - ( ) Intel Pentium 4 clock modulation (NEW)
         *** shared options ***
   - CPU Idle --->
      - (*) Ladder governor (for periodic timer tick)
      - ( ) Menu governor (for tickless system) (NEW) 
      - ( ) Timer events oriented (TEO) governor (for tickless systems) (NEW)
      - ( ) Haltpoll governor (for virtualized systems) (NEW)
      - (*) Halt poll cpuidle driver (NEW)
   - ( ) Cpuidle Driver for Intel Processors (NEW)
- Bus options (PCI etc.) --->
   - (*) Support mmconfig PCI config space access (NEW)
- Binary Emulations --->
   - (*) IA32 Emulation
   - ( ) x32 ABI for 64-bit mode (NEW)
- (*) Virtualization (NEW)
- General architecture-dependent options --->
   - (*) Kprobes
   - (*) Optimize very unlikely/likely branches
   - ( ) Static key selftest (NEW)
   - (*) Enable seccomp to safely execute untrusted bytecode (NEW) 
   - ( ) Show seccomp filter cache status in /proc/pid/seccomp_cache (NEW)
   - (*) Stack Protector buffer overflow detection (NEW)
   - (*) Strong Stack Protector (NEW)
   - Link Time Optimization (LTO) (None) --->
      - (X) None
   - (*) Provide system calls for 32-bit time_t (NEW)
   - (*) Use a virtually-mapped stack (NEW)
   - ( ) Randomize kernel stack offset on syscall entry (NEW)
   - ( ) Locking event counts collection (NEW)
   - GCOV-based kernel profiling --->
      - ( ) Enable gcov-based kernel profiling (NEW)
   - (*) GCC plugins (NEW) --->
      - ( ) Generate some entropy during boot and runtime (NEW)
      - ( ) Randomize layout of sensitive kernel structures (NEW)
- (*) Enable loadable module support --->
   - ( ) Forced module loading (NEW)
   - (*) Module unloading
   - ( ) Forced module unloading
   - ( ) Module versioning support (NEW)
   - ( ) Source checksum for all modules (NEW)
   - ( ) Module signature verification (NEW)
   - Module compression mode (None) --->
      - (X) None
      - ( ) GZIP
      - ( ) XZ
      - ( ) ZSTD
   - ( ) Allow loading of modules with missing namespace imports (NEW)
   - (/sbin/modprobe) Path to modprobe binary (NEW)
- (*) Enable the block layer --->
   - ( ) Block layer SG support v4 helper lib (NEW)
   - ( ) Block layer data integrity support (NEW)
   - ( ) Zoned block device support (NEW)
   - ( ) Enable support for block device writeback throttling (NEW)
   - ( ) Block layer debugging information in debugfs
   - ( ) Logic for interfacing with Opal enabled SEDs (NEW)
   - ( ) Enable inline encryption support in block layer (NEW)
   - Partition Types --->
      - (*) Advanced partition selection
      - ( ) Acorn partition support (NEW)
      - ( ) AIX basic partition table support (NEW)
      - ( ) Alpha OSF partition support (NEW)
      - ( ) Amiga partition table support (NEW)
      - ( ) Atari partition table support (NEW)
      - ( ) Macintosh partition map support (NEW)
      - ( ) PC BIOS (MSDOS partition tables) support
      - ( ) Windows Logical Disk Manager (Dynamic Disk) support (NEW)
      - ( ) SGI partition support (NEW)
      - ( ) Ultrix partition table support (NEW)
      - ( ) Sun partition tables support (NEW)
      - ( ) Karma Partition support (NEW)
      - (*) EFI GUID Partition support (NEW) 
      - ( ) SYSV68 partition table support (NEW)
      - ( ) Command line partition support (NEW)
   - IO Schedulers --->
      - (*) MQ deadline I/O scheduler (NEW)
      - (*) Kyber I/O scheduler (NEW)
      - ( ) BFQ I/O scheduler
- (*) Executable file formats --->
   - (*) Kernel support for ELF binaries 
   - (*) Write ELF core dumps with partial segments (NEW)
   - (*) Kernel support for scripts starting with #!
   - (*) Kernel support for MISC binaries
- Memory Management options --->
   - Memory model (Sparse Memory) --->
      - (X) Sparse Memory
   - (*) Sparse Memory virtual memmap (NEW)
   - ( ) Allow for memory hot-add (NEW)
   - (*) Allow for memory compaction (NEW)
   - ( ) Free page reporting (NEW)
   - (*) Page migration
   - ( ) Enable KSM for page merging (NEW)
   - (4096) Low address space to protect from user allocation (NEW)
   - ( ) Enable recovery from hardware memory errors (NEW)
   - ( ) Transparent Hugepage Support (NEW)
   - ( ) Enable cleancache driver to cache clean pages if tmem is present (NEW)
   - ( ) Enable frontswap to cache swap pages if tmem is present (NEW)
   - ( ) Contiguous Memory Allocator (NEW)
   - ( ) Common API for compressed memory storage (NEW)
   - ( ) Memory allocator for compressed pages (NEW)
   - ( ) Defer initialisation of struct pages to kthreads (NEW)
   - ( ) Enable idle page tracking (NEW)
   - ( ) Collect percpu memory statistics (NEW)
   - ( ) Enable infrastructure for get_user_pages()-related unit tests (NEW)
   - ( ) Data Access Monitoring --->
      - ( ) DAMON: Data Access Monitoring Framework (NEW)
- (*) Networking support --->
   - Networking options --->
      - (*) Packet socket
      - ( ) Packet: sockets monitoring interface (NEW)
      - (*) Unix domain sockets 
      - ( ) UNIX: socket monitoring interface (NEW)
      - ( ) Transport Layer Security support (NEW)
      - (*) Transformation user configuration interface 
      - ( ) Compatible ABI support (NEW)
      - ( ) Transformation virtual interface (NEW)
      - ( ) Transformation sub policy support (NEW)
      - ( ) Transformation migrate database (NEW)
      - ( ) Transformation statistics (NEW)
      - ( ) PF_KEY sockets (NEW)
      - (*) TCP/IP networking
      - (*) IP: multicasting
      - (*) IP: advanced router
      - ( ) FIB TRIE statistics (NEW)
      - (*) IP: policy routing
      - (*) IP: equal cost multipath
      - (*) IP: verbose route monitoring
      - (*) IP: kernel level autoconfiguration
      - (*) IP: DHCP support
      - (*) IP: BOOTP support
      - (*) IP: RARP support
      - ( ) IP: tunneling (NEW) 
      - ( ) IP: GRE demultiplexer (NEW)
      - (*) IP: multicast routing 
      - ( ) IP: multicast policy routing (NEW)
      - (*) IP: PIM-SM version 1 support
      - (*) IP: PIM-SM version 2 support
      - (*) IP: TCP syncookie support
      - ( ) Virtual (secure) IP: tunneling (NEW)
      - ( ) IP: Foo (IP protocols) over UDP (NEW)
      - ( ) IP: FOU encapsulation of IP tunnels (NEW)
      - ( ) IP: AH transformation (NEW)
      - ( ) IP: ESP transformation (NEW)
      - ( ) IP: IPComp transformation (NEW)
      - ( ) INET: socket monitoring interface
      - (*) TCP: advanced congestion control --->
         - ( ) Binary Increase Congestion (BIC) control
         - (*) CUBIC TCP (NEW)
         - ( ) TCP Westwood+
         - ( ) H-TCP
         - ( ) High Speed TCP (NEW)
         - ( ) TCP-Hybla congestion control algorithm (NEW)
         - ( ) TCP Vegas (NEW)
         - ( ) TCP NV (NEW)
         - ( ) Scalable TCP (NEW)
         - ( ) TCP Low Priority (NEW)
         - ( ) TCP Veno (NEW)
         - ( ) YeAH TCP (NEW)
         - ( ) TCP Illinois (NEW)
         - ( ) DataCenter TCP (DCTCP) (NEW)
         - ( ) CAIA Delay-Gradient (CDG) (NEW)
         - ( ) BBR TCP (NEW)
         - Default TCP congestion control (Cubic) --->
            - (X) Cubic
            - ( ) Reno
      - (*) TCP: MD5 Signature Option support (RFC2385) 
      - (*) The IPv6 protocol (NEW) ---> 
      - (*) NetLabel subsystem support
      - ( ) MPTCP: Multipath TCP (NEW)
      - ( ) Security Marking (NEW)
      - ( ) Timestamping in PHY devices (NEW) 
      - (*) Network packet filtering framework (Netfilter) --->
         - ( ) Advanced netfilter configuration
         - Core Netfilter Configuration --->
            - (*) Netfilter ingress support (NEW)
            - (*) Netfilter egress support (NEW)
            - (*) Netfilter LOG over NFNETLINK interface
            - (*) Netfilter connection tracking support
            - (M) Syslog packet logging (NEW)
            - (*) Supply CT list in procfs (OBSOLETE) (NEW) 
            - ( ) Connection tracking labels (NEW)
            - (*) FTP protocol support
            - (*) IRC protocol support
            - ( ) NetBIOS name service protocol support (NEW) 
            - (*) SIP protocol support
            - (*) Connection tracking netlink interface
            - ( ) NFQUEUE and NFLOG integration with Connection Tracking (NEW)
            - (*) Network Address Translation support
            - ( ) Netfilter nf_tables support (NEW)
            - (*) Netfilter Xtables support (required for ip_tables)
            - (*) Netfilter Xtables 32bit support (NEW)
               *** Xtables combined modules ***
            - (M) nfmark target and match support (NEW)
               *** Xtables targets ***
            - (M) LOG target support (NEW)
            - (M) "SNAT and DNAT" targets supports (NEW)
            - ( ) "NETMAP" target support (NEW)
            - (*) "NFLOG" target support
            - ( ) REDIRECT target support (NEW)
            - (M) MASQUERADE target support (NEW)
            - (*) "TCPMSS" target support
               *** Xtables matches ***
            - (M) "addrtype" address type match support (NEW)
            - (*) "conntrack" connection tracking match support
            - (*) IPsec "policy" match support
            - (*) "state" match support
         - ( ) IP set support (NEW)
         - ( ) IP virtual server support (NEW)
         - IP: Netfilter Configuration --->
            - ( ) IPv4 socket lookup support (NEW)
            - ( ) IPv4 tproxy support (NEW)
            - ( ) Netfilter IPv4 packet duplication to alternate destination (NEW)
            - (M) ARP packet logging (NEW)
            - (M) IPv4 packet logging (NEW)
            - (*) IPv4 packet rejection
            - (*) IP tables support (required for filtering/masq/NAT)
            - (*) Packet filtering
            - (*) REJECT target support
            - (M) iptables NAT support (NEW)
            - (M) MASQUERADE target support
            - (*) Packet mangling
            - ( ) raw table support (required for NOTRACK/TRACE) (NEW)
         - IPv6: Netfilter Configuration --->
            - ( ) IPv6 socket lookup support (NEW)
            - ( ) IPv6 tproxy support (NEW)
            - ( ) Netfilter IPv6 packet duplication to alternate destination (NEW)
            - (*) IPv6 packet rejection
            - (M) IPv6 packet logging (NEW)
            - (*) IP6 tables support (required for filtering)
            - (*) "ipv6header" IPv6 Extension Headers Match
            - (*) Packet filtering
            - (*) REJECT target support
            - (*) Packet mangling
            - ( ) raw table support (required for TRACE) (NEW)
         - ( ) IPv4/IPV6 bridge connection tracking support (NEW)
      - ( ) BPF based packet filtering framework (BPFILTER) (NEW)
      - ( ) The DCCP Protocol (NEW)
      - ( ) The SCTP Protocol (NEW)
      - ( ) The Reliable Datagram Sockets Protocol (NEW)
      - ( ) The TIPC Protocol (NEW)
      - ( ) Asynchronous Trnsfer Mode (ATM) (NEW)
      - ( ) Layer Two Tunneling Protocol (L2TP) (NEW)
      - ( ) 802.1d Ethernet Bridging (NEW)
      - ( ) DECnet Support (NEW)
      - ( ) ANSI/IEEE 802.2 LLC type 2 Support (NEW)
      - ( ) Appletalk protocol support (NEW)
      - ( ) CCITT X.25 Packet Layer (NEW)
      - ( ) LAPB Data Link Driver (NEW)
      - ( ) Phonet protocols family (NEW)
      - ( ) 6LoWPAN Support (NEW)
      - ( ) IEEE Std 802.15.4 Low-Rate Wireless Personal Area Networks support (NEW)
      - (*) QoS and/or fair queueing --->
         *** Queueing/Scheduling ***
         - ( ) Class Based Queueing (CBQ) (NEW)
         - ( ) Hierarchical Token Bucket (HTB) (NEW)
         - ( ) Hierarchical Fair Service Curve (HFSC) (NEW)
         - ( ) Multi Band Priority Queueing (PRIO) (NEW)
         - ( ) Hardware Multiqueue-aware Multi Band Queuing (MULTIQ) (NEW)
         - ( ) Random Early Detection (RED) (NEW)
         - ( ) Stochastic Fair Blue (SFB) (NEW)
         - ( ) Stochastic Fairness Queueing (SFQ) (NEW)
         - ( ) True Link Equalizer (TEQL) (NEW)
         - ( ) Token Bucket Filter (TBF) (NEW)
         - ( ) Credit Based Shaper (CBS) (NEW)
         - ( ) Earliest TxTime First (ETF) (NEW)
         - ( ) Time Aware Priority (taprio) Scheduler (NEW)
         - ( ) Generic Random Early Detection (GRED) (NEW)
         - ( ) Differentiated Services marker (DSMARK) (NEW)
         - ( ) Network emulator (NETEM) (NEW)
         - ( ) Deficit Round Robin scheduler (DRR) (NEW)
         - ( ) Multi-queue priority scheduler (MQPRIO) (NEW)
         - ( ) SKB priority queue scheduler (SKBPRIO) (NEW)
         - ( ) CHOose and Keep responsive flow scheduler (CHOKE) (NEW)
         - ( ) Quick Fair Queueing scheduler (QFQ) (NEW)
         - ( ) Controlled Delay AQM (CODEL) (NEW)
         - ( ) Fair Queue Controlled Delay AQM (FQ_CODEL) (NEW)
         - ( ) Common Applications Kept Enahanced (CAKE) (NEW)
         - ( ) Fair Queue (NEW)
         - ( ) Heavy-Hitter Filter (HHF) (NEW)
         - ( ) Proportional Integral controller Enhanced (PIE) scheduler (NEW)
         - ( ) Ingress/classifier-action Qdisc (NEW)
         - ( ) Plug network traffic until release (PLUG) (NEW)
         - ( ) Enhanced transmission selection scheduler (ETS) (NEW)
         - ( ) Allow override default queue discipline (NEW)
         *** Classsification ***
         - ( ) Elementary classification (BASIC) (NEW)
         - ( ) Traffic-Control Index (TCINDEX) (NEW)
         - ( ) Routing decision (ROUTE) (NEW)
         - ( ) Netfilter mark (FW) (NEW)
         - ( ) Universal 32bit comparisons w/ hashing  (U32) (NEW)
         - ( ) IPv4 Resource Reservation Protocol (RSVP) (NEW)
         - ( ) IPv6 Resource Reservation Protocol (RSVP6) (NEW)
         - ( ) Flow classifier (NEW)
         - ( ) Control Group Classifier (NEW)
         - ( ) BPF-based classifier (NEW)
         - ( ) Flower classifier (NEW)
         - ( ) Match-all classifier (NEW)
         - (*) Extended Matches 
         - (32) Stack Size (NEW)
         - ( ) Simple packet data comparison (NEW)
         - ( ) Multi byte comparison (NEW)
         - ( ) U32 key (NEW)
         - ( ) Metadata (NEW)
         - ( ) Textsearch (NEW)
         - ( ) IPtables Matches (NEW)
         - (*) Actions 
         - ( ) Traffic Policing (NEW)
         - ( ) Generic actions (NEW)
         - ( ) Redirecting and Mirroring (NEW)
         - ( ) Traffic Sampling (NEW)
         - ( ) IPtables targets (NEW)
         - ( ) Stateless NAT (NEW)
         - ( ) Packet Editing (NEW)
         - ( ) Simple Example (Debug) (NEW)
         - ( ) SKB Editing (NEW)
         - ( ) Checksum Updating (NEW)
         - ( ) MPLS manipulation (NEW)
         - ( ) Vlan manipulation (NEW)
         - ( ) BPF based action (NEW)
         - ( ) skb data modification action (NEW)
         - ( ) Inter-FE action based on IETF ForCES InterFE LFB (NEW)
         - ( ) IP tunnel metadata manipulation (NEW)
         - ( ) Frame gate entry list control tc action (NEW)
         - ( ) TC recirculation support (NEW)
      - ( ) Data Center Bridging support (NEW)
      - ( ) B.A.T.M.A.N. Advanced Meshing Protocol (NEW)
      - ( ) Open vSwitch (NEW)
      - (*) Virtual Socket protocol (NEW)
      - (*) Virtual Sockets monitoring interface 
      - (*) Virtual Sockets loopback transport (NEW)
      - (*) virtio transport for Virtual Sockets
      - ( ) NETLINK: socket monitoring interface (NEW)
      - ( ) MultiProtocol Label Switching (NEW)
      - ( ) Network Service Header (NSH) protocol (NEW)
      - ( ) High-availability Seamless Redundancy (HSR & PRP) (NEW)
      - ( ) Switch (and switch-ish) device support (NEW)
      - ( ) L3 Master device support (NEW)
      - ( ) Qualcomm IPC Router support (NEW)
      - ( ) NCSI interface support (NEW)
      - (*) Use percpu variables to maintain network device refcount (NEW) 
      - ( ) Network priority cgroup (NEW)
      - ( ) Network classid cgroup (NEW)
      - Network testing --->
         - ( ) Packet Generator (USE WITH CAUTION) (NEW)
         - ( ) Network packet drop alerting service (NEW)
   - ( ) Amateur Radio support (NEW)
   - ( ) CAN bus subsystem support (NEW)
   - ( ) Bluetooth subsystem support (NEW)
   - ( ) RxRPC session sockets (NEW)
   - ( ) KCM sockets (NEW)
   - ( ) MCTP core protocol support (NEW)
   - ( ) Wireless (NEW)
   - (*) RF switch subsystem support
   - ( ) Plan 9 Resource Sharing Support (9P2000) (NEW)
   - ( ) CAIF support (NEW)
   - ( ) Ceph core library (NEW)
   - ( ) NFC subsystem support (NEW)
   - ( ) Packet-sampling netlink channel (NEW)
   - ( ) Inter-FE based on IETF ForCES InterFE LFB (NEW)
   - ( ) Network light weight tunnels (NEW)
   - (*) Generic failover module
   - (*) Netlink interface for ethtool (NEW)
- Device Drivers --->
- File systems --->
- Security options --->
- (*) Cryptographic API --->
- Library routines --->
- Kernel hacking --->
- Gentoo Linux --->
   - (*) Gentoo Linux support (NEW)
   - (*) Linux dynamic and persistent device naming (userspace devfs) support (NEW)
   - (*) Select options required by Portage features (NEW)
   - Support for init systems, system and service managers --->
      - (*) OpenRC, runit and other script based systems and managers (NEW)
      - ( ) systemd (NEW)
   - ( ) Kernel Self Protection Project (NEW)
   - (*) Print firmware information that the kernel attempts to load (NEW)
