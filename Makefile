DEVICE_DIR = /Volumes/BOSS\ RC-500/ROLAND
EDITOR_DIR = ../../music/boss-rc500-editor/
.PHONY: help read-from-device check-device

.DEFAULT_GOAL := help

read-from-device: check-device ## snyc data from the mounted device
	rsync -a $(DEVICE_DIR)/ data

write-config-to-device: check-device ## write the config to the device
	rsync -a data/DATA/ $(DEVICE_DIR)/DATA


edit: ## start the editor
	cp presets/* $(EDITOR_DIR)/resources/presets
	cd $(EDITOR_DIR) && ./build/bin/BossRc500

check-device:
	@if [ ! -d "$(DEVICE_DIR)" ]; then \
        echo "Device is not mounted on $(DIR1)"; \
        exit 1; \
    fi

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


