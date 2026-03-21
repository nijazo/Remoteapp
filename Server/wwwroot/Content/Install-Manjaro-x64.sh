#!/bin/bash
HostName=
Organization=
GUID=$(cat /proc/sys/kernel/random/uuid)
UpdatePackagePath=""


Args=( "$@" )
ArgLength=${#Args[@]}

for (( i=0; i<${ArgLength}; i+=2 ));
do
    if [ "${Args[$i]}" = "--uninstall" ]; then
        systemctl stop remoteapp-agent
        rm -r -f /usr/local/bin/Remoteapp
        rm -f /etc/systemd/system/remoteapp-agent.service
        systemctl daemon-reload
        exit
    elif [ "${Args[$i]}" = "--path" ]; then
        UpdatePackagePath="${Args[$i+1}"
    fi
done

pacman -Sy
pacman -S dotnet-runtime-5.0 --noconfirm
pacman -S libx11 --noconfirm
pacman -S unzip --noconfirm
pacman -S libc6 --noconfirm
pacman -S libgdiplus --noconfirm
pacman -S libxtst --noconfirm
pacman -S xclip --noconfirm
pacman -S jq --noconfirm
pacman -S curl --noconfirm

if [ -f "/usr/local/bin/Remoteapp/ConnectionInfo.json" ]; then
    SavedGUID=`cat "/usr/local/bin/Remoteapp/ConnectionInfo.json" | jq -r '.DeviceID'`
    if [[ "$SavedGUID" != "null" && -n "$SavedGUID" ]]; then
        GUID="$SavedGUID"
    fi
fi

rm -r -f /usr/local/bin/Remoteapp
rm -f /etc/systemd/system/remoteapp-agent.service

mkdir -p /usr/local/bin/Remoteapp/
cd /usr/local/bin/Remoteapp/

if [ -z "$UpdatePackagePath" ]; then
    echo  "Downloading client..." >> /tmp/Remoteapp_Install.log
    wget $HostName/Content/Remoteapp-Linux.zip
else
    echo  "Copying install files..." >> /tmp/Remoteapp_Install.log
    cp "$UpdatePackagePath" /usr/local/bin/Remoteapp/Remoteapp-Linux.zip
    rm -f "$UpdatePackagePath"
fi

unzip ./Remoteapp-Linux.zip
rm -f ./Remoteapp-Linux.zip
chmod +x ./Remoteapp_Agent
chmod +x ./Desktop/Remoteapp_Desktop


connectionInfo="{
    \"DeviceID\":\"$GUID\", 
    \"Host\":\"$HostName\",
    \"OrganizationID\": \"$Organization\",
    \"ServerVerificationToken\":\"\"
}"

echo "$connectionInfo" > ./ConnectionInfo.json

curl --head $HostName/Content/Remoteapp-Linux.zip | grep -i "etag" | cut -d' ' -f 2 > ./etag.txt

echo Creating service... >> /tmp/Remoteapp_Install.log

serviceConfig="[Unit]
Description=The Remoteapp agent used for remote access.

[Service]
WorkingDirectory=/usr/local/bin/Remoteapp/
ExecStart=/usr/local/bin/Remoteapp/Remoteapp_Agent
Restart=always
StartLimitIntervalSec=0
RestartSec=10

[Install]
WantedBy=graphical.target"

echo "$serviceConfig" > /etc/systemd/system/remoteapp-agent.service

systemctl enable remoteapp-agent
systemctl restart remoteapp-agent

echo Install complete. >> /tmp/Remoteapp_Install.log