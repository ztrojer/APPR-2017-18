# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2016/17

## Analiza proizvedene električne energije

Raziskoval bom proizvodnjo električne energije v Sloveniji. Raziskal bom, iz katerih virov je proizvedena električna energija v Sloveniji in to primerjal s proizvodnjo električne energije v Evropi. Opazoval bom porabo energije po panogi (znotraj gospodarstva) in poraba električne energije za namen segrevanje objekta - toplotne črpalke. Skušal bom odgovoriti na naslednja vprašanja:
1. koliko energije bi morali proizvesti (oz. ali je imamo že dovolj), če bi na cestah vozilo vse več električnih avtomobilov
2. koloko energije bi morali proizvesti, če bi vse več gospodinjstev imelo toplotne črpalke.

### Podatkovni viri 
1. http://www.energetika-portal.si/statistika/ (.CSV)
2. http://pxweb.stat.si/pxweb/Database/Okolje/Okolje.asp#18 (.CSV)
3. https://www.destatis.de/EN/FactsFigures/EconomicSectors/Energy/Production/Tables/TablesElectricity.html (.HTML)
4. http://ec.europa.eu/eurostat/web/energy/data/main-tables (.CSV)
5. https://www.eles.si/trzni-podatki (.CSV)

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
