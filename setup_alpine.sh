#!/usr/bin/env sh
# so this might not work, but tracking my steps
# You should probably do this by hand.
# Also as root.

# Switch from stable to edge
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories
sed -i s/3.20/edge/g /etc/apk/repositories
apk update
apk upgrade

# Download and install packages
apk add java-jdk rlwrap bash git

## Clojure
curl -LO https://github.com/clojure/brew-install/releases/latest/download/posix-install.sh
chmod +x posix-install.sh
./posix-install.sh

## Trenchman
curl -LO https://github.com/athos/trenchman/releases/download/v0.4.0/trenchman_0.4.0_linux_amd64.tar.gz
tar xavf trenchman_0.4.0_linux_amd64.tar.gz
mv trench /usr/bin/trench

## Babashka (skipped)

# Create non-root user
useradd -m app
mkdir -m 700 -p /home/app/.ssh
cp /root/.ssh/authorized_keys /home/app/.ssh
chown -R app:app /home/app/.ssh
passwd app # interactive

# Firewall setup
## First, SSH
apk add nftables
nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }
nft add rule inet filter input ct state established,related accept
nft add rule inet filter input iif lo accept
nft add rule inet filter input tcp dport 22 accept
nft list ruleset > /etc/nftables.conf
rc-update add nftables
rc-service nftables save
## YOU MUST REBOOT HERE
#reboot
## Second, HTTP(S)
nft add rule inet filter input tcp dport 80 accept
nft add rule inet filter input tcp dport 443 accept
nft list ruleset > /etc/nftables.conf
rc-service nftables save

# Web setup
apk add doas rsync
apk add caddy caddy-openrc
cat > /etc/caddy/Caddyfile <<EOF
# todo
EOF

