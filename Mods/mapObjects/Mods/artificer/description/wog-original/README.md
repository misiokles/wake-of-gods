# Artificer 1.0.2 — original WoG dialogue restoration

Source: WoG 3.59 alpha, `Mods/WoG/ERM/script026.ert` and `script026.erm` (provided archive).

All 47 numbered entries (126000–126046) are preserved in `description/wog-original/script026.ert` (byte-for-byte) and in `description/wog-original/strings.json`. They are also kept under `wake-of-gods.mapobjects.artificer.erm.*` in the English localization catalog. ERM placeholders in those reference strings are intentionally not passed to VCMI. The original menu/help text describes features not currently implemented and must not be displayed as current gameplay instructions.

| Original ERT IDs | VCMI integration |
|---|---|
| 126001, 126034–126036 | Adapted service description; no full service menu |
| 126004 | No matching artifacts |
| 126007, 126031 | All upgrade offers, including Mithril |
| 126040, 126041 | Exchanges and combinations, including Mithril |
| 126008, 126032, 126033 | Resource-specific refusal, if no affordable offer exists and a matching input set is owned |
| 126009, 126011, 126012 | Ready/exhausted tooltips and repeat-visit text (only one accepted service per hero/object/day); fixed original typo “tommorow” and omitted “equipped” because backpack items also qualify |
| 126046 | Success text preserved, not displayed; no post-acceptance message hook in the current native rewardable JSON path |
| Other IDs | Preserved for reference, not connected to nonexistent UI or second transaction |

The message for fewer than 100 movement points is new (VCMI-specific). When several unaffordable recipes match, the first qualifying shortage message is shown; this is not the original WoG selection menu. Recipe terms and visit rules are unchanged. The output artifact name uses native `%s` replacement; the surrendered artifact names are English literals from existing recipes even in Polish. Polish dialogue is a new translation, not an original WoG localization. The full original English help text is preserved but not used as the player guide.

Validation: full port dummy-run exit 0; native transaction regression 12/12 in English and Polish, including all 120 merged recipes, displayed offer text resolution, cancellation, purchase, revisit, daily reset, Mithril and Dragon Eye Ring. Tests capture native dialog payloads, not actual graphical rendering. Not all individual recipes or all refusal branches were independently exercised. No C++ changes to production; the native test harness is separate.
