# Sphinxes — Trials of Fate

The enigmatic Sphinxes have long guarded ancient paths, forgotten treasures, and secrets that mortals were never meant to uncover. In this VCMI adaptation of *In the Wake of Gods*, their traditional riddles are replaced by a gamble with fate: a passing hero may receive a temporary blessing — or suffer a temporary curse.

All **six Sphinx variants** share **exactly the same rules and possible outcomes**. Their appearance and allowed terrain are the only differences.

## The Trial

- **Chance:** 50% blessing, 50% curse.
- **Cost:** 1,280 movement points per trial; the hero must have at least that many remaining.
- **Duration:** Each blessing or curse lasts **1–7 days**, selected randomly with equal probability for each duration.
- **Visits:** Each hero may undertake one trial **per individual Sphinx per day**.
- **Outcome:** Chosen anew for each eligible visit; it is not fixed when the map is generated.
- **Refusal:** Once the object is visited, the trial cannot be declined.
- **Permanence:** No trial grants a permanent hero bonus. Temporary effects expire automatically.

The 12 blessing types and 12 curse types are **weighted** rather than equally likely. The percentages in the tables below are conditional on receiving that type of outcome; they add up to 100% within each table.

## The Twelve Blessings

| Blessing | Temporary effect | Chance among blessings |
| --- | --- | ---: |
| Favor of the Four | +1 crystal, +1 gem, +1 mercury and +1 sulfur in daily income | 10% |
| Gift of Gems | +3 gems in daily income | 5% |
| Gift of Crystals | +3 crystals in daily income | 5% |
| Gift of Mercury | +3 mercury in daily income | 5% |
| Gift of Sulfur | +3 sulfur in daily income | 5% |
| Gift of Timber | +5 wood in daily income | 5% |
| Gift of Ore | +5 ore in daily income | 5% |
| Builders' Fortune | +3 wood and +3 ore in daily income | 10% |
| Golden Fortune | +1,000 gold in daily income | 15% |
| Traveler's Favor | +250 maximum land movement points at the start of each day | 10% |
| Arcane Renewal | +6 spell points regenerated per day | 10% |
| Wisdom of Ages | +25% experience gain | 15% |

## The Twelve Curses

| Curse | Temporary effect | Chance among curses |
| --- | --- | ---: |
| Fading Courage | -1 Morale | 10% |
| Broken Courage | -2 Morale | 5% |
| Unlucky Omen | -1 Luck | 5% |
| Dire Omen | -2 Luck | 5% |
| Heavy Footsteps | -150 maximum land movement points at the start of each day | 5% |
| Weary Journey | -250 maximum land movement points at the start of each day | 5% |
| Burden of Fate | -400 maximum land movement points at the start of each day | 5% |
| Clouded Insight | -15% experience gain | 10% |
| Lost Knowledge | -25% experience gain | 15% |
| Forbidden Knowledge | -40% experience gain | 10% |
| Withered Strength | -1 Attack | 10% |
| Crumbling Defenses | -1 Defence | 15% |

## The Six Sphinxes

| Object ID | Terrain |
| --- | --- |
| `zsphnx10` | Sand |
| `zsphnx11` | Rough, Water |
| `zsphnx12` | Dirt, Grass, Lava |
| `zsphnx13` | Snow |
| `zsphnx14` | Subterranean |
| `zsphnx15` | Swamp |

Each retains its own map graphics, terrain restrictions and original object identifier. All use the same trial mechanics and reward distribution, so the player does not need to memorize separate rules for different Sphinxes.

## Implementation Notes

This is a **JSON-only VCMI reinterpretation** of the WoG Sphinx concept, not a recreation of the original riddle system. The implementation uses configurable map objects, random reward selection and timed bonuses; it requires no Lua scripts or engine modifications.

For the duration roll, the JSON contains separate entries for each possible number of days. Weighted repetitions of entries give every blessing and curse its intended probability. The configuration has **280 selectable reward entries per Sphinx**, with equal overall probability of receiving a blessing or a curse.

*The Sphinx offers no certainty. Even its greatest gift comes with the price of daring to ask.*
