{config, pkgs, ...}:

{
  nixpkgs.config.chromium.channel = "dev";

  require = 
  [
    ./user-coconnor.nix
    ./editorIsVim.nix
    ./java-dev.nix
    ./scala-dev.nix
    ./haskell-dev.nix
    ./kde4.nix
    ./vm-host.nix
  ];

  nix.maxJobs = 4;

  boot.kernelPackages = pkgs.linuxPackages_3_2;

  boot.kernelModules =
  [
    "acpi-cpufreq"
    "kvm-intel"
  ];
  boot.extraModulePackages = [ ];

  boot.initrd.kernelModules = 
  [
    "ext4" 
    "usb_storage"
    "uhci_hcd"
    "ehci_hcd"
    "ata_piix"
    "firewire_ohci"
    "usbhid" 
  ];

  networking = 
  {
    hostName = "nixpad"; # Define your hostname.
    interfaceMonitor.enable = true; # Watch for plugged cable.
  };
      
	# Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.
  fileSystems =
  [ { mountPoint = "/";
      device = "/dev/disk/by-label/root";
    }
  ];

  # List swap partitions activated at boot time.
  swapDevices =
  [ { device = "/dev/disk/by-label/swap"; }
  ];

  # Select internationalisation properties.
  i18n =
  {
    consoleFont = "lat9w-16";
    consoleKeyMap = "emacs2";
    defaultLocale = "en_US.UTF-8";
  };


  services.dbus.enable = true;
  services.udisks.enable = true;
  services.upower.enable = true;
  services.acpid.enable = true;

  # Add an OpenSSH daemon.
  services.openssh.enable = true;

  # XXX: Disables both X11 forwarding for the client as well as server.
  # I only want to disable X11 forwarding for ssh client
  services.openssh.forwardX11 = false;

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;

  # X11 config
  # starts 
  services.xserver = 
  {
    enable = true;
    autorun = true;
    videoDrivers = [ "nvidia" "vesa" ];
    layout = "us";
    synaptics =
    {
      enable = true;
      twoFingerScroll = true;
      tapButtons = false;

    };
  };

  services.dbus.packages =
  [
    pkgs.gnome.GConf
  ];

  environment.x11Packages = 
  [
    # pkgs.abiword
    # pkgs.chromium
    pkgs.desktop_file_utils
    pkgs.evince
    pkgs.firefoxWrapper
    pkgs.flashplayer
    pkgs.gnome.GConf
    pkgs.gnome.gtk
    pkgs.gnome.intltool
    pkgs.gnome.gtk_doc
    pkgs.gnome.gnomeicontheme
    pkgs.gnome.pango
    pkgs.gnome.vte
    pkgs.gtkLibs.gtk # To get GTK+'s themes.
    pkgs.shared_mime_info
    pkgs.shared_desktop_ontologies
    # pkgs.swt
    pkgs.xcompmgr
    pkgs.xlibs.fontutil
    pkgs.xlibs.kbproto
    pkgs.xlibs.libICE
    pkgs.xlibs.libXt
    pkgs.xlibs.libXtst
    pkgs.xlibs.libXaw
    pkgs.xlibs.xproto
    pkgs.xlibs.xinput
    pkgs.fontconfig
    pkgs.hicolor_icon_theme
    pkgs.xclip
    pkgs.xdg_utils
    pkgs.rxvt_unicode
  ];

  environment.pathsToLink =
  [ 
    "/share"
    "/etc/gconf"
  ];

  environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
  '';

  services.syslogd.extraConfig = ''
      user.* /var/log/user
  '';

  services.xfs.enable = false;
  fonts =
  {
    enableFontDir = true;
    extraFonts = 
    [
      pkgs.andagii
      pkgs.anonymousPro
      pkgs.arkpandora_ttf
      pkgs.bakoma_ttf
      pkgs.corefonts
      pkgs.cm_unicode
      pkgs.junicode
      pkgs.ucsFonts
      pkgs.unifont
      pkgs.vistafonts
    ];
  };

  environment.systemPackages =
  [
    pkgs.stdenv
    pkgs.atk
    pkgs.ant
    pkgs.autoconf
    pkgs.automake
    pkgs.bashInteractive
    pkgs.cairo
    pkgs.gdb
    pkgs.gdk_pixbuf
    pkgs.glibcLocales
    pkgs.screen
    pkgs.utillinuxCurses
    pkgs.gitSVN
    pkgs.acpi
    pkgs.pulseaudio
    pkgs.ruby19
    pkgs.rubySqlite3
    pkgs.gcc
    pkgs.coq
    pkgs.oprofile
    pkgs.ffmpeg
    pkgs.freetype
    pkgs.fuse
    pkgs.gettext
    pkgs.glib
    pkgs.gnumake
    pkgs.gnupg
    pkgs.inconsolata
    pkgs.isabelle
    pkgs.maven3
    pkgs.jdk
    pkgs.jre
    pkgs.nginx
    pkgs.ocaml
    pkgs.perlXMLParser
    pkgs.python
    pkgs.emacs23
    pkgs.qemu
    pkgs.vala
    pkgs.vpnc
    pkgs.xterm
  ];

  time.timeZone = "America/Los_Angeles";

  security.sudo.enable = true;
  security.sudo.configFile = ''
        Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
        Defaults:root,%wheel env_keep+=NIX_PATH
        Defaults:root,%wheel env_keep+=TERMINFO_DIRS

        root        ALL=(ALL) SETENV: ALL
        %wheel      ALL=(ALL) NOPASSWD: SETENV: ALL
'';
}

