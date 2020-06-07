CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

WGET = wget -c --no-check-certificate



.PHONY: all
all: ./$(MODULE)

SRC  = src/$(MODULE).nim
SRC += src/$(MODULE)pkg/submodule.nim

./$(MODULE): $(MODULE).nimble $(SRC)
	nimble build



.PHONY: install
install: debian
.PHONY: debian
debian:
	sudo apt update
	sudo apt install -u `cat apt.txt`



.PHONY: master shadow release zip

MERGE  = Makefile README.md .gitignore .vscode apt.txt requirements.txt
MERGE += src tests $(MODULE).nimble

master:
	git checkout $@
	git checkout shadow -- $(MERGE)

shadow:
	git checkout $@

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow
