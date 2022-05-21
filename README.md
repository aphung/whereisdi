# Whereisdi

**Author:**  Kosumi (Asura)<br>
**Version:**  1.0.0<br>
**Date:** May 5, 2022<br>

## Description

Windower addon for getting the current location of the Domain Invasion. The data is crowd sourced from all users of the addon. By default, if it sees the current location of Domain Invasion it will upload it to help other users.

## Installation

* Download the latest version: https://github.com/aphung/whereisdi/releases
* Copy whereisdi folder into the addons folder in your Windower install directory.
* Manually load the addon using `//lua l whereisdi` or add `lua l whereisdi` in your init.txt file in the scripts/ folder.

## Usage

* Type `//whereisdi` or `//di` to get the current location for your sevewr.
* You may receive an error is either the inforatmion server is down or there is not enough data received from other users to provide a reliable location.

## Settings

* Most settings can be modified via commands, but you can edit the settings.xml directly for a few uncommon settings.

**Abbreviation:** `//di`

## Commands
1. send: toggles opting in/out of sending Domain Inavasion location data. This setting is saved per character.
2. help: displays help.
	
### Example Commands
```
//di
//di send
```
## Whereisdi on Asura

For the time being, the player character Whereisdi will continue to function and will continue to provide Domain Invasion location to players of the Asura server directly by /tell. This addon is not a requirement to continue using Whereisdi by tells. However, this addon should continue to work even when the character Whereisdi is offline.

## Privacy

For the purpose of tracking the Domain Invasion location for each server, this addon sends and receives data to whereisdi which is owned and maintained by the author of this addon. **No personal data is sent.** Data is only sent to whereisdi when a unity message is received that corresponds to one of the Unity leaders messages about Domain Invasion. You can opt out of providing data to whereisdi.com by entering the command `//di send`.

