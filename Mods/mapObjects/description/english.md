# WoG Scripts — Adventure Map Objects

**In the Wake of Gods** introduced numerous adventure-map locations with unusual services, choices, and hero-specific effects. This submod brings selected WoG objects to **VCMI**, using its configurable map-object and reward systems.

The aim is to preserve the spirit of the original objects while making their mechanics practical in VCMI. **Some objects are adaptations, not exact recreations of the original ERM scripts.** The differences below explain what has changed so that players know what to expect.

## Differences from original WoG

### Arcane Tower

- **Original WoG:** The hero chooses which primary skill to increase and which different primary skill to decrease. Several exchanges can be made within the same dialogue. The supplied ERM script does not charge movement points for these exchanges.
- **VCMI:** One eligible **+1 / −1 primary-skill exchange** is proposed at random. Each accepted exchange costs **300 movement points**. The tower can be used repeatedly, but every trade requires another interaction; an unwanted proposal may be declined.
- **Limitation:** WoG checks primary skills without artifact bonuses. The corresponding VCMI stat limiters have not been verified to behave identically with equipped artifacts. The original AI-specific experience reward is not included.

### Battle Academy

- **Original WoG:** The player chooses between Attack/Defence training, a combat secondary skill, and an artifact shop, with script-driven menus and eligibility checks.
- **VCMI:** A single eligible service is offered at random. Attack and Defence training retain the **500 gold × current attribute** price formula, and secondary-skill training costs **3,000 gold**. The Academy also has a defined pool of **16 purchasable artifacts**.
- **Difference:** Each hero may accept one service per Academy per day. Daily special offers are selected at the daily reset rather than changing whenever a proposal is refused. Special handling of base stats and full secondary-skill slots is simplified.

### School of Wizardry

- **Original WoG:** The player selects magical-stat training, secondary-skill lessons, a daily spell, spell-scroll copying, or a spellbook through a scripted dialogue. The school has additional skill-slot and spell-eligibility logic.
- **VCMI:** The school proposes one eligible service at a time. It includes Spell Power/Knowledge training, magical secondary skills, **60 purchasable spells**, **69 scroll-copy recipes**, and a spellbook service. One accepted service per hero per school is available each day.
- **Difference:** The daily spell and skill pools are determined through VCMI reward resets, not a complete copy of WoG's per-turn scripting. Scroll copying requires **Expert Wisdom** in the current configuration, even for lower-level spells. The fixed spell lists do not automatically include spells added by other mods.

### Artificer

- **Original WoG:** A scripted workshop lets heroes choose artifact upgrades, exchanges, and combinations. It examines artifact conditions and supports special handling for equipped, enhanced, and restricted artifacts. The intended second service on a day costs double.
- **VCMI:** The workshop provides **119 defined recipes** (59 upgrades, 58 exchanges, and 2 combinations). One eligible recipe is proposed at random. Accepted transactions consume the specified artifacts, charge gold and sometimes mithril, and cost **100 movement points**.
- **Difference:** Recipes are static rather than generated through the full WoG selection logic. A doubled-price `onVisited` set is configured, but whether it can be reached under the per-hero daily visit restriction needs in-game verification. WoG's special artifact restrictions are not fully reproduced by the map-object configuration.

### Junk Merchant

- **Original WoG:** The merchant searches the hero's backpack and lets the player navigate scripted choices to exchange selected artifacts or sell spell scrolls.
- **VCMI:** The merchant has **32 artifact-specific deals** and **70 specified spell-scroll sales**. A single eligible deal is offered at random, and the hero may refuse and interact again. Each listed scroll sale consumes the scroll and awards **500 gold**.
- **Difference:** There is no full backpack-selection dialogue. The fixed scroll list does not automatically include new spells from other mods; treatment of equipped versus backpack artifacts still requires testing.

### Alms House

- **Original WoG:** A shared per-hero flag prevents receiving aid from multiple Alms Houses. The script may grant several kinds of aid at once; it gives **100 gold** if the player's gold is zero and **1,000 experience** if the hero has fewer than **200 experience points**. After any successful aid, all remaining hero movement is removed.
- **VCMI:** The house checks the hero's attributes and the player's resources and can provide the corresponding gifts. A zero-gold treasury is rewarded with only **1 gold**. The experience condition uses **hero level below 2** instead of the original experience threshold.
- **Difference:** Visits are recorded per object rather than through the original shared hero flag, and the current VCMI reward does **not** consume the hero's remaining movement. Its stat tests are expressed as thresholds rather than WoG's exact-value checks.

### Magic Mushrooms — Air, Earth, Fire, and Water

- **Original WoG:** Each mushroom temporarily sets the matching **learned secondary skill** to Expert, remembers the hero's previous rank, and restores it at the beginning of the following week. A hero already at Expert cannot benefit. The scripts track use per hero and magic school, even when the hero's eight skill slots are full.
- **VCMI:** Each mushroom grants a temporary **Expert-level magic-school bonus** with `ONE_WEEK` duration. It does not directly rewrite and later restore the hero's learned skill rank.
- **Difference:** A weekly timed bonus is an approximation of the original skill-replacement procedure. The JSON does not contain the same already-Expert test, shared per-school visit flag, or explicit restoration of the former skill rank. The precise expiration boundary is controlled by VCMI.

