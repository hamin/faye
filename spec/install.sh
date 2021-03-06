# This script installs all the necessary software to run the Ruby and
# Node versions of Faye. Tested on Ubuntu 10.04 LTS 64-bit EC2 image:
# http://uec-images.ubuntu.com/releases/10.04/release/

FAYE_BRANCH=extract-engine
NODE_VERSION=0.4.7
REDIS_VERSION=2.2.7
RUBY_VERSION=1.9.2

sudo apt-get update
sudo apt-get install build-essential g++ git-core \
                     openssl libcurl4-openssl-dev libreadline-dev \
                     curl wget

bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
echo "source \"\$HOME/.rvm/scripts/rvm\"" | tee -a ~/.bashrc
source ~/.rvm/scripts/rvm
rvm install 1.9.2
rvm --default use 1.9.2

echo "install: --no-rdoc --no-ri
update: --no-rdoc --no-ri" | tee ~/.gemrc
gem install rake bundler

cd
git clone git://github.com/creationix/nvm.git ~/.nvm
. ~/.nvm/nvm.sh
echo ". ~/.nvm/nvm.sh" | tee -a ~/.bashrc
nvm install v$NODE_VERSION
nvm use v$NODE_VERSION
npm install redis

cd /usr/src
sudo wget http://redis.googlecode.com/files/redis-$REDIS_VERSION.tar.gz
sudo tar zxvf redis-$REDIS_VERSION.tar.gz
cd redis-$REDIS_VERSION
sudo make
sudo ln -s /usr/src/redis-$REDIS_VERSION/src/redis-server /usr/bin/redis-server
sudo ln -s /usr/src/redis-$REDIS_VERSION/src/redis-cli    /usr/bin/redis-cli

cd
git clone git://github.com/jcoglan/faye.git
cd faye
git checkout $FAYE_BRANCH
git submodule update --init --recursive
bundle install
cd vendor/js.class && jake
cd ../.. && jake
