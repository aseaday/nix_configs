{config, pkgs, ...}:
{
  require =
  [
    ./config-at-bootstrap.nix
    ../../editorIsVim.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../jenkins-master.nix
    ../../media-downloader.nix
    ../../networks/home.nix
    ../../vm-host.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
    ../../users/coconnor.nix
    ../../users/admin.nix
  ];

  boot.blacklistedKernelModules = [ "radeon" ];
  boot.kernelParams = [ "nomodeset" "video=vesa:off" "vga=normal" ];
  boot.vesa = false;

  fileSystems =
  [ 
    { mountPoint = "/mnt/non-admin-home/";
      device = "/dev/disk/by-label/home";
    }
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  networking.hostName = "agh"; # must be unique

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];

  services.xserver = 
  {
    enable = true;
    autorun = true;
    videoDrivers = [ "ati_unfree" ];
  };

  system.activationScripts.non-admin-home = ''
    [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
    mkdir -p /workspace/coconnor
    chown coconnor:users /workspace/coconnor
    # [ -L /workspace/coconnor] || ln -s /workspace/coconnor /home/coconnor/Development
  '';
}
