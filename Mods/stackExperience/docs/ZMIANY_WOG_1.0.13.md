# Stack Experience 1.0.13 — zmiany względem WoG

Wersja po audycie dostarczonego pełnego portu. Źródła odniesienia: WoG 3.59 alpha, WogT1.exe (analiza statyczna), crexpbon.txt. Nie jest to potwierdzenie identyczności z 3.58f.

## Mechaniki

- Messengers: 2–20% szansy na przywołanie 12 żywiołaków przed atakiem, niezależnie od liczebności stosu.
- Fire Messenger: 5–50% szansy po ataku, Basic, moc 3, dwa heksy, 2 rundy, bazowo 40 obrażeń. Hell Steed pozostaje bez zmiany tej mechaniki.
- Ghost Dragon / Blood Dragon: niezależne losowanie Aging z doświadczenia; zachowano bazowe 20% / 50% dostarczonego portu. Historyczna wartość Blood Dragona nie jest rozstrzygnięta.
- Rebirth: Troll 0–3, Phoenix 1–2, Sacred Phoenix 1–4 odrodzenia zależnie od rangi. Sacred Phoenix: 20% stosu początkowego, minimum 1.
- Orb: normalne efekty magiczne i obrażenia bezpośrednie obsługiwane odmiennie; Dispel pozostaje wyjątkiem.
- RECEPTIVE: progi zgodne z wartościami w TXT, a nie z komentarzami; nadal przybliżenie WoG.
- Fear: ujednolicono wpisy aury w kilku jednostkach, odrębny test regresji pozostaje do wykonania.
- Zsynchronizowano tablice w podmodach ikon (11 definicji); usunięto konflikty przestrzeni nazw.

## Wyniki

Pełny dostarczony port przechodzi `vcmiserver --dummy-run` przy aktywnych dostępnych zależnościach. 120 kontrolowanych scenariuszy natywnych zakończono powodzeniem, w tym 2100 ataków w trzech zestawach testowych. Nie przeprowadzono pełnych bitew AI ani testów GUI.

Audyt statyczny: 175/175 definicji powiązanych z WoG, 1567 tablic rang. Spośród 1550 wierszy 833 mają dopasowanie typu i tabeli, 596 to kandydaci wyłącznie na podstawie wektora, 107 to różnice lub transformacje, a 14 wpisów ma zerową progresję. Dziedziczenie poziomu jest przybliżone. Nie wszystkie różnice oznaczają błędy.

## Otwarte

Warianty enchanted (s=4/5/6), Efreet p #66, szczegóły przywołań, geometria i naturalny ruch przez Fire Wall, dokładny historyczny Aging, szczególne interakcje odporności, pełne Fear i pozostałe dopasowania semantyczne. Raport PDF zawiera źródła i ograniczenia. Dowódcy nie są objęci doświadczeniem.

## Instalacja

Wykonaj kopię zapasową i zastąp cały folder wake-of-gods. Nie nakładaj wyłącznie stackExperience, ponieważ zmiany dotyczą także innych podmodów.
