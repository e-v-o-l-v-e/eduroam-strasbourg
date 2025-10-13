{
  description = "Install eduroam Strasbourg on NixOS systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Eduroam Python script for the University of Strasbourg
    eduroam-university-strasbourg = {
      url = "https://cat.eduroam.org/user/API.php?action=downloadInstaller&lang=en&profile=328&device=linux&generatedfor=user&openroaming=0";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs:
    with inputs; let
      supportedSystems = ["aarch64-linux" "x86_64-linux"];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [];
        });
    in {
      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
      packages = forAllSystems (system: let
        pkgs = nixpkgsFor.${system};
        python-with-dbus = pkgs.python3.withPackages (p: with p; [dbus-python]);
      in {
        default =
          pkgs.writeShellScriptBin "install-eduroam-university-strasbourg"
          "${python-with-dbus}/bin/python3 ${eduroam-university-strasbourg}";
      });
    };
}
