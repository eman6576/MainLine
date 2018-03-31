## Makefile
# Commands for setup and running MainLine

TOOL_NAME = mainline
VERSION = 1.0.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
CURRENT_PATH = $(PWD)
REPO = https://github.com/eman6576/$(TOOL_NAME)
RELEASE_TAR = $(REPO)/archive/$(VERSION).tar.gz
SHA = $(shell curl -L -s $(RELEASE_TAR) | shasum -a 256 | sed 's/ .*//')

.PHONY: help

# Target Rules
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

project:
	swift package generate-xcodeproj

open_xcodeproj:
	open MainLine.xcodeproj

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)

uninstall:
	rm -f $(INSTALL_PATH)

install_bin:
	mkdir -p $(PREFIX)/bin
	mv .build/release/MainLine .build/release/$(INSTALL_NAME)
	install .build/release/$(INSTALL_NAME) $(PREFIX)/bin

format_code:
	swiftformat Tests --stripunusedargs closure-only --header strip
	swiftformat Sources --stripunusedargs closure-only --header strip

update_brew:
	sed -i '' 's|\(url ".*/archive/\)\(.*\)\(.tar\)|\1$(VERSION)\3|' Formula/mainline.rb
	sed -i '' 's|\(sha256 "\)\(.*\)\("\)|\1$(SHA)\3|' Formula/mainline.rb

	git add .
	git commit -m "Update brew to $(VERSION)"

release: format_code
	sed -i '' 's|\(static let version = "\)\(.*\)\("\)|\1$(VERSION)\3|' Sources/MintKit/Mint.swift

	git add .
	git commit -m "Update to $(VERSION)"
	git tag $(VERSION)

clean: ## Cleans the project
	swift package clean

test: 
	swift test

test_linux: ## Complies and run unit tests in Linux using Docker
	docker-compose up

lint:
	swiftlint

# Target Dependencies
all: build project open_xcodeproj ## Complies, generates a new xcodeproj file and opens the project in Xcode

test_local: build test lint ## Complies, run unit tests and lint locally