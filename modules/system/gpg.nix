{ config, lib, pkgs, user, ... }:
let
  this = config.my.system.gpg;
  graphical = config.my.graphical;
in with lib; {
  options.my.system.gpg.enable = mkOption {
    default = true;
    type = with types; bool;
  };

  config = mkIf this.enable {

    # environment.shellInit = ''
    #   export GPG_TTY="$(tty)"
    #   gpg-connect-agent /bye
    #   export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    # '';
    programs = {
      gnupg.agent = {
        enable = true;

        pinentryPackage = if graphical.enable then
          pkgs.pinentry-gnome3
        else
          pkgs.pinentry-curses;
      };

    };

    home-manager.users."${user.name}" = {
      programs.gpg = {
        enable = true;
        settings = {
          # https://github.com/drduh/config/blob/master/gpg.conf
          # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
          # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
          personal-cipher-preferences = [ "AES256" "AES192" "AES" ];
          personal-digest-preferences = [ "SHA512" "SHA384" "SHA256" ];
          personal-compress-preferences =
            [ "ZLIB" "BZIP2" "ZIP" "Uncompressed" ];
          default-preference-list = [
            "SHA512"
            "SHA384"
            "SHA256"
            "AES256"
            "AES192"
            "AES"
            "ZLIB"
            "BZIP2"
            "ZIP"
            "Uncompressed"
          ];
          # SHA512 as digest to sign keys
          cert-digest-algo = "SHA512";
          # SHA512 as digest for symmetric ops
          s2k-digest-algo = "SHA512";
          # AES256 as cipher for symmetric ops
          s2k-cipher-algo = "AES256";
          # UTF-8 support for compatibility
          charset = "utf-8";
          # Show Unix timestamps
          fixed-list-mode = true;
          # No comments in signature
          no-comments = true;
          # No version in output
          no-emit-version = true;
          # Disable banner
          no-greeting = true;
          # Long hexidecimal key format
          keyid-format = "0xlong";
          # Display UID validity
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          # Display all keys and their fingerprints
          with-fingerprint = true;
          # Display key origins and updates
          #with-key-origin
          # Cross-certify subkeys are present and valid
          require-cross-certification = true;
          # Disable caching of passphrase for symmetrical ops
          no-symkey-cache = true;
          # Enable smartcard
          use-agent = true;
          # Disable recipient key ID in messages
          throw-keyids = true;
          # Default/trusted key ID to use (helpful with throw-keyids)
          #default-key 0xFF3E7D88647EBCDB
          #trusted-key 0xFF3E7D88647EBCDB
          # Group recipient keys (preferred ID last)
          #group keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB
          # Keyserver URL
          #keyserver hkps://keys.openpgp.org
          #keyserver hkps://keyserver.ubuntu.com:443
          #keyserver hkps://hkps.pool.sks-keyservers.net
          #keyserver hkps://pgp.ocf.berkeley.edu
          # Proxy to use for keyservers
          #keyserver-options http-proxy=http://127.0.0.1:8118
          #keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050
          # Verbose output
          #verbose
          # Show expired subkeys
          #list-options show-unusable-subkeys

        };
        #programs.gpg.homedir="${config.xdg.dataHome}/gnupg"
      };
      # https://github.com/drduh/YubiKey-Guide#using-keys
      #https://github.com/drduh/config/blob/master/gpg.conf
      #https://rycee.gitlab.io/home-manager/options.html#opt-programs.gpg.settings
      # home-manager.users."${user.name}".home.file.".gnupg/gpg-agent.config" = {
      #   text =
      #     if graphical.enable then
      #       "pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry"
      #     else
      #       "pinentry-program ${pkgs.pinentry-curses}/bin/pinentry";
      # };
    };
  };
}
