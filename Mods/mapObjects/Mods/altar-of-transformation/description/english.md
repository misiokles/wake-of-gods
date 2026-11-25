# Altar of Transformation 0.4.2

The Altar offers eleven choices: Castle, Rampart, Tower, Inferno, Stronghold, Necropolis, Dungeon, Fortress, Conflux, Neutral and Random. Cancel closes the dialog without paying or consuming the weekly allowance.

## Costs and visits

Bring at least 1,000 gold, 500 movement points and an eligible army. A named destination (including Neutral) costs 1,000 gold and 500 movement points; Random costs 500 gold and 500 movement points. No mana is used. A named destination that needs no transformation is free and does not consume the weekly allowance. Only one paid transformation per hero per calendar week is allowed across all altars. Other heroes are independent. The allowance expires on Monday.

## Transformation

Eligible troops retain their tier and quantity. Standard town troops mapped to another town retain their upgrade status. Already matching troops remain unchanged. The existing protected-creature exceptions remain. Stack type changes retain 75% of Stack Experience under the tested global settings. Neutral creatures do not consistently have base/upgraded pairs, so Neutral uses same-tier representatives rather than promising an equivalent upgrade at every tier.

| Tier | Neutral destination for basic / upgraded Castle troops |
|---|---|
| 1 | Halfling / Halfling (Peasant with Factory compatibility) |
| 2 | Rogue / Boar |
| 3 | Mummy / Nomad |
| 4 | Sharpshooter / Werewolf |
| 5 | Arctic Sharpshooter / Arctic Sharpshooter |
| 6 | Enchanter / Nightmare |
| 7 | Gorynych / Gorynych |
| 8 | Faerie Dragon (supported level-eight troops) |

Random selects a single destination for the entire army from all ten named directions, each at 10%. The hidden result is rolled once per altar per week, not on each visit. It may select a destination requiring no change; the Random fee and weekly allowance are still consumed.

## Mod creatures and interface

The native `changeCreatures` reward requires explicit source/target IDs. Unknown creatures are left untouched. Optional Factory and Cove compatibility tables add source troops without adding destination icons. Factory compatibility replaces the Neutral tier-one target with Peasant (including Factory Halfling/Grenadier); Cove alone uses Halfling. When both source addons are active, enable the nested `factory-neutral` addon as well for Cove tier-one sources to use Peasants. The existing Tides of War addon is re-indexed for the new table. These external addons are based on supplied older compatibility IDs; external creature definitions were unavailable for native integration testing. Courtyard and Forge need their own tables from their actual definitions.

Eleven special, excluded-from-randomization technical creature definitions supply the menu icons. No `showInInfobox` override is used; the engine uses its default AUTO mode. The native selector payload contains eleven selectable components and supports Cancel. Actual visual rendering was not tested.

Original WoG Script 14 texts remain archived. JSON only; no engine modifications or Lua.

## Text-only update (0.4.2)

The English encounter text reuses the first sentence and final paragraph of WoG ERT 114004 verbatim, replacing the obsolete mana instructions with current prices and choice rules. ERT 114005 is reused verbatim after the heading. The unavailable message is new because the gold, movement and eligible-army requirements have no direct equivalent in Script 14. Existing English names and short icon labels are retained (Neutral and Random). Polish encounter texts are new translations/adaptations of the English wording, not verified historical Polish ERT. The original transformation-success messages 114006–114007 are not inserted because the current reward messages share the selection key. No gameplay, sprites, IDs or compatibility tables were changed. GUI validation remains pending.
