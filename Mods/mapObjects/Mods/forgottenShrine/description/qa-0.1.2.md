# Forgotten Shrine 0.1.2 – audit

## Sources
- WoG 3.58 script 60 / classic script 18, Forgotten Shrine v1.3, Petyo P. Georgiev (19 October 2004).
- WoG-master script060.erm: later graphics-path update; ERA 2.9.x v1.4: renamed functions and variables, same reward pool and visit conditions.
- ERT 160000–160013: classic and ERA copies identical; WoG-master capitalizes Shrine in 160000, 160001 and 160004.
- Restored VCMI 1.8 source and binary. No engine changes.

## Changes
- Hide spell identity before acceptance. All 20 rewards use the same localized message, including the original ERT 160003 and 160005 and a conditional adaptation of 160006. Native SELECT_RANDOM chooses the candidate before the yes/no dialog; refusing grants nothing and a later visit may reroll, but there is no spell-name or spell component in the offer.
- Restore ERT 160000/160001 visit-status suffixes and 160002 bonus description. Preserve 160007 and 160008. 160004 is the existing object name. ERT 160009 (refusal confirmation) and 160010–160013 (battle-start popups) have no direct equivalent in this configuration and are not presented as implemented.
- English and Polish translations, revised player documentation. No change to reward values, spell pool, movement, duration, RMG or visit mode.

## Native component tests
The QA program uses the actual loaded CRewardableObject, Rewardable::Limiter, Rewardable::Reward and CGHeroInstance from libvcmi. The fixture initializes StartInfo using INVALID mode (no map/game startup), adds a permanent unrelated morale bonus to initialize the hero bonus cache, and directly invokes the same bonus cleanup method as the battle-result handler. It does not conduct an adventure-map visit or fight a battle. All 20 reward records and seven movement boundaries passed. No spell-identifying text or reward components appear in the configured confirmation. The callback implementation and source were reviewed for random selection, refusal, grant and cleanup.

## Remaining differences / tests
- Original script applies the chosen spell directly to stacks according to hard-coded creature and artifact rules. VCMI uses passive opening spells with forceMassive, spell mastery 3 and duration parameter 50, subject to native spell mechanics. Frenzy uses UNTIL_ATTACK. Recanter’s Cloak, Orb of Inhibition, Cursed Ground and spell immunities are handled by native spell checks, not the original ERM hard-coded tables. Exact equivalence of these restrictions is not claimed.
- VCMI logs the actual cast via the native BonusCaster; the original popup before battle and refusal message are absent. No custom Lua added.
- Outstanding: GUI confirmation, actual battle for all 20 spells (both sides, eligible/immune creatures, artifact and terrain restrictions), real battle-result cleanup, repeated map visits, AI, save/load. Headless initialization excludes Altar and Death Chamber and compatibility modules lacking dependencies.
