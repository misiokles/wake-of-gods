# New Chest I — Treasure Chests

*Some chests contain a fortune. Others hide a chance to improve your army, test your luck, or pay a price for curiosity.*

This submod introduces three separate adventure-map treasure chests using the WoG `ZCHST1.DEF` graphic. It does not replace ordinary Heroes III chests.

## Gold or Troop Upgrade

A chest has one of five gold values. The same value determines the maximum gold-equivalent cost of the free troop upgrade.

| Gold | Chance in this port | Upgrade budget |
|---:|---:|---:|
| 1,000 | 31% | 1,500 |
| 1,500 | 30% | 2,250 |
| 2,000 | 30% | 3,000 |
| 2,500 | 7% | 3,750 |
| 3,000 | 2% | 4,500 |

Choose gold or one eligible upgrade. The mod supports 63 upgrade pairs from the nine original towns, including elemental upgrades. The difference between the base and upgraded creature's gold cost, multiplied by the total number of creatures of that type in the hero's army, must fit the budget. Costs use the standard Heroes III creature price table, not dynamic prices from other mods. For example, a 1,000-gold chest can upgrade at most 100 Pikemen to Halberdiers (15 gold per creature). All stacks of the selected type are upgraded; no partial upgrade is performed. The game does not automatically select the highest-value individual stack as the original ERM did.

If no upgrade is affordable within the chest's budget, the chest offers rare resources or training instead of gold.

## Resources or Primary Skill

Choose one of the two rewards below. The chest grants one randomly selected rare resource (Mercury, Sulfur, Crystal or Gems), or the indicated primary skill.

| Gold-equivalent tier | Resource quantity | Training |
|---:|---:|---|
| 1,000 | 4 | +1 Knowledge |
| 1,500 | 6 | +1 Defence |
| 2,000 | 8 | +1 Attack or +1 Spell Power (equal chances) |
| 2,500 | 10 | +2 to one random primary skill |
| 3,000 | 12 | +2 to one random primary skill |

The gold-equivalent tier is not a payment: the reward is free. The dialogue displays the available reward components. These two chest variants allow declining the offer.

## Two Artifacts — or a Gas Trap

Opening this chest gives one Treasure-class artifact and one Minor-class artifact. Unless the hero has Expert Luck or Expert Intelligence, it also grants one of four equally likely gas effects for the next battle:

- Disease (illness)
- Poison
- Weakness
- Slow (lethargy)

At battle start the gas applies the corresponding native VCMI spell effect to each affected friendly stack that is alive (not necessarily living) at Basic mastery, for 255 rounds. It is applied only once, not renewed every round. The Lua script excludes siege weapons, and uses direct spell effects without a new spell-casting animation or resistance roll. It requests bypassing spell immunity as in the original ERM forced effect. The effects can subsequently be removed by normal game mechanics. The trigger has `ONE_BATTLE` duration; normal expiry at battle end has not yet been exercised in a complete battle test. The two Expert skills prevent the trap; Intelligence takes precedence in the message when both are Expert.

Opening the trapped chest is not a reversible choice. All three variants request removal after the reward is claimed.

## Random maps and compatibility

The original port's RMG values are unchanged: rarity weights 24/16/44, map limits 6/4/12, zone limits 2/2/not specified, for gold/resource/trap respectively. These are generator parameters, not fixed percentages. They do not reproduce the original coordinate-based 9:6:1 split. No random-map generation test was performed. No extra creature mod is required; upgrades of mod-added creatures are not included. The Adventure Cave wealth multiplier and original AI-specific selection rules are not reproduced.

## Language and source material

English and Polish active texts are in `content/translations/`. All 13 numbered strings from the original WoG 3.59 alpha Script 29 are preserved in `description/wog-original/`, alongside unchanged ERM/ERT files. The generic resource prompt adapts the dynamic ERM resource placeholder to VCMI's multi-choice dialogue.

*Implementation: New Chest I 0.1.1 (VCMI 1.8, JSON + Lua). Headless load and controlled native tests passed. Full battle completion, GUI, AI, RMG, save/load, multiple accumulated traps and all upgrade transactions have not been individually tested.*


## v0.1.2 audit
The active ERT-derived messages were retained or adapted to the actual choice and next-battle trap timing. Removed unregistered obsolete translations and archived-only ERT keys from the active translations; the original ERM/ERT and strings.json remain unchanged. The 31/30/30/7/2 gold distribution is the existing rounded port distribution (original ERM: three equal shares of 91%, then 7% and 2%). No reward, RMG or Lua changes.

Validation in the v0.1.2 cycle: VCMI 1.8.0 dummy-run PASS. 24,622 static eligibility cases and 16 skill profiles; native tests: 3 Pikeman boundaries and 16 trap skill profiles PASS. No full battle or gas effect execution.
