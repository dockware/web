
echo "source /var/www/.nvm/nvm.sh" >> /var/www/.bashrc
# -------------------------------------------------
chown 33:33 /var/www/.bashrc
# -------------------------------------------------
echo "export BASH_ENV=${BASH_ENV}" >> /etc/profile


mkdir "/var/www/.nvm"
export NVM_DIR="/var/www/.nvm"
# -----------------------------------------------------------------------------------------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# -----------------------------------------------------------------------------------------
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# -----------------------------------------------------------------------------------------
nvm install 20
nvm install 18
# -----------------------------------------------------------------------------------------
# we have to install yarn in additional node versions
# otherwise it won't be found after a nvm switch
nvm use 20 && npm install -g yarn
nvm use 18 && npm install -g yarn
# -----------------------------------------------------------------------------------------
nvm use 20
nvm alias default 20
# ----------------------------------------------------------------------------------------- \

# sudo node -v should work
sudo ln -s "$(which node)" "/usr/local/bin/node"
sudo ln -s "$(which npm)" "/usr/local/bin/npm"


# -----------------------------------------------------------
# we have to reload the correct nvm version otherwise this would destroy it
export NVM_DIR="/var/www/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm use 20
# -----------------------------------------------------------
mkdir /var/www/.npm
npm config set cache /var/www/.npm
chown 33:33 /var/www/.npm

chown 33:33 /var/www/.nvm -R

