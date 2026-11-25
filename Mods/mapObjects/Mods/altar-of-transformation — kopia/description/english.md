# Altar of Transformation — 0.3.2

The altar reshapes the hero's army once per week per altar. It does not charge gold or movement points. Its magic is shared by all heroes visiting that altar.

## How to use it

* With at least 100 spell points, choose an available destination: Castle, Rampart, Tower, Inferno, Necropolis, Dungeon, Stronghold, Fortress, Conflux or neutral creatures. A chosen paid destination costs 100 spell points.
* A free destination is rolled for the altar and refreshed weekly. If eligible, it appears last in the selection. Its icon duplicates the corresponding paid destination when that option is present. A single available option is granted automatically (including the free offer when the hero has less than 100 mana). There is no separate confirmation or cancel button.
* A destination without any eligible stack is not offered. If the random destination does not match any eligible stack, there is no free offer. An army with no eligible troops spends no mana and does not consume the altar's weekly transformation.
* Creature pictures are destination indicators, not a preview of the exact resulting army. The choice dialog has a maximum of eleven components. A single automatic reward can still generate a long sequence of creature icons in the adventure-map infobox; the engine generates one icon for each conversion mapping. The graphically rendered window has not been tested.

## Which creatures change?

The classic destination list is unchanged. Ordinary creatures retain their tier and upgrade status according to the configured VCMI creature levels and the WoG upgrade exceptions. For example, Centaurs become Pikemen and Centaur Captains become Halberdiers when choosing Castle. Creature counts do not change. Existing same-faction exclusions remain; protected creatures are left untouched. Powerful neutral dragons (Azure, Crystal, Rust, Dracolich), Ghosts and Emissaries are protected. Faerie Dragons may become level-eight faction creatures. Neutral destinations use fixed representative creatures instead of all of WoG's random alternatives; some WoG neutral tier categories differ from the actual port's creature levels (e.g. War Zealot is level 6 in VCMI but appears in the level-5 neutral table in Script 14). The neutral outcome follows the Script 14 category in this case.

## Stack Experience

Changing the type uses the native `changeStackType` mechanism. A transformed stack retains 75% of its former experience with the supplied default VCMI settings. Unchanged stacks are not transformed. Original WoG explicitly retains all stack experience. No global experience setting or C++ code is changed.

## Compatibility

Requires WoG Creatures and Level 8 Units, as in the previous version. The optional Tides of War compatibility adds source creatures, not additional destinations. Its existing source conversion tables are retained; its 20 one-based `modify@` entries were checked statically. Separate HotA Factory, Cove and Bulwark compatibility folders are omitted in this classic edition. Install by replacing the previous `altar-of-transformation` folder, not by merging it, to remove the obsolete folders. Start a new game for reliable testing.

## Differences from WoG 3.59

WoG supports partial mana investments, a separate faction choice, refusal, per-stack random outcomes, randomized neutral alternatives, special Mummy and Sylvan Centaur substitutions, and a free controlled choice for AI. These have not been reproduced. The free option in this port selects one destination for all eligible stacks. WoG 3.59 texts are preserved in `description/wog-original/`; active English and Polish text is localized separately. The original post-transformation and resistance messages remain archived where the VCMI dialog sequence cannot present them correctly.

## Validation

Static checks: all 100 dice values, 20 reward branches and matching source limiters, 20 Tides of War one-based patch indices, and all 42 ERT records. Native headless tests: 11 selection components on a mixed army, 100 mana expenditure, basic/upgraded and tier conversion, unchanged protected creatures and level-eight Faerie Dragon transformation, unchanged troop counts, experience 10000 to 7500, weekly blocking and reset, free automatic conversion at 99 mana, and no-cost visit with protected-only army. The full port loaded with `--dummy-run` exit 0. Tests used the supplied VCMI server and actual object instances, not the graphical client. The Tides of War mod itself was not installed; no native compatibility run. AI, RMG, saves, multiplayer, Polish client rendering and other screen resolutions remain untested.
