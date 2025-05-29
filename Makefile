
PROJECT := whispering
SHELL := bash
PATH += $(HOME)/.local/bin
ACTIVATE := source .venv/bin/activate
PYTHONPATH := .

all: install out/conversation.txt
	ls -l

out/conversation.mp3: $(HOME)/Downloads/conversation.m4a
	ffmpeg -i $< $@

%.txt: %.mp3
	ls -l $<
	$(ACTIVATE) && whisper --language en $<

.venv:
	which uv || curl -LsSf https://astral.sh/uv/install.sh | sh
	test -r pyproject.toml || uv init
	unset VIRTUAL_ENV && uv venv --python=python3.12

install: .venv
	sort -o requirements.txt{,}
	$(ACTIVATE) && uv add --upgrade -r requirements.txt
	$(ACTIVATE) && pre-commit install

CACHES := .mypy_cache/ .pyre/ .pytype/ .ruff_cache/
clean-caches:
	rm -rf $(CACHES)
clean: clean-caches
	rm -rf .venv/

.PHONY: all install .venv clean clean-caches
