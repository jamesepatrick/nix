# -*- mode: makefile-gmake; -*-
ifeq ($(shell $(MAKE) -v | grep GNU),)
  $(error I need gnumake not bsdmake)
endif
REQUIRED_V := 3.82
ifneq ($(REQUIRED_V),$(firstword $(sort $(MAKE_VERSION) $(REQUIRED_V))))
  $(error For .ONESHELL to work I need at least version $(REQUIRED_V))
endif

.ONESHELL:

switch:
	sudo nixos-rebuild --use-remote-sudo switch  --flake .

dry:
	nixos-rebuild dry-build --flake .

upgrade:
	sudo nix-channel --update
	nix flake update
	sudo nixos-rebuild --use-remote-sudo --upgrade-all switch  --flake .

clean:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +2
	sudo nix-collect-garbage --delete-older-than 5d