### Potion Fountains

**Fountain of Fortune — Hydromel**

- **Original WoG:** Visiting refills **three Hydromel doses** on the hero. A dose can be used at battle start for **+2 Attack and +2 Defence** during that battle.
- **VCMI:** Visiting grants **one Hydromel Potion artifact** and one randomly selected Luck effect (**−1, +1, +2, or +3**) lasting one battle.

**Valhalla's Fountain — Berserker Potion**

- **Original WoG:** Refills **three doses**. Drinking one at battle start gives **+10 Attack and maximum Luck**, temporarily prevents spellcasting by suppressing available mana, and restores mana afterward.
- **VCMI:** Gives **one Berserker Potion artifact**, with a **weekly visitor reset**.

**Venus's Fountain — Venus's Blessing**

- **Original WoG:** Refills **three doses**. Drinking one grants **maximum Morale and Luck** for a battle.
- **VCMI:** Gives **one Venus's Blessing artifact**, with a **weekly visitor reset**.

**Important:** WoG tracks potion doses per hero, while these VCMI map objects award inventory artifacts. Their actual use, charges, and combat bonuses depend on the separate artifact and combat implementations, not on the map-object JSON alone. In original WoG, combining Hydromel and Berserker in one battle can also cause a permanent **−1 Spell Power** penalty. That interaction is not established by the VCMI fountain definitions.

### Mirror of the Home-Way

- **Original WoG (updated script):** Opens a Town Portal destination dialogue without charging mana, movement, or gold. Older comments mentioning a **1,000-gold fee** remain in the ERM file, but the corresponding payment commands are disabled. AI use is disabled in the active script.
- **VCMI:** Requires and spends **1,000 gold**, then uses an **Expert Town Portal spell-cast reward**. The service can be used repeatedly.
- **Difference:** The original custom bypass of normal Town Portal restrictions and its special AI handling are not reproduced explicitly; remaining spell requirements depend on VCMI's spell-casting implementation.

### Palace of Dreams

- **Original WoG:** A casino with separate **resource and artifact slot machines**. Each spin costs **100 gold**; a visit consumes **300 movement points**. The player may spin repeatedly (up to 100 times per session) and wins a prize when three reel symbols match.
- **VCMI:** A simplified random encounter with **five outcomes**: no prize, resources, a Treasure artifact, a Minor artifact with gold, or a Major artifact with gold. A hero must have at least **1,000 gold** to participate, and the object has a **daily reset**.
- **Difference:** There are no reel animations, resource/artifact machine selection, or repeated spins within the same visit. No movement cost is configured. Two reward branches currently **add 2,000 or 5,000 gold** rather than deducting the expected 1,000; those are the values specified in the VCMI configuration and should not be mistaken for the original WoG slot-machine economy.

### Sphinxes — Blessings and Curses

Applies to all six Sphinx variants: `zsphnx10`, `zsphnx11`, `zsphnx12`, `zsphnx13`, `zsphnx14`, and `zsphnx15`.

- **Original WoG:** The Sphinx asks a riddle. A correct answer earns a blessing; an incorrect answer brings a curse. The original system supports various effects with different strengths and durations, displayed in a dedicated Blessings and Curses area on the hero screen.
- **VCMI:** Riddles are replaced by a direct **50% blessing / 50% curse** roll. Each trial costs **1,280 movement points**. A hero may undertake one trial per Sphinx per day, and the outcome cannot be declined after entering.
- **Differences:** All six visual variants use the same pool of **12 blessings and 12 curses**, with weighted outcomes lasting **1–7 days**. Effects use VCMI's timed bonus system instead of the original riddle interface and WoG-specific Blessings and Curses display. The outcome is determined by chance, **not by the player's answer**.

## Compatibility and implementation notes

- These are **VCMI adaptations of WoG mechanics**, not binary-compatible conversions of ERM scripts. Several objects use one random eligible offer instead of the original multi-option dialogue.
- Where the original script remembers previous skill levels, counts potion charges, modifies combat state, or bypasses spell restrictions, **map-object JSON alone may not reproduce the full behavior**.
- Prices, reward pools, visit resets, and duration rules above describe the configurations provided with this submod. They should not be treated as promises of identical behavior in every VCMI version or mod combination.
- The comparisons are primarily based on the supplied WoG ERM/ERT scripts and VCMI object configurations. For the Sphinx, the original riddle and blessing/curse rules are based on published WoG documentation; the exact matching original Sphinx ERM/ERT was not supplied.

For additional context, see the [VCMI rewardable map-object documentation](https://vcmi.eu/modders/Map_Objects/Rewardable/) and the [WoG Sphinx feature description](https://heroes3wog.net/sphinx-blessings-and-curses/).
