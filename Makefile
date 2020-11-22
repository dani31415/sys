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
	@echo "  make dotnet   - installs dotnet (.net core)"
	@echo "  make netstat  - installs net-tools (netstat)"
	@echo "  make mongo-client  - installs mongo client (mongo)"

update:
	sudo apt-get update

#      _            _             
#   __| | ___   ___| | _____ _ __ 
#  / _` |/ _ \ / __| |/ / _ \ '__|
# | (_| | (_) | (__|   <  __/ |   
#  \__,_|\___/ \___|_|\_\___|_|   

/usr/bin/docker-compose:
	apt-get install docker-compose

/usr/bin/docker: update
	apt install apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
	apt update
	apt-cache policy docker-ce
	apt install docker-ce

docker-user:
	( cat /etc/group | grep docker | grep ${USER} ) || ( sudo usermod -aG docker ${USER} && newgrp docker )

docker: /usr/bin/docker docker-user /usr/bin/docker-compose

#                  _ 
#  _ __   ___   __| | ___ 
# | '_ \ / _ \ / _` |/ _ \
# | | | | (_) | (_| |  __/
# |_| |_|\___/ \__,_|\___|

/usr/bin/node:
	sudo curl -sL https://deb.nodesource.com/setup_12.x | bash -
	sudo apt install nodejs

~/.npm-global:
	mkdir -p ~/.npm-global
	echo "prefix=${HOME}/.npm-global" >> ~/.npmrc
	echo 'NPM_PACKAGES="${HOME}/.npm-global"' >> ~/.profile
	echo 'NODE_PATH="$$NPM_PACKAGES/lib/node_modules:$$NODE_PATH"' >> ~/.profile
	echo 'PATH="$$PATH:$$NPM_PACKAGES/bin"' >> ~/.profile

node: ~/.npm-global /usr/bin/node

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

#              _   
#    _ __   ___| |_ 
#   | '_ \ / _ \ __|
#  _| | | |  __/ |_ 
# (_)_| |_|\___|\__|
#

packages-microsoft-prod.deb:
	wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

/usr/bin/dotnet: packages-microsoft-prod.deb
	dpkg -i packages-microsoft-prod.deb
	apt-get update; \
  	 apt-get install -y apt-transport-https && \
  	 apt-get update && \
	 apt-get install -y dotnet-sdk-3.1
	rm -f packages-microsoft-prod.deb

dotnet: /usr/bin/dotnet

#             _       _        _   
#  _ __   ___| |_ ___| |_ __ _| |_ 
# | '_ \ / _ \ __/ __| __/ _` | __|
# | | | |  __/ |_\__ \ || (_| | |_ 
# |_| |_|\___|\__|___/\__\__,_|\__|
# 

/usr/bin/netstat:
	apt-get update
	apt-get install net-tools

netstat: /usr/bin/netstat

#
#  _ __ ___   ___  _ __   __ _  ___
# | '_ ` _ \ / _ \| '_ \ / _` |/ _ \
# | | | | | | (_) | | | | (_| | (_) |
# |_| |_| |_|\___/|_| |_|\__, |\___/
#                        |___/

/usr/bin/mongo:
	curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
	apt update
	apt install mongodb-org-shell

mongo-client: /usr/bin/mongo
