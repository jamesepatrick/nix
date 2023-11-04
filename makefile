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
	result="$$?"
	if  command -v notify-send  &> /dev/null  ; then
		notify-send -u low "완료 Switch Completed" "returned value $${result}"
	fi

dry:
	nixos-rebuild dry-build --flake .
	result="$$?"
	if  command -v notify-send  &> /dev/null  ; then
		notify-send -u low "완료 Dry Switch Completed" "returned value $${result}"
	fi

upgrade:
	sudo nix-channel --update
	nix flake update
	sudo nixos-rebuild --use-remote-sudo --upgrade-all switch  --flake .
	result="$$?"
	if  command -v notify-send  &> /dev/null  ; then
		notify-send -u low "완료 Upgrade Completed" "returned value $${result}"
	fi

clean:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +2
	sudo nix-collect-garbage --delete-older-than 5d
