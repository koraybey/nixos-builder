{
  pkgs,
  authorizedKeys,
  ...
}: {
  networking.hostName = "builder";

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.zip
    pkgs.unzip
    pkgs.wget
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  services.spice-vdagentd.enable = true;

  services.nebula.networks.mesh = {
    enable = true;
    lighthouses = ["192.168.100.100"];
    relays = ["192.168.100.100"];
    staticHostMap = {
      "192.168.100.100" = ["nebula.medkai.de:4242"];
    };
    cert = "/etc/nebula/builder.crt";
    key = "/etc/nebula/builder.key";
    ca = "/etc/nebula/ca.crt";
    firewall = {
      inbound = [
        {
          port = "any";
          proto = "any";
          host = "any";
        }
      ];
      outbound = [
        {
          port = "any";
          proto = "any";
          host = "any";
        }
      ];
    };
    settings = {
      punchy = {
        punch = true;
        respond = true;
      };
    };
  };

  documentation.nixos.enable = false;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";
  nix.settings.trusted-users = ["user" "@wheel"];
  nix.settings.system-features = ["kvm" "nixos-test"];

  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
      };
    };
    kernelModules = ["kvm-amd" "kvm-intel"];
  };
  virtualisation.libvirtd.enable = true;

  users.users = {
    root = {
      hashedPassword = "!"; # Disable root login
    };
    user = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = authorizedKeys;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
    };
  };
  networking.firewall.allowedTCPPorts = [22];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
