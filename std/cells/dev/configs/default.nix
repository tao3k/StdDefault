# SPDX-FileCopyrightText: 2023 The omnibus Authors
# SPDX-FileCopyrightText: 2024 The omnibus Authors
#
# SPDX-License-Identifier: MIT

{ inputs, cell }:
with inputs.std.inputs.dmerge;
let
  inherit (cell.pops.omnibus.configs.exports.default) treefmt lefthook conform;
  cfg = {
    inherit (cell.pops.omnibus.configs.exports.stdNixago) treefmt lefthook conform;
  };
in
{
  lefthook = {
    default = cfg.lefthook.default lefthook.just;
  };
  treefmt = {
    default = (cfg.treefmt.default treefmt.nvfetcher) {
      data.global = {
        excludes = append [ ];
      };
    };
  };
  conform = rec {
    default = cfg.conform.default custom;
    custom = {
      data = {
        commit.conventional.scopes = append [
          "cells"
          "cells/*"
          ".*."
        ];
      };
    };
  };
}
