## Intonační analýza nahrávek řeči - zadání práce:

<b>Materiál:</b> TextGrids (složka data_tg) a PitchTiers (složka data_pt) nahrávek čtené řeči s textem

Úsek D: „Na znamení protestu sežrala všechno, co našla, a bylo jí pak poněkud nedobře.“
<br> Úsek E: „Po druhé jsem ji zavřel do sklepa s tím výsledkem, že rozkousala dveře.“ 

<b>Značení souborů:</b> idMluvci_pohlaví_věk_úsek.přípona

<b>Úkoly:</b>
<br> 1.) PitchTier – Hz převést na půltóny, změřit a) průměrnou f0 v rámci nahrávky, b) intonační rozpětí (zvolte vhodnou metodu), c) CSI.
<br> 2.) TextGrid – změřit artikulační tempo (syll/s). Nápověda: počet slabik (např. 21) vydělte trváním, které zjistíte jako hodnotu t2 posledního mínus t1 prvního neprázdného intervalu.

Všechny změřené ukazatele vyneste graficky v závislosti na věku a rozdělené podle pohlaví. Přidejte lineární regresi s konfidenčním pásmem pro hladinu významnosti alfa = 0.05. Postupujte tak, abyste se vyhnuli problému pseudoreplikace.
