# Palace of Dreams (Script 11)

## Playing the game

The Palace of Dreams is a casino inspired by the original WoG slot machines. A visit automatically plays one game if your kingdom has at least **100 gold** and the hero has at least **1 movement point**. The game costs 100 gold and removes 400 movement points (or all remaining movement if less than 400). No confirmation is shown: read the object description before entering. Each palace offers one completed game per day, shared by all heroes and players. A visit without sufficient gold or movement does not consume the game. A different palace can still be used.

| Outcome | Probability per game | Reward |
|---|---:|---|
| No win | 97⅓% | Lose the stake |
| Non-gold resource | 1⅓% | One of wood, ore, mercury, sulfur, crystal or gems |
| Gold | ⅓% | A gold jackpot, net of the 100 gold stake |
| Artifact | 1% | One allowed random artifact (40% Treasure, 30% Minor, 20% Major, 10% Relic within this branch) |

These are design probabilities, assuming the engine's uniform dice and reward selection, not a measured statistical sample. Resource rewards use floor(day/7) + 4 + a random integer 0–4. The gold jackpot is day × 100 + 4000 + a random integer 0–100 before deducting the stake. The actual day is used through day 112; thereafter seven-day bands starting on day 113 use the band's first day, and scaling is capped at day 365. For example, on day 28, a non-gold jackpot pays 8–12 units of one resource, while a gold jackpot adds 6700–6800 gold net.

## Differences from WoG 3.59 alpha

The original `script011.erm` (FU777–779) offers separate resource and artifact machines, an explicit choice to play, three displayed reels and up to 100 spins per session, with 400 movement deducted on entering (even if the hero declines or lacks gold, provided movement is positive). Each spin costs 100 gold. Resource reel enumeration gives approximately 3.3635% wins in the resource machine alone, including 0.7727% gold wins. Artifact odds depend on the allowed artifact pool and time-based RNG; the original script biases gold in the middle resource reel and rerolls relics with 50% probability. VCMI combines both machines into a single draw and approximates the overall odds. Artifact class weights are an adaptation, not extracted exact WoG probabilities; VCMI uses its own allowed/eligible artifact pool, class fallback and allocation balancing. No visual reels, repeated-play dialogue, separate machine choice or WoG AI logic. The fixed daily die is generated on configuration/reset; for die 98 and 99, the engine chooses among available rewards on visit. The preview is disabled to avoid revealing prizes; normal visits are automatic because the rewardable refusal dialogue would otherwise expose the result before payment. The cost is applied on successful eligible visits only. Gold prizes are stored as net resource changes, so the stake is not displayed as a separate debit. No Lua or C++ changes. RMG and AI values unchanged from the input; the new economy may need practical balancing.

All 23 original ERT records, including two empty records, are preserved in `description/wog-original`. Active messages use adapted original wording; English and Polish translations are separate. Original replay and machine-choice texts are archived only.

## Validation

VCMI 1.8 full-mod `--dummy-run` returned 0. Static test: 40,000 date/dice combinations (days 1–400, 100 dice values). Native fixture: 8 groups of assertions, including insufficient gold, zero movement, loss at 399 movement, shared daily limit, daily reset/hidden popup, 7 resource date checks and actual resource payout, all 3 mixed-branch candidates plus a gold payout with the other candidates disabled in the test fixture, and random artifact payout. Native exit 0. Test uses real rewardable object handlers, not a full GUI visit. Initial native link failure was corrected by avoiding non-exported methods; initial teardown crash was corrected by destroying the fixture before the game library. No production engine modification. Not tested: client GUI or Polish rendering, actual walking, AI, save/load, RMG balance, full backpack or maps banning all artifacts of a class. The 459 JSON reward entries are mostly date variants; performance in large maps is not measured.
