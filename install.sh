#!/usr/bin/env bash

NVM=". $HOME/.nvm/nvm.sh && nvm"

check_json_processor() {
    local component=jq
    if ! $component --version >/dev/null 2>&1; then
        echo "This script uses $component, and it isn't running. Please install $component an try again."
        echo "https://stedolan.github.io/jq/download/"
        echo "---"
        echo ""
        exit 1
    fi
}

get_latest_nvm_version() {
    echo $(curl -s 'https://api.github.com/repos/nvm-sh/nvm/releases/latest' | jq -r '.name')
}

check_nvm() {
    if ! eval "$NVM ls" >/dev/null 2>&1; then
        echo "This script uses NVM, and it isn't running."
        echo "Try to install manually:"
        echo "$ curl -o- ""https://raw.githubusercontent.com/nvm-sh/nvm/$(get_latest_nvm_version)/install.sh"" | bash"
        echo "---"
        echo ""
        exit 1
    fi
}

check_json_processor

echo "Nodejs environment installer"
echo "This script will install nodejs lts into your OS using the latest version of nvm."

echo ""
echo "1. Installing/updating NVM to version $(get_latest_nvm_version)"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$(get_latest_nvm_version)/install.sh" | bash

echo ""
echo "2. Refresh bashrc"
. $HOME/.bashrc

echo ""
echo "3. Installing nodejs lts"
check_nvm
eval "$NVM install --lts"

echo ""
echo "4. Installing YARN"
corepack enable

echo ""
echo "Done! Installed environment:"
echo "nodejs $(node --version), npm $(npm --version), nvm $(eval $NVM -v), yarn $(yarn --version)"
echo "---"
echo ""