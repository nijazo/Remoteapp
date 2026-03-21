#!/bin/bash

echo "Entered main script."

ServerDir=/var/www/remoteapp
RemoteappData=/remoteapp-data

AppSettingsVolume=/remoteapp-data/appsettings.json
AppSettingsWww=/var/www/remoteapp/appsettings.json

if [ ! -f "$AppSettingsVolume" ]; then
	echo "Copying appsettings.json to volume."
	cp "$AppSettingsWww" "$AppSettingsVolume"
fi

if [ -f "$AppSettingsWww" ]; then
	rm "$AppSettingsWww"
fi

ln -s "$AppSettingsVolume" "$AppSettingsWww"

echo "Starting Remoteapp server."
exec /usr/bin/dotnet /var/www/remoteapp/Remoteapp_Server.dll