eval "$(direnv hook zsh)"
eval "$(service-instance-migrator completion zsh)"
eval "$(app-migrator completion zsh)"
source <(stern --completion=zsh)
source <(kubectl completion zsh)
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
