DEVICE_DIR = /Volumes/BOSS\ RC-500/ROLAND
EDITOR_DIR = ../../music/boss-rc500-editor/build/bin

.PHONY: help sync-from-device check-device

.DEFAULT_GOAL := help

snyc-from-device: check-device ## snyc data from the mounted device
	rsync -a $(DEVICE_DIR)/ data

edit: ## start the editor
	cp presets/* $(EDITOR_DIR)/resources/presets
	cd $(EDITOR_DIR) && ./BossRc500

check-device:
ifneq ("$(wildcard $(DEVICE_DIR))","")
	$(info Device is mounted)
else
    $(error Device is not mounted on ${DEVICE_DIR})
endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


