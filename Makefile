MOUNT_POINT ?= /mnt/boss-rc500 
DEVICE_DIR = $(MOUNT_POINT)/ROLAND
EDITOR_DIR = ../../music/boss-rc500-editor/
.PHONY: help read-from-device check-device

.DEFAULT_GOAL := help

mount: ## mount the boss device
	sudo mount -o uid=1000,gid=1000 /dev/disk/by-label/BOSS\\x20RC-500 $(MOUNT_POINT)

umount: ## unmount the boss device
	sudo umount $(MOUNT_POINT)

read-from-device: check-device ## snyc data from the mounted device
	rsync -a $(DEVICE_DIR)/ data

write-config-to-device: check-device ## write the config to the device
	rsync -a data/DATA/ $(DEVICE_DIR)/DATA


edit: ## start the editor
	cp presets/* $(EDITOR_DIR)/resources/presets
	cd $(EDITOR_DIR) && ./build/bin/BossRc500

check-device:
	@if [ ! -d $(DEVICE_DIR) ]; then \
        echo "Device is not mounted on $(DEVICE_DIR)"; \
        exit 1; \
    fi

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


