#!/bin/bash

set -x

FORGE_VERSION=1.20.1-47.3.11
MC_VERSION=1.20.1
cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f 'Server-Files-1.0.3.zip' ]]; then
	rm -fr config defaultconfigs kubejs mods packmenu Simple.zip forge*
	curl -Lo 'Server-Files-1.0.3.zip' 'https://edge.forgecdn.net/files/6045/528/Server-Files-1.0.3.zip' || exit 9
	unzip -u -o 'Server-Files-1.0.3.zip' -d /data
	DIR_TEST=$(find . -type d -maxdepth 1 | tail -1 | sed 's/^.\{2\}//g')
	if [[ $(find . -type d -maxdepth 1 | wc -l) -gt 1 ]]; then
		cd "${DIR_TEST}"
		mv -f * /data
		cd /data
		rm -fr "$DIR_TEST"
	fi
        curl -Lo mohist-${FORGE_VERSION}-installer.jar https://mohistmc.com/api/v2/projects/mohist/${MC_VERSION}/builds/latest/download
 	echo "java -jar mohist-${FORGE_VERSION}-installer.jar" > run.sh


 
 fi

if [[ -n "$JVM_OPTS" ]]; then
	sed -i '/-Xm[s,x]/d' user_jvm_args.txt
	for j in ${JVM_OPTS}; do sed -i '$a\'$j'' user_jvm_args.txt; done
fi
if [[ -n "$MOTD" ]]; then
    sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties
chmod 755 run.sh

./run.sh
