all: update

update:
	chezmoi apply

diff:
	chezmoi diff
