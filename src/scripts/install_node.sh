
DEFAULT_NODE_VERSION=20


echo "source /var/www/.nvm/nvm.sh" >> /var/www/.bashrc
chown 33:33 /var/www/.bashrc
echo "export BASH_ENV=${BASH_ENV}" >> /etc/profile

mkdir "/var/www/.nvm"


# -----------------------------------------------------------------------------------------
# INSTALL NVM
export NVM_DIR="/var/www/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# -----------------------------------------------------------------------------------------
# INSTALL NODE VERSIONS
nvm install 20
nvm install 18


# "sudo node -v" also needs to work, so to a symlink with sudo
sudo ln -s "$(which node)" "/usr/local/bin/node"
sudo ln -s "$(which npm)" "/usr/local/bin/npm"


# -----------------------------------------------------------------------------------------
# we have to install yarn in additional node versions
# otherwise it won't be found after a nvm switch
nvm use 20 && npm install -g yarn
nvm use 18 && npm install -g yarn


# -----------------------------------------------------------------------------------------
# SWITCH TO DEFAULT NODE VERSION
nvm use $DEFAULT_NODE_VERSION
nvm alias default $DEFAULT_NODE_VERSION
# we have to reload the correct nvm version otherwise this would destroy it
#export NVM_DIR="/var/www/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm use $DEFAULT_NODE_VERSION



# -----------------------------------------------------------
mkdir /var/www/.npm
npm config set cache /var/www/.npm
chown 33:33 /var/www/.npm

chown 33:33 /var/www/.nvm -R

