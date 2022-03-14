
#!/bin/bash
# Téléchargement des binaires
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && sudo mv kubectl /usr/local/bin/

#  bash autocmplétion
sudo apt install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo 'source <(kubectl completion bash)' >>~/.bashrc

####====================================
###### windows
## Sur le site 
https://storage.googleapis.com/kubernetes-release/release/v1.19.2/bin/windows/amd64/kubectl.exe

### Installation via CLI
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.2/bin/windows/amd64/kubectl.exe

### Une fois téléchargé ajouter le chemin dans les variables d'en
