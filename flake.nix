{
  inputs = {
    nix.url = "github:nixos/nix/2.28.0";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = {nixpkgs, ...}: let
    authorizedKeys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOj9UX5+Y2C0JUXDhWYb2P2cPfCP5e2MFjZzxj7GjCp admin@med-nixos-rpi''
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBbC6H4YbObdwyhB62DCtsaCtNyXaj8Ou4Xf4y8VHRs5YJrJ/jy9TJqT7ibWKpLcR/HNq6zr9fQp3VkFV3r6/o70OL0Npb9mshbMFX7SxqlfPSpkOnt0kka0V8nNCw5vrTup9M9isxLnQUW0vsNWYftXkYOZR8mvv/OM3EAqk2PkPAJxs3IYqLfH52iCLAinLYRrnjaXIw9UWzqLNLHSAk6rHnTvlWWfdmltNt5yFyLN6lCIoIRSPvjJAJAzEYTHn0gf4r19raLU1BoUFsoB/RfO+4QhU6jhJGwRdbj7kytmkaLBrc3RPqGgr2JNdwNp6A4SQh2bXeg1EqNPLD4aBD4kZ1i6YuuIZ4SA4DbcOCgXrfIzeB0AavaRXjaKnPVDjkVwEh8cUXOCJLXZIV2eOOA6L4t52R25OQKMadbEy41tFqZpDZ7arWkBQRTn1jybpvjiT+Urt8Bbqffvc8bATMn85UFJZ3EDWpI0eh0ottRyxPNfnXRWozR4ohPCEXXWVOnqOgWc2kLvzAw3zRSB2AgYVLiKy+DIBwskNcKRk5nYp8brQKO/aA1nD15F35Wo3GE6mSlGfIB5t/P1SIRbe7DZ9H7pdCK1HI4cdyPGu+WJiG43e2WD8+5lUSZ2DdGCurZLCRGQq/36MYr2thOBJFq4K1YSI7sc1foJq0c36PTw== hello@koray.onl''
    ];
  in {
    nixosConfigurations = {
      builder-x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          authorizedKeys = authorizedKeys;
        };
        modules = [
          ./systems/utm/builder/config.nix
        ];
      };
      builder-aarch64 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          authorizedKeys = authorizedKeys;
        };
        modules = [
          ./systems/utm/builder/config.nix
        ];
      };
    };
  };
}
