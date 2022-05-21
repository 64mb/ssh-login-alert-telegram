#!/usr/bin/env bash

add_profiled(){
cat <<EOF > /etc/profile.d/slat.sh
#!/usr/bin/env bash
# log connections
bash $SCRIPT_PATH
EOF
}

add_zsh () {
cat <<EOF >> /etc/zsh/zshrc

# log connections
bash $SCRIPT_PATH
EOF
}

SCRIPT_PATH="/opt/slat/main.sh"

echo "setup slat..."
add_profiled

echo "check if ZSH is installed..."

HAS_ZSH=$(grep -o -m 1 "zsh" /etc/shells)
if [ ! -z $HAS_ZSH ]; then
    echo "ZSH is installed, setup slat to zshrc"
    add_zsh
else
    echo "no ZSH detected"
fi

echo "setup slat success"
