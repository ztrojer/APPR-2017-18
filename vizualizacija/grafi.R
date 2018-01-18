library(ggplot2)
library(dplyr)


#GRAF 1,2

#katere drzave pridelajo največ električne energije
tabela.1 <- tabela1 %>% group_by_at(vars(DRZAVA, LETO))
tabela.1 <- summarise(tabela.1, SKUPNO = sum(VREDNOST))

filter1 <- tabela.1 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki1 <- filter1 %>% group_by(DRZAVA) %>% summarise(SKUPNO = sum(SKUPNO))

top1 <- quantile(skupni_podatki1$SKUPNO, 0.9)
min1 <- quantile(skupni_podatki1$SKUPNO, 0.1)

izbrane_drzave1 <- skupni_podatki1 %>% filter(SKUPNO >= top1)
izbrane_drzave2 <- skupni_podatki1 %>% filter(SKUPNO <= min1)

graf1 <-  ggplot(tabela.1 %>% filter(DRZAVA %in% izbrane_drzave1$DRZAVA)) + aes(x = LETO, y = SKUPNO, colour = DRZAVA) + geom_line() + ggtitle("PROIZVONJA ENERGIJE PO DRŽAVAH TOP 4")
graf2 <- ggplot(tabela.1 %>% filter(DRZAVA %in% izbrane_drzave2$DRZAVA)) + aes(x = LETO, y = SKUPNO, colour = DRZAVA) + geom_line()

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


graf3 <- ggplot(prodani_avtomobili) + aes(x = LETO, y = STEVILO, colour = TIP) + geom_line() + ggtitle("PRODAJA ELEKTRIČNIH AVTOMOBILOV V EU")

#GRAF 4

#delež električne energije iz obnovljivih virov
filter2 <- tabela6 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki2 <- filter2 %>% group_by(DRZAVA) %>% summarise(POVPRECJE = mean(VREDNOST))

top2 <- quantile(skupni_podatki2$POVPRECJE, 0.85)

izbrane_drzave3 <- skupni_podatki2 %>% filter(POVPRECJE >= top2)

graf4 <- ggplot(filter2 %>% filter(DRZAVA %in% izbrane_drzave3$DRZAVA)) + aes(x = LETO, y = VREDNOST, colour = DRZAVA) + geom_line() + ggtitle("DELEŽ ELEKTRIČNE ENERGIJE IZ OBNOVLJIVIH VIROV")

#GRAF 5

#toplotne črpalke
filter3 <- tabela7 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki3 <- filter3 %>% group_by(DRZAVA) %>% summarise(VREDNOST = sum(VREDNOST))
top3 <- quantile(filter3$VREDNOST, 0.8)

izbrane_drzave4 <- skupni_podatki3 %>% filter(VREDNOST > top3)

graf5 <- ggplot(filter3 %>% filter(DRZAVA %in% izbrane_drzave4$DRZAVA)) + aes(x=LETO, y = VREDNOST, colour = DRZAVA) + geom_line() + ggtitle("PORABLJENA ENERGIJA ZA TOPLOTNE ČRPALKE")




