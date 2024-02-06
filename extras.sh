#!/usr/bin/env bash

# install direnv
curl -sfL https://direnv.net/install.sh | sudo bash

# install liquidprompt the new way
# https://liquidprompt.readthedocs.io/en/stable/install.html
git clone --branch stable https://github.com/nojhan/liquidprompt.git ~/liquidprompt

# Only load Liquidprompt in interactive shells, not from a script or from scp
echo "[[ $- = *i* ]] && source ~/liquidprompt/liquidprompt" ~/.bash_linux
