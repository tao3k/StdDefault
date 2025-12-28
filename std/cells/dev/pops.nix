# SPDX-FileCopyrightText: 2024 The omnibus Authors
#
# SPDX-License-Identifier: MIT
let
  inherit (inputs) nixpkgs;
  inherit (inputs.omnibus.inputs.flops.inputs) haumea;
  inputs' = (inputs.omnibus.pops.flake.setSystem nixpkgs.stdenv.hostPlatform.system).inputs;
in
{
  omnibus = {
    devshellProfiles = inputs.omnibus.pops.devshellProfiles.addLoadExtender {
      load.inputs.inputs = inputs';
    };
    configs = inputs.omnibus.pops.configs {
      inputs = {
        inputs = {
          inherit (inputs') nixfmt git-hooks;
          inherit (inputs) std;
          inherit nixpkgs;
        };
      };
    };
  };

  scripts = {
    inputs = {
      inputs = {
        customInputs = { };
      };
    };
  };
  configs = {
    transformer = [ haumea.lib.transformers.liftDefault ];
  };
}
