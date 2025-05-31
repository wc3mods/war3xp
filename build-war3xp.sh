#!/bin/bash
set -e

cd /opt

# Remove all files in the directory in case there was a previous amxmodx extracted here
rm -rf *
wget -q "${AMXX_BASE_URL}/amxmodx-${AMXX_VERSION}-base-linux.tar.gz"
tar -xzf "amxmodx-${AMXX_VERSION}-base-linux.tar.gz" > /dev/null 2>&1

# Move to working directory
cd /opt/addons/amxmodx/scripting

cp -R /workspace/plugin_src/* .

# Build the plugin
./amxxpc warcraft3.sma
mv /opt/addons/amxmodx/scripting/warcraft3.amxx /workspace/build_tmp/addons/amxmodx/plugins/warcraft3.amxx
