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
min1_preb <- quantile(skupni_podatki_preb$PROIZ_NA_PREB, 0.05)

top1_povr <- quantile(skupni_podatki_preb$PROIZ_NA_POVR, 0.9)
min1_povr <- quantile(skupni_podatki_preb$PROIZ_NA_POVR, 0.05)

izbrane_drzave1_preb <- skupni_podatki_preb %>% filter(PROIZ_NA_PREB >= top1_preb)
izbrane_drzave2_preb <- skupni_podatki_preb %>% filter(PROIZ_NA_PREB <= min1_preb)
izbrane_drzave2_preb <- izbrane_drzave2_preb %>% filter(DRZAVA != "Estonia")
izbrane_drzave1_povr <- skupni_podatki_preb %>% filter(PROIZ_NA_POVR >= top1_povr)
izbrane_drzave2_povr <- skupni_podatki_preb %>% filter(PROIZ_NA_POVR <= min1_povr)
skupni_podatki_preb$DRZAVA <- gsub("Bosnia and Herzegovina", "BiH",skupni_podatki_preb$DRZAVA)

graf1 <-  ggplot(skupni_podatki_preb %>% filter(DRZAVA %in% izbrane_drzave1_preb$DRZAVA)) + aes(x = LETO, y = PROIZ_NA_PREB, colour = DRZAVA) + geom_line()+ labs(title ="", x = "leto", y = "proizvedena energija na prebivalca", color = "Država") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
graf2 <- ggplot(skupni_podatki_preb %>% filter(DRZAVA %in% izbrane_drzave2_preb$DRZAVA)) + aes(x = LETO, y = PROIZ_NA_PREB, colour = DRZAVA) + geom_line() + labs(title ="", x = "leto", y = "", color = "Država") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
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

graf3 <- ggplot(prodani_avtomobili %>% filter(TIP != "PRODANI_AVTOMOBILI")) + aes(x = LETO, y = STEVILO, color= factor(TIP, labels = c("Električni", "Hibrid"))) + geom_line() + labs(title ="Prodaja  električnih avtomobilov", x = "leto", y = "število prodanih avtomobilov", color = "Tip avtomobila")+ theme(axis.text.x = element_text(angle = 90, hjust = 1))
#GRAF 4

#delež električne energije iz obnovljivih virov
filter2 <- tabela6 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki2 <- filter2 %>% group_by(DRZAVA) %>% summarise(POVPRECJE = mean(VREDNOST))

top2 <- quantile(skupni_podatki2$POVPRECJE, 0.85)

izbrane_drzave3 <- skupni_podatki2 %>% filter(POVPRECJE >= top2)

graf4 <- ggplot(filter2 %>% filter(DRZAVA %in% izbrane_drzave3$DRZAVA)) + aes(x = LETO, y = VREDNOST, color = DRZAVA) + geom_line() + labs(title ="Delež energije iz zelenih virov", x = "leto", y = "delež energije (%)", color ="Država")

#GRAF 5

#toplotne črpalke
filter3 <- tabela7 %>% filter(DRZAVA != "Euro area" & DRZAVA != "European Union")

skupni_podatki3 <- filter3 %>% group_by(DRZAVA) %>% summarise(VREDNOST = sum(VREDNOST))
top3 <- quantile(filter3$VREDNOST, 0.8)

izbrane_drzave4 <- skupni_podatki3 %>% filter(VREDNOST > top3)

graf5 <- ggplot(filter3 %>% filter(DRZAVA %in% izbrane_drzave4$DRZAVA)) + aes(x=LETO, y = VREDNOST, color = DRZAVA) + geom_line()+ labs(title ="Porabljena energija za toplotne črpalke", x = "leto", y = "porabljena energija (TJ)", color ="Država")

#GRAF 6 in 7

#poraba električne energije po panogi
tabela.panoga <- tabela2 %>% filter(DRZAVA == "European Union")
top_panoga <- quantile(tabela.panoga$VREDNOST, 0.7)
izbrane_panoge <- tabela.panoga %>% filter(VREDNOST > top_panoga)
izbrane_panoge <- izbrane_panoge %>% filter(TIP != "Energy Available for Final Consumption" & TIP != "Final Energy Consumption" & TIP != "Consumption in Energy Sector")
tabela.panoga <- tabela.panoga %>% filter(TIP %in% izbrane_panoge$TIP)
tabela.panoga$VREDNOST <- (tabela.panoga$VREDNOST)/1000
graf6 <- ggplot(tabela.panoga) + aes(x=LETO, y = VREDNOST, fill = factor(TIP, labels = c("Industrija", "Drugi sektorji", "Transport"))) + geom_area() + labs(title ="Poraba elektične energije po panogi", x = "leto", y = "porabljena energija (PJ)", fill = "Panoga")

graf7 <- ggplot(tabela.panoga %>% filter(TIP == "Final Energy Consumption - Transport")) + aes(x =LETO, y = VREDNOST, color = factor(TIP, labels = "Transport")) + geom_point()+ labs(title ="Poraba električne energije v transportu", x = "leto", y = "porabljena energija (PJ)", color ="") + geom_smooth(method = "loess") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
graf_skupaj2 <- plot_grid(graf3, graf7, labels = "")

#GRAF 8

#delež energije iz obnovljivih virov
tabela_obn <- tabela6 %>% filter(LETO == 2004 | LETO == 2016)
tabela_obn <- tabela_obn %>% filter(DRZAVA != "Malta" & DRZAVA !=  "Luxembourg" & DRZAVA !=  "Former Yugoslav")

graf8 <- ggplot(tabela_obn, aes(x = reorder(DRZAVA, -VREDNOST), y = VREDNOST, fill=factor(LETO))) + geom_bar(stat = "identity", position = "dodge") + labs(title ="Delež energije iz obnovljivih virov", x = "država",
                                                                                                                                       y = "delež energije iz obnovljivih virov", fill = "Leto") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4))
graf8 <- graf8 + geom_hline(yintercept = 20)
