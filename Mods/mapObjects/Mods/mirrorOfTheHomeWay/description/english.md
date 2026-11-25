# Mirror of the Home-Way (1.0.2)

The magical mirror offers transport to an unoccupied allied town for **1,000 gold**. You do not need to know Town Portal or possess a spellbook. The mirror uses its own special adventure spell, with no mana or movement cost at any mastery. You may visit repeatedly; there is no daily or weekly limit.

## Important: payment and cancellation

Declining the initial offer is free. Once you accept, the keeper charges 1,000 gold **before** the native town-selection window opens. Closing that window, having no eligible town, or a failed teleport can cost the fee without transport. Check that you have an accessible unoccupied allied town before accepting. This is a known VCMI reward-system limitation, not the original WoG behavior.

## WoG differences

Script 52 charges only after the destination is chosen and lists the player's own towns rather than allied towns. It includes a separate no-town message and a 25% chance for AI to accept; the VCMI port uses the native selector and does not replicate these AI rules. Native targeting and terrain restrictions still apply. Original ERM and all 16 ERT records are archived in `description/wog-original/`; active EN/PL messages are in `content/translation/`. Normal Town Portal is unchanged.

## Validation

Full mod loaded in VCMI 1.8 (`--dummy-run`, exit 0). Native test verified the special spell and zero mana cost at all masteries, refusal, insufficient gold, 1,000 gold charge and two owned towns offered (enemy excluded) at zero mana and movement, lack of refund on cancellation, and direct completion of a native town-selection activity with a successful teleport at zero mana and movement. EN/PL object name checks passed. No GUI, multiplayer, AI, RMG, save/load, occupied-town or no-town scenario tests were performed. Successful teleport tested using direct activity completion, not a full map visit and client dialog flow.

## Audit 1.0.2

The original ERT 152003 offer has been adapted to mention own and allied towns and the non-refundable payment. ERT 152015 remains intact in English; Polish wording is aligned with the original. All 16 original records remain archived. The native selector uses core text IDs `core.jktext.40`, `core.jktext.41`, and `core.genrltxt.124` for the no-town case; do not globally replace them, since this would affect normal Town Portal. No changes to gameplay, object identifiers, RMG or assets.

Fresh validation: server dummy-run succeeded. Native fixture verified the 999/1000 gold boundary (six balances), special adventure spell resolution despite exclusion from default spell pool, zero mana cost and no daily cast limit at all four masteries, cancellation and information window when there are no eligible towns, and English offer rendering. The test uses a synthetic game state and captures the spell callback rather than running a full visit. A multi-town fixture could not be completed because the game state lacked a loaded map. Allied/enemy/occupied-town filtering and payment ordering were inspected in the engine source, not re-tested end to end. The earlier validation paragraph describes historical 1.0.1 tests, not this run. The WoG Graphic Fix package was not available; both object and subtype keys remain `mirrorOfTheHomeWay`, with lowercase mod scope `wake-of-gods.mapobjects.mirrorofthehomeway`.
