# Battle Academy

The Battle Academy offers martial training and an armory for heroes preparing for difficult battles. You can improve **Attack or Defence**, learn or advance a combat secondary skill, or buy a weapon or armor artifact.

## Visiting

- One available training or purchase is offered at a time. You may decline the proposal and visit again to seek another.
- **Only one accepted service per hero, per day across all academies.** All academies are ready to serve that hero again the next day. Refused or unavailable offers do not consume the daily allowance.
- The Academy's special skill and artifacts change with the daily offerings. Declining a proposal does not necessarily change which items are stocked that day.
- Prices are paid in gold; merely viewing or declining an offer is free.

## Primary-skill training

Every lesson adds **+1 Attack** or **+1 Defence**. The price depends on the current displayed value of the attribute being raised (including equipment and active potion effects): **500 gold × that attribute's current level**, with the first point (0 → 1) free.

| Current Attack or Defence | Price for +1 |
| --- | --- |
| 0 | Free |
| 1 | 500 gold |
| 2 | 1,000 gold |
| 5 | 2,500 gold |
| 10 | 5,000 gold |
| 12 | 6,000 gold |
| 20 | 10,000 gold |
| 30 | 15,000 gold |
| 50 | 25,000 gold |
| 98 | 49,000 gold |

## Secondary skills

The academy trains heroes, not troops, and does not grant stack experience. The academy may offer **Archery, Leadership, Luck, Ballistics, Tactics, Artillery, Offence or Armorer**. Teaching a new skill at Basic or advancing it from Basic to Advanced or Advanced to Expert costs **3,000 gold**. You must have a free skill slot to learn a completely new skill.

## The armory

The Academy may stock one of these regular artifacts on a given day:

| Artifact | Price |
| --- | --- |
| Centaur Axe | 6,000 gold |
| Blackshard Of The Dead Knight | 9,000 gold |
| Greater Gnolls Flail | 12,000 gold |
| Ogres Club Of Havoc | 15,000 gold |
| Sword Of Hellfire | 18,000 gold |
| Sentinels Shield | 30,000 gold |
| Helm Of The Alabaster Unicorn | 3,000 gold |
| Skull Helmet | 9,000 gold |
| Helm Of Chaos | 12,000 gold |
| Crown Of The Supreme Magi | 15,000 gold |
| Armor Of Wonder | 12,000 gold |
| Red Dragon Flame Tongue | 12,000 gold |
| Dragon Scale Shield | 18,000 gold |
| Dragon Scale Armor | 24,000 gold |
| Bow Of Elven Cherrywood | 6,000 gold |
| Golden Bow | 24,000 gold |

## Optional Commander equipment

If the **Commanders** mod is enabled, the Academy can also offer **Axe of Smashing, Mithril Mail, Sword of Sharpness, Bow of Seeking and Hardened Shield**. Each costs **15,000 gold**. These are Commander artifacts, not ordinary hero equipment. Availability is rolled separately from the ordinary armory stock, and only qualified offers appear to the visiting hero.

## Differences from WoG 3.59

The original Script 16 (version 1.41) prices primary training using base attributes without artifacts. The current VCMI reward limiter uses the effective attribute, so equipped artifacts and potions may alter the price or eligibility. Training is configured for values 0–98. The original menu allows selection of the type of service, while this port offers one randomly chosen eligible service with its exact price; you can decline and ask again. Daily stock is rolled independently for each building, and commander stock separately, rather than a shared skill and artifact. New skills require a free slot; the original extra-fee training beyond eight skills is not reproduced. AI-specific payment and purchase behavior is not reproduced. No separate post-transaction text is shown. The 40 original ERM/ERT strings are preserved in `wog-original/` alongside active EN/PL adaptations. No engine or Lua changes.
