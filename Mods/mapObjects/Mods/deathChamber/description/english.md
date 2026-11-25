# Death Chamber (Script 70) — 1.0.1

Enter a haunted vault ruled by the Undead King. A warning asks you to accept the battle or leave. Refusal does not consume the visit.

## Encounter

The chamber is assigned one of five difficulty tiers (I–V). On the first two weeks the Lich King has 100 Attack, 100 Defence, 40 Speed, unlimited retaliation and an additional attack. His base HP is 160/180/200/220/240 and base damage is 16/18/20/22/24. From week three onwards, each elapsed week adds 2 HP and 1 damage. Eleven companies of Power Liches begin the encounter, with 2/4/6/8/10 units per company plus one for every weekly increase. The existing VCMI graveyard layout and thirty obstacles are retained. At round two the four crypts collapse and additional Liches appear; in round three, four companies of Wraiths (or Ghosts with the Creatures compatibility add-on) appear, each with twice the initial guard count. These later waves and the placement of obstacles are a VCMI adaptation, not the original conditional post-death sequence. The King uses Death Ripple, curses, Fire Shield and Counterstrike, Age from round three, and Armageddon from round two. Armageddon applies its native damage effect (base 80 per enemy stack) only to the attacking army; it does not show the usual spell-cast animation. This prevents the King killing himself and replaces WoG's more complex Anti-Magic and targeting behavior. Actual damage may be modified by spell immunities and damage modifiers.

## Optional compatibility

The base Death Chamber works without the WoG Creatures and Mithril modules, starting with this release. With **Death Chamber - Creatures Compatibility** and WoG Creatures enabled, the Lich King transforms at battle start from day 22 (week four). A separate Dracolich King has 100 Attack, 100 Defence, 40 Speed, 1000 shots, an additional attack and unlimited retaliation, plus its dragon/undead/shooting abilities. There are ten initial Power Lich companies rather than eleven. The ordinary Dracolich elsewhere in the game is unchanged. Without this add-on the Lich King remains and Wraiths replace the later Ghost wave. If no suitable hex is available for the double-wide replacement, the Lich King remains as a fallback.

**Death Chamber - Mithril rewards** requires WoG Mithril and the base Death Chamber. For both optional features, also enable the nested **Death Chamber - Creatures + Mithril Compatibility** add-on. It combines the two reward patches.

## Rewards

The following table shows the initial values (weeks one and two). Ghosts and Mithril are optional rewards.

| Tier | Gold | Ghosts | Mithril |
|---|---:|---:|---:|
| I | 12,000 | 10 | 8 |
| II | 14,000 | 12 | 10 |
| III | 16,000 | 14 | 12 |
| IV | 18,000 | 16 | 14 |
| V | 20,000 | 18 | 16 |

Starting in week three, gold increases by 100 and Mithril by 1 per week. From week four the chamber pays an additional 4000 gold, 2 Ghosts (if enabled) and 4 Mithril (if enabled). These late rewards also apply in the base module even without the Dracolich transformation. Reward scaling stops at day 365 to bound the JSON size; combat growth continues. The original ERM growth option is treated as enabled at all times.

## Returning to a chamber

All chambers are reset at the beginning of a new 28-day cycle: days 29, 57, 85, and so on. Guards and rewards are regenerated, including the difficulty roll. This is not a personal 28-day cooldown after victory, and can reset an undefeated chamber as well. Choose your timing carefully.

## Differences and testing

Sources: WoG 3.59 alpha `script070.erm` (FU14306, FU14310, BF, BR, BA1, transformation at lines 469–516) and `script070.ert` (170000–170058). All 59 ERT records and both original files are archived. The active warning uses one fixed original combination; English/Polish dialog and battle log remain in translation files. The original random obstacle families, special resurrection of Ghosts after the King's death, dynamic formation, disabled Tactics, 50% Inferno, expert Anti-Magic and full transformation animation are not reproduced. The legacy curse, crypt, Age and Death Ripple adaptation remains; its fifth difficulty reuses the fourth curse. No additional WoG boss traits were applied globally. RMG values and visual layout are preserved. No C++ engine changes.


VCMI 1.8.0 loaded the chamber with no optional add-on, with Creatures Compatibility, with Mithril rewards, and with both plus the combined rewards add-on. These are content load checks. Battle completion, retreat, reward delivery, multiplayer, map generation, and the English and Polish client interfaces still need a playthrough.
