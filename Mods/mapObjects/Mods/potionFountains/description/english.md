# Potion Fountains

Three enchanted fountains offer magical flasks that help in battle. Each visit grants a potion artifact with three battle charges, replacing one existing flask of the same kind if the hero owns one.

| Fountain | Potion | Effect while equipped | Charges |
| --- | --- | --- | --- |
| Fountain of Fortune | Hydromel Potion | +2 Attack and +2 Defense | 3 |
| Valhalla's Fountain | Berserker Potion | +10 Attack and maximum Luck; the hero cannot cast combat spells | 3 |
| Venus's Fountain | Venus's Blessing | Maximum Morale and Luck, subject to normal creature and battlefield rules | 3 |

## Drinking and refilling

- Visits are free and each fountain can refill its potion on every visit, without a weekly cooldown.
- The Fountain of Fortune retains its usual temporary Luck bonus (-1, +1, +2 or +3, four equally weighted outcomes when the weekly reward is generated). Visiting while the bonus is still active refills the flask without granting another Luck bonus.
- Equip a flask in a miscellaneous artifact slot to use it in battle. Its bonuses are active while equipped, including on the adventure map where applicable. A dose is consumed at battle finalization; an empty flask is removed. A flask in the backpack does not grant its bonuses or consume charges.
- A refill replaces one existing flask; if the hero has obtained extra copies through transfers, it does not consolidate them.

## Differences from original WoG

Original script 17 used hero-local dose counters and a pre-battle drinking dialog. VCMI uses charged artifacts, which can be moved between heroes. Original AI and multiplayer-specific restrictions are not reproduced. The ERM reaction when Hydromel and Berserker are mixed (chance of permanently losing 1 Spell Power, with a minimum base Spell Power of 1) is not implemented. Do not treat this port as mechanically identical to WoG.

The fountain messages adapt ERT 117002, 117003 and 117006; the artifact descriptions adapt ERT 117007–117012. The original mixing warning, hero-specific placeholders, visited hints and pre-battle questions are not displayed because their mechanisms differ.
