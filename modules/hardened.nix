{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{

  boot.kernelPackages = mkDefault pkgs.linuxPackages_6_9_hardened;

  environment.memoryAllocator.provider = mkDefault "scudo";
  #environment.variables.SCUDO_OPTIONS = mkDefault "ZeroContents=1";

  security.lockKernelModules = mkDefault true;

  security.protectKernelImage = mkDefault true;

  #security.allowSimultaneousMultithreading = mkDefault false;

  security.forcePageTableIsolation = mkDefault true;

  # This is required by podman to run containers in rootless mode.
  #security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;

  security.virtualisation.flushL1DataCache = mkDefault "always";

  #security.apparmor.enable = mkDefault true;
  #security.apparmor.killUnconfinedConfinables = mkDefault true;

  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"

    # Disable debugfs
    "debugfs=off"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    #"ax25"
    #"netrom"
    #"rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];
  boot.kernel.sysctl = {
    # Hide kptrs even for processes with CAP_SYSLOG
    "kernel.kptr_restrict" = mkOverride 500 2;

    # Disable bpf() JIT (to eliminate spray attacks)
    "net.core.bpf_jit_enable" = mkDefault false;

    # Disable ftrace debugging
    "kernel.ftrace_enabled" = mkDefault false;

    # Ignore broadcast ICMP (mitigate SMURF)
    #"net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

    "kernel.printk" = "3 3 3 3";
    # Restrict loading TTY line disciplines to the CAP_SYS_MODULE capability.
    "dev.tty.ldisc_autoload" = 0;
    # Make it so a user can only use the secure attention key which is required to access root securely.
    "kernel.sysrq" = 4;
    # Protect against SYN flooding.
    #"net.ipv4.tcp_syncookies" = 1;
    # Protect against time-wait assasination.
    #"net.ipv4.tcp_rfc1337" = 1;
    # Restrict abritrary use of ptrace to the CAP_SYS_PTRACE capability.
    "kernel.yama.ptrace_scope" = 2;
  };
}
