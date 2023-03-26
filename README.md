# Whereisdi - Domain Invasion Tracker Addon for Windower

**Author:**  Kosumi (Asura)<br>
**Version:**  1.1<br>
**Date:** March 26, 2023<br>

## Description

Windower addon for getting the current location of the Domain Invasion. The data is crowd sourced from all users of the addon. By default, if it sees the current location of Domain Invasion it will upload it to help other users.

## Installation

* Download the latest version: https://github.com/aphung/whereisdi/releases/latest/
* Copy whereisdi folder into the addons folder in your Windower install directory.
* Manually load the addon using `//lua l whereisdi` or add `lua l whereisdi` in your init.txt file in the scripts/ folder.

## Usage

* Type `//whereisdi` or `//di` to get the current location for your server.
* You may receive an error is either the inforatmion server is down or there is not enough data received from other users to provide a reliable location.

## Settings

**Abbreviation:** `//di`

## Commands
1. send: toggles opting in/out of sending Domain Inavasion location data. This setting is saved per character.
2. mireu: get the last known Mireu completed time.
3. help: displays help.
4. show: show the DI information in a gui box
5. hide: hide the DI information gui box

### Example Commands
```
//di            *Get latest available DI location*
//di send       *Toggle providing Unity data to whereisdi.com*
//di mireu      *Get the last known Mireu defeated time*
//di show       *Show a box displaying DI location*
//di hide       *Hide the DI location box*
```

## Privacy

For the purpose of tracking the Domain Invasion location for each server, this addon sends and receives data to whereisdi which is owned and maintained by the author of this addon. 

Data is only sent to whereisdi when a unity message is received that corresponds to one of the Unity leaders messages about Domain Invasion. Player names are obfuscated (hashed) and cannot be read by the Author.

You can opt out of providing data to whereisdi.com by entering the command `//di send`.

## Credits

Thanks to the following libraries:

sha2.lua - https://github.com/Egor-Skriptunoff/pure_lua_SHA <br>
json.lua - https://gist.github.com/tylerneylon/59f4bcf316be525b30ab
