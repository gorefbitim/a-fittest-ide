# Fittest-IDE Makefile for *NIX system. 
home = ~/.ide
lp_path = $(home)/liquidprompt
zsh_path := $(shell which zsh)
users_shell := $(shell getent passwd ${LOGNAME} | cut -d: -f7)

clean:
	rm -rf $(home)

$(home):
	mkdir $(home)

$(lp_path): $(home)
	[ -d $(lp_path) ] || git clone git@github.com:nojhan/liquidprompt.git $(lp_path)

install: $(lp_path) pyenv nvim shell
	mkdir -p ~/.vim/autoload
	mkdir -p ~/.config/nvim
	mkdir -p ~/.tmux
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp config/init.vim ~/.config/nvim
	# cp config/liquidpromptrc ~/.config
	cp config/tmux.conf ~/.tmux.conf
	cp config/zshrc ~/.zshrc
	# TODO: add a `skins` fodler
	cp config/tmux_skin.conf ~/.tmux/skin.conf
	cp config/zsh_plugins.txt $(home)
	git config --global core.editor "nvim"

shell:
	if [ "$(users_shell)" != "$(zsh_path)" ]; then \
		echo "Changing default shell to zsh"; \
		chsh -s $(zsh_path); \
	fi

nvim:
	if [ ! -e /usr/bin/nvim ]; then \
		curl -fLo /tmp/nvim https://github.com/neovim/neovim/releases/download/v0.3.7/nvim.appimage; \
		chmod u+x /tmp/nvim; \
		sudo mv /tmp/nvim /usr/bin/nvim; \
	fi
	# TODO: create py3nvim and py2nvim virtual envs
	#       https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim
	python3 -m pip install --user --upgrade pynvim
	pip2 install --user --upgrade pynvim

pyenv:
	if [ ! -d ~/.pyenv ]; then curl https://pyenv.run | bash; fi
