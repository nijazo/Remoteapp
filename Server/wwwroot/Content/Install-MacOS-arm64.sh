#!/bin/bash

HostName=
Organization=
GUID="$(uuidgen)"
UpdatePackagePath=""

Args=( "$@" )
ArgLength=${#Args[@]}

for (( i=0; i<${ArgLength}; i+=2 ));
do
    if [ "${Args[$i]}" = "--uninstall" ]; then
        launchctl unload -w /Library/LaunchDaemons/remoteapp-agent.plist
        rm -r -f /usr/local/bin/Remoteapp/
        rm -f /Library/LaunchDaemons/remoteapp-agent.plist
        exit
    elif [ "${Args[$i]}" = "--path" ]; then
        UpdatePackagePath="${Args[$i+1]}"
    fi
done


# Install Homebrew
su - $SUDO_USER -c '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
su - $SUDO_USER -c "brew update"

# Install .NET Runtime
su - $SUDO_USER -c "brew install --cask dotnet"

# Install dependency for System.Drawing.Common
su - $SUDO_USER -c "brew install mono-libgdiplus"

# Install other dependencies
su - $SUDO_USER -c "brew install curl"
su - $SUDO_USER -c "brew install jq"


if [ -f "/usr/local/bin/Remoteapp/ConnectionInfo.json" ]; then
    SavedGUID=`cat "/usr/local/bin/Remoteapp/ConnectionInfo.json" | jq -r '.DeviceID'`
    if [[ "$SavedGUID" != "null" && -n "$SavedGUID" ]]; then
        GUID="$SavedGUID"
    fi
fi

rm -r -f /Applications/Remoteapp
rm -f /Library/LaunchDaemons/remoteapp-agent.plist

mkdir -p /usr/local/bin/Remoteapp/
chmod -R 755 /usr/local/bin/Remoteapp/
cd /usr/local/bin/Remoteapp/

if [ -z "$UpdatePackagePath" ]; then
    echo  "Downloading client..." >> /tmp/Remoteapp_Install.log
    curl $HostName/Content/Remoteapp-MacOS-arm64.zip --output /usr/local/bin/Remoteapp/Remoteapp-MacOS-arm64.zip
else
    echo  "Copying install files..." >> /tmp/Remoteapp_Install.log
    cp "$UpdatePackagePath" /usr/local/bin/Remoteapp/Remoteapp-MacOS-arm64.zip
    rm -f "$UpdatePackagePath"
fi

unzip -o ./Remoteapp-MacOS-arm64.zip
rm -f ./Remoteapp-MacOS-arm64.zip


connectionInfo="{
    \"DeviceID\":\"$GUID\", 
    \"Host\":\"$HostName\",
    \"OrganizationID\": \"$Organization\",
    \"ServerVerificationToken\":\"\"
}"

echo "$connectionInfo" > ./ConnectionInfo.json

curl --head $HostName/Content/Remoteapp-MacOS-arm64.zip | grep -i "etag" | cut -d' ' -f 2 > ./etag.txt


plistFile="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.translucency.remoteapp-agent</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/dotnet</string>
        <string>/usr/local/bin/Remoteapp/Remoteapp_Agent.dll</string>
    </array>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>"
echo "$plistFile" > "/Library/LaunchDaemons/remoteapp-agent.plist"

launchctl load -w /Library/LaunchDaemons/remoteapp-agent.plist
launchctl kickstart -k system/com.translucency.remoteapp-agent