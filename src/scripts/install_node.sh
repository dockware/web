
mkdir "/var/www/.nvm"
export NVM_DIR="/var/www/.nvm"
# -----------------------------------------------------------------------------------------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# -----------------------------------------------------------------------------------------
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# -----------------------------------------------------------------------------------------
nvm install 20
nvm install 18
nvm install 16
nvm install 14
nvm install 12
# -----------------------------------------------------------------------------------------
# we have to install yarn in additional node versions
# otherwise it won't be found after a nvm switch
nvm use 20 && npm install -g yarn
nvm use 18 && npm install -g yarn
nvm use 16 && npm install -g yarn
nvm use 14 && npm install -g yarn
nvm use 12 && npm install -g yarn
# -----------------------------------------------------------------------------------------

nvm use 12
nvm alias default 12

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH


# -----------------------------------------------------------
# we have to reload the correct nvm version otherwise this would destroy it
export NVM_DIR="/var/www/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm use 12 \
# -----------------------------------------------------------

mkdir /var/www/.npm
npm config set cache /var/www/.npm
chown 33:33 /var/www/.npm
