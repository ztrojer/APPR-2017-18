library(ggplot2)
library(dplyr)


#GRAF 1,2

#katere drzave pridelajo največ električne energije
tabela.1 <- tabela1 %>% group_by_at(vars(DRZAVA, LETO))
tabela.1 <- summarise(tabela.1, SKUPNO = sum(VREDNOST))
filter1 <- tabela.1 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")
skupni_podatki_preb <- left_join(tabela.1, tabela8, by = c("DRZAVA"))
skupni_podatki_preb["PROIZ_NA_PREB"] <- NA
skupni_podatki_preb["PROIZ_NA_POVR"] <- NA
skupni_podatki_preb$PROIZ_NA_PREB <- skupni_podatki_preb$SKUPNO / skupni_podatki_preb$POPULACIJA
skupni_podatki_preb$PROIZ_NA_POVR <- skupni_podatki_preb$SKUPNO / skupni_podatki_preb$POVRSINA

skupni_podatki_preb <- filter(skupni_podatki_preb, POVRSINA != "NA")

top1_preb <- quantile(skupni_podatki_preb$PROIZ_NA_PREB, 0.9)
min1_preb <- quantile(skupni_podatki_preb$PROIZ_NA_PREB, 0.1)

top1_povr <- quantile(skupni_podatki_preb$PROIZ_NA_POVR, 0.9)
min1_povr <- quantile(skupni_podatki_preb$PROIZ_NA_POVR, 0.05)

izbrane_drzave1_preb <- skupni_podatki_preb %>% filter(PROIZ_NA_PREB >= top1_preb)
izbrane_drzave2_preb <- skupni_podatki_preb %>% filter(PROIZ_NA_PREB <= min1_preb)

izbrane_drzave1_povr <- skupni_podatki_preb %>% filter(PROIZ_NA_POVR >= top1_povr)
izbrane_drzave2_povr <- skupni_podatki_preb %>% filter(PROIZ_NA_POVR <= min1_povr)
skupni_podatki_preb$DRZAVA <- gsub("Bosnia and Herzegovina", "BiH",skupni_podatki_preb$DRZAVA)

graf1 <-  ggplot(skupni_podatki_preb %>% filter(DRZAVA %in% izbrane_drzave1_preb$DRZAVA)) + aes(x = LETO, y = PROIZ_NA_PREB, colour = DRZAVA) + geom_line()+ labs(title ="Proizvodnja energije po državah TOP", x = "leto", y = "proizvedena energija na prebivalca")
graf2 <- ggplot(skupni_podatki_preb %>% filter(DRZAVA %in% izbrane_drzave2_preb$DRZAVA)) + aes(x = LETO, y = PROIZ_NA_PREB, colour = DRZAVA) + geom_line() + labs(title ="Proizvodnja energije po državah MIN", x = "leto", y = "proizvedena energija na prebivalca")
graf_skupaj <- grid.arrange(graf1, graf2, ncol = 2)
graf_skupaj1 <- plot_grid(graf1, graf2, labels = "AUTO")

#GRAF 3

#prodaja avtomobilov v Evropski uniji po letih
tabela_1 <- tabela4 %>% group_by(LETO) %>% summarize(PRODANI_AVTOMOBILI_EL = sum(VREDNOST)) 
tabela_2 <- tabela5 %>% group_by(LETO) %>% summarize(PRODANI_AVTOMOBILI_HIB = sum(VREDNOST))
tabela_3 <- inner_join(tabela_1, tabela_2, by = c("LETO"))
tabela_3_num <- apply(tabela_3[, -1], 1, sum)
tabela_3 <- cbind(PRODANI_AVTOMOBILI = tabela_3_num, tabela_3) 
prodani_avtomobili <- tabela_3[c(2,3,4,1)]
prodani_avtomobili$LETO <- parse_number(prodani_avtomobili$LETO)
prodani_avtomobili <- prodani_avtomobili %>% melt(id.vars = 'LETO', variable.name = "TIP", value.name = "STEVILO")

graf3 <- ggplot(prodani_avtomobili) + aes(x = LETO, y = STEVILO, colour = TIP) + geom_line() + labs(title ="Prodaja  električnih avtomobilov", x = "leto", y = "število prodanih avtomobilov")
#GRAF 4

#delež električne energije iz obnovljivih virov
filter2 <- tabela6 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki2 <- filter2 %>% group_by(DRZAVA) %>% summarise(POVPRECJE = mean(VREDNOST))

top2 <- quantile(skupni_podatki2$POVPRECJE, 0.85)

izbrane_drzave3 <- skupni_podatki2 %>% filter(POVPRECJE >= top2)

graf4 <- ggplot(filter2 %>% filter(DRZAVA %in% izbrane_drzave3$DRZAVA)) + aes(x = LETO, y = VREDNOST, colour = DRZAVA) + geom_line() + labs(title ="Delež energije iz zelenih virov", x = "leto", y = "delež energije (%)")

#GRAF 5

#toplotne črpalke
filter3 <- tabela7 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki3 <- filter3 %>% group_by(DRZAVA) %>% summarise(VREDNOST = sum(VREDNOST))
top3 <- quantile(filter3$VREDNOST, 0.8)

izbrane_drzave4 <- skupni_podatki3 %>% filter(VREDNOST > top3)

graf5 <- ggplot(filter3 %>% filter(DRZAVA %in% izbrane_drzave4$DRZAVA)) + aes(x=LETO, y = VREDNOST, colour = DRZAVA) + geom_line()+ labs(title ="Porabljena energija za toplotne črpalke", x = "leto", y = "porabljena energija (TJ)")




