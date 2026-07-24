# X4 Foundations Mods
Various game mods for X4 Foundations.

These are available under the MIT license.

## [Auto Resource Probe](/mpl_auto_resource_probe)
Automaticallys adds resource probes to sectors with resources when the player enters them.

The behaviour will execute even where the player is not pilot of a ship (i.e. travelling as a ship passenger, or using teleport).

## [Auto Satellite](/mpl_auto_satellite)
Automaticallys adds satellites to a sector whenever the player enters one.

The satellites are placed so that all gates, highways, and stations are covered by at least one.

The behaviour will execute even where the player is not pilot of a ship (i.e. travelling as a ship passenger, or using teleport).

This will automatically use a "Mk3 Advanced" satellite from any mods that may have been installed.  It will automatically use a standard "Mk2 Advanced" Satellite if no suitable mod is installed.

## [Auto Scan Sector](/mpl_auto_scan_sector)
Automatically fully scans a sector when the player enters it.

Only applies to the player's current ship.

## [Collect In Sector](/mpl_collect_in_sector)
Tweaks the collect drops command to collect drops in an entire sector instead of within a 40km radius.

Instantly sells both picked up ammo drops and cargo inventory when finished collecting drops.  *Does not sell inventory items*.

Set it as a repeat order for the ship to continually pickup drops in a single sector.

## [Enable ATF Ship Buying](/mpl_enable_atf_ships)
Unrestricts the blueprints for the Asgard and Syn with the Terran faction so that the player can order them at Terran shipyards.

## [Enable Timelines Unlocks](/mpl_enable_timeline_unlocks)
Unlocks all rewards automatically for the Timelines missions without having to perform the missions themselves.

The change takes place immediately upon starting a new game, or loading an existing save game.

Unlike other downloads that replace the userdata file entirely, this mod simply adds the required userdata settings to unlock everything.
Note that because it is a mod, it will mark all games as modified.

## [Fix Errors](/mpl_fix_errors)
Fixes some minor bugs in the built-in game scripts, mainly to stop log spam but also corrects some non-working functionality.

## [Mine In Sector](mpl_mine_in_sector)
Tweaks the mining raidus of a ship to mine in a 350km (essentially the whole sector) instead of within a 40km radius.

## [No Pirate Plunder](/mpl_no_pirate_plunder)
Stops pirate ships from plundering any player ships.

## [Salvage Ship](/mpl_salvage_ship)
Adds a new action to salvage a selected ship at any player station that supports ship build operations (fabrication bay, maintenance bay, etc).

Salvaging a ship explicitly salvages the raw materials used to make the ship and equipment (including deployables, drones, and ammunition), as well as salvaging its cargo, and the pilot's inventory items.

The salvaging of the ship and equipment works by:
- Salvaging 90% of the input materials where the player faction knows the blueprint for the equipment or ship being salvaged
- Salvaging 60% of the input materials where the player faction does not know the blueprint

The salvaged wares and cargo will be automatically added to the cargo storage on the station that executed the salvage operation.
Where the salvaged wares would exceed the storage capacity, the remaining unsalvaged wares are converted to credits.

Salvaged inventory items are automatically added to the player's inventory.

Once a ship has been salvaged it is permanently removed from the game universe.

## [Ship Claim](/mpl_shipclaim)
Improved player claiming of abandoned ships by:
- Allowing the player to scan from their ship within 200m of data leak
- Adds a new pilot to the claimed ship Automatically
- Sends the ship to the nearest, safe equipment dock, wharf, or shipyard (as appropriate)

Also adds a new default order named 'Claim Abandoned Ships' for your ships that allows a ship to continually claim abandoned ships in designated sectors.
As with the changes to player claiming, these automatically claimed ships will automatically get a new pilot and can (optionally) be sent to a safe, appropriate station.

## [Wreck Salvager](/mpl_wreck_salvager)
Adds new default behaviours to allow the automated salvaging of ships, and of stations.

### Salvage Wrecked Ships
Adds a new behaviour to salvage wrecked ships in designated sectors to recover a small portion of their blueprint wares and send them to a designated player station.

The designated ship will salvage wrecks until there are none remaining in the designated sectors, in which case they will dock at a friendly station and wait for a new wreck to appear.

The salvaging of the ship and equipment works by:
- Salvaging 20% of the input materials where the player faction knows the blueprint for the equipment or ship being salvaged
- Salvaging 10% of the input materials where the player faction does not know the blueprint

The salvaged wares and cargo will be automatically added to the cargo storage on the target station for the Wreck Salvager.
Where the salvaged wares would exceed the storage capacity, the remaining unsalvaged wares are converted to credits.

### Salvage Wrecked Stations
Adds a new behaviour to salvage wrecked stations in the whole universe (excluding specifically chosen sectors to avoid) to recover a small portion of their blueprint wares and send them to a designated player station.

The designated ship will salvage wrecks until there are none remaining in the universe, in which case they will dock at a friendly station and wait for a new wreck to appear.

The salvaging of the station module and loadout equipment (weapons, shields, etc.) works by:
- Salvaging 20% of the input materials where the player faction knows the blueprint for the equipment or ship being salvaged
- Salvaging 10% of the input materials where the player faction does not know the blueprint
