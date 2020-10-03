USER=${shell whoami}

#  _          _       
# | |__   ___| |_ __  
# | '_ \ / _ \ | '_ \ 
# | | | |  __/ | |_) |
# |_| |_|\___|_| .__/ 
#              |_|    

help:
	@echo Usage:
	@echo "  make docker   - installs docker"
	@echo "  make node     - installs node & npm"
	@echo "  make rsa-key  - generates ssh private key"
	@echo "  make figlet   - installs figlet (big ASCII text)"

update:
	sudo apt-get update

#      _            _             
#   __| | ___   ___| | _____ _ __ 
#  / _` |/ _ \ / __| |/ / _ \ '__|
# | (_| | (_) | (__|   <  __/ |   
#  \__,_|\___/ \___|_|\_\___|_|   

docker-user:
	( cat /etc/group | grep docker | grep ${USER} ) || ( sudo usermod -aG docker ${USER} && newgrp docker )

docker: docker-user /usr/bin/docker

#                  _ 
#  _ __   ___   __| | ___ 
# | '_ \ / _ \ / _` |/ _ \
# | | | | (_) | (_| |  __/
# |_| |_|\___/ \__,_|\___|

/usr/bin/node:
	sudo curl -sL https://deb.nodesource.com/setup_12.x | bash -
	sudo apt install nodejs

~/.npm-global2:
	mkdir -p ~/.npm-global
	echo "prefix=${HOME}/.npm-global" >> ~/.npmrc
	echo 'NPM_PACKAGES="${HOME}/.npm-packages"' >> ~/.profile
	echo 'NODE_PATH="$$NPM_PACKAGES/lib/node_modules:$$NODE_PATH"' >> ~/.profile
	echo 'PATH=$$PATH:${HOME}/.npm-packages/bin' >> ~/.profile

node: ~/.npm-global2 /usr/bin/node

#                   _              
#  _ __ ___  __ _  | | _____ _   _ 
# | '__/ __|/ _` | | |/ / _ \ | | |
# | |  \__ \ (_| | |   <  __/ |_| |
# |_|  |___/\__,_| |_|\_\___|\__, |
#                            |___/ 

~/.ssh/id_rsa: ~/.ssh
	ssh-keygen -t rsa

rsa-key: ~/.ssh/id_rsa

#   __ _       _      _   
#  / _(_) __ _| | ___| |_ 
# | |_| |/ _` | |/ _ \ __|
# |  _| | (_| | |  __/ |_ 
# |_| |_|\__, |_|\___|\__|
#        |___/            

/usr/bin/figlet:
	sudo apt install figlet

figlet: /usr/bin/figlet
