# SPDX-FileCopyrightText: 2023 The omnibus Authors
# SPDX-FileCopyrightText: 2024 The omnibus Authors
#
# SPDX-License-Identifier: MIT

{
  description = "OmnibusStd";

  inputs.omnibus.url = "github:tao3k/omnibus";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { omnibus, ... }@inputs:
    let
      inherit (omnibus.flake.inputs) std pogSrc flake-parts;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      omnibusStd =
        (omnibus.pops.std {
          inputs.inputs = {
            inherit std;
          };
        }).exports.default;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;
      imports = [ omnibusStd.flakeModule ];
      std.std = omnibusStd.mkDefaultStd {
        cellsFrom = ./std/cells;
        inputs = inputs // {
          inherit pogSrc;
        };
      };
      std.harvest = {
        devShells = [
          "dev"
          "shells"
        ];
        packages = [
          "dev"
          "packages"
        ];
      };
    };
}
