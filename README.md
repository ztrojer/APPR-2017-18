# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2016/17

## Analiza proizvedene električne energije

Raziskoval bom proizvodnjo in porabo električne energije v Sloveniji in Evropi. Raziskoval bom, kako vpliva vse večje vključevanje "zelenih" porabnikov energije - električnih vozil in toplotnih črpalk na proizvodnjo energije. Opazoval bom trend trajnostne energije. Zanimajo me države, ki najbolj zmanjšujejo odvisnost od fosilnih virov energije ter zagotavljajo možnosti za zmanjševanje toplogrednih plinov.

Odgovoril bom na naslednja vprašanja:
1. Kako bo prodaja električnih vozil vplivala na proizvodnjo električne energije,
2. iz katerih virov bo proizvedene največ energije čez določeno obdobje,
3. kdaj se lahko spet pojavi energetska kriza (električna energija).

### Podatkovni viri 

1. http://www.energetika-portal.si/statistika/ (.CSV)
2. http://pxweb.stat.si/pxweb/Database/Okolje/Okolje.asp#18 (.CSV)
3. https://www.destatis.de/EN/FactsFigures/EconomicSectors/Energy/Production/Tables/TablesElectricity.html (.HTML)
4. http://ec.europa.eu/eurostat/web/energy/data/main-tables (.CSV)
5. https://www.eles.si/trzni-podatki (.CSV)

### Podatkovni model

#### Tabela 1: proizvedena električna energija po proizvodnih delih v Evropi in Sloveniji 
(država, vrsta elektrarne, leto, proizvedena energija)
#### Tabela 2: poraba električne energije po panogi
(država, panoga, leto, porabljena energija)
#### Tabela 3: poraba energije v največjih slovenskih in evropskih podjetjih
(podjetje, država, leto, poraba, porabljena energija)
#### Tabela 4: prodaja električnih vozil v Evropi
(država, model vozila, poraba energije, število)

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
