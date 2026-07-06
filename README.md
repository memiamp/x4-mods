# X4 Foundations Mods
Various game mods for X4 Foundations.

These are available under the MIT license.

## [Auto Resource Probe](/mpl_auto_resource_probe)
Automaticallys adds resource probes to sectors with resources when the player enters them.

Only applies to the player's current ship.

## [Auto Scan Sector](/mpl_auto_scan_sector)
Automatically fully scans a sector when the player enters it.

Only applies to the player's current ship.

## [Collect In Sector](/mpl_collect_in_sector)
Tweaks the collect drops command to collect drops in an entire sector instead of within a 40km radius.

Instantly sells both picked up ammo drops and cargo inventory when finished collecting drops.  *Does not sell inventory items*.

Set it as a repeat order for the ship to continually pickup drops in a single sector.

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
Adds a new order to salvage wrecks in designated sectors to recover a small portion of their blueprint wares and send them to a designated player station.

The designated ship will salvage wrecks until there are none remaining in the designated sectors, in which case they will dock at a friendly station.

The salvaging of the ship and equipment works by:
- Salvaging 20% of the input materials where the player faction knows the blueprint for the equipment or ship being salvaged
- Salvaging 10% of the input materials where the player faction does not know the blueprint

The salvaged wares and cargo will be automatically added to the cargo storage on the target station for the Wreck Salvager.
Where the salvaged wares would exceed the storage capacity, the remaining unsalvaged wares are converted to credits.
