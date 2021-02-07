{ config, lib, ... }:

with lib;

let cfg = config.sops;
in {
  options.sops = {
    defaultSopsFile = mkOption {
      type = types.either types.str types.path;
      description = ''
        Default sops file used for all secrets.
      '';
    };

    defaultSopsFormat = mkOption {
      type = types.str;
      default = "yaml";
      description = ''
        Default sops format used for all secrets.
      '';
    };

    validateSopsFiles = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Check all sops files at evaluation time.
        This requires sops files to be added to the nix store.
      '';
    };

    gnupgHome = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "~/.gnupg";
      description = ''
        Path to gnupg database directory containing the key for decrypting sops file.
      '';
    };

    sshKeyPaths = mkOption {
      type = types.listOf types.path;
      default = if config.programs.ssh.enable then
        builtins.filter (e: e != null)
        (mapAttrsToList (_: server: server.identityFile or null)
          programs.ssh.matchBlocks)
      else
        [ ];
      description = ''
        Path to ssh keys added as GPG keys during sops description.
        This option must be explicitly unset if <literal>config.programs.ssh.enable = true</literal>.
      '';
    };
  };
}
