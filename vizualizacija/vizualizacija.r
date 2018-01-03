library(ggplot2)
library(dplyr)

  #proizvodnja el. energije v EU - količina proizvedene energije po letu v Evropski uniji
  ggplot(tabela1 %>% filter(DRZAVA == 'European Union')) + aes(x = LETO, y = VREDNOST) + geom_bar(stat="identity")
  #proizvodnja el. energije v Evropski uniji po tipu elektrarne - 1990
  ggplot(tabela1 %>% filter(DRZAVA == 'European Union' & LETO == 1990 & VREDNOST > 10000)) + aes(x = TIP, y = VREDNOST, fill=TIP) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #proizvodnja el. energije v Evropski uniji po tipu elektrarne - 2015
  ggplot(tabela1 %>% filter(DRZAVA == 'European Union' & LETO == 2015 & VREDNOST > 10000)) + aes(x = TIP, y = VREDNOST, fill=TIP) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #proizvodnja el. energije v državah Evropske unije v letu 1990
  ggplot(tabela1 %>% filter(LETO == 1990 & DRZAVA != 'European Union' & DRZAVA != "Euro area")) + aes(x = DRZAVA, y = VREDNOST, fill=DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #proizvodnja el. energije v državah Evropske unije v letu 2015
  ggplot(tabela1 %>% filter(LETO == 2015 & DRZAVA != 'European Union' & DRZAVA != "Euro area")) + aes(x = DRZAVA, y = VREDNOST, fill=DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  
  #poraba el. energije v EU - količina porabljene energije po letu v Evropski uniji
  ggplot(tabela2 %>% filter(DRZAVA == 'European Union')) + aes(x = LETO, y = VREDNOST) + geom_bar(stat="identity")
  #poraba el. energije v Evropski uniji - končna poraba v letu 1990
  ggplot(tabela2 %>% filter(LETO == 1990 & TIP == 'Final Energy Consumption' & DRZAVA != 'European Union' & DRZAVA != "Euro area" )) + aes(x = DRZAVA, y = VREDNOST, fill=DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #poraba el. energije v Evropski uniji - končna poraba v letu 2015
  ggplot(tabela2 %>% filter(LETO == 2015 & TIP == 'Final Energy Consumption' & DRZAVA != 'European Union' & DRZAVA != "Euro area" )) + aes(x = DRZAVA, y = VREDNOST, fill=DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #poraba el. energije po sektorju 1990
  ggplot(tabela2 %>% filter(LETO == 1990 & DRZAVA == 'European Union' & TIP != 'Energy Available for Final Consumption' & TIP != 'Final Energy Consumption')) + aes(x = TIP, y = VREDNOST, fill = TIP) + geom_bar(stat="identity")
  #poraba el. energije po sektorju 2015
  ggplot(tabela2 %>% filter(LETO == 2015 & DRZAVA == 'European Union' & TIP != 'Energy Available for Final Consumption' & TIP != 'Final Energy Consumption')) + aes(x = TIP, y = VREDNOST, fill = TIP) + geom_bar(stat="identity")
  
  #proizvodnja energije iz obnovljivih virov - trend po letih
  ggplot(tabela3 %>% filter(DRZAVA == 'European Union')) + aes(x = LETO, y = VREDNOST) + geom_bar(stat="identity")
  #proizvodnja energije iz obnovljivih virov - po državah v letu 1990
  ggplot(tabela3 %>% filter(DRZAVA != 'European Union' & DRZAVA != "Euro area" & LETO == 1990)) + aes(x = DRZAVA, y = VREDNOST, fill=DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #proizvodnja energije iz obnovljivih virov - po državah v letu 2015
  ggplot(tabela3 %>% filter(DRZAVA != 'European Union' & DRZAVA != "Euro area" & LETO == 2015)) + aes(x = DRZAVA, y = VREDNOST, fill=DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #proizvodnja energije iz obnovljivih virov - po produktu leta 1990
  ggplot(tabela3 %>% filter(LETO == 1990 & DRZAVA != 'European Union' & DRZAVA != "Euro area" & PRODUKT != "Solid fuels")) + aes(x = PRODUKT, y = VREDNOST, fill = PRODUKT) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  #proizvodnja energije iz obnovljivih virov - po produktu leta 2015
  ggplot(tabela3 %>% filter(LETO == 2015 & DRZAVA != 'European Union' & DRZAVA != "Euro area" & PRODUKT != "Solid fuels")) + aes(x = PRODUKT, y = VREDNOST, fill = PRODUKT) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  
  #prodaja električnih vozil v EU
  ggplot(tabela4) + aes(x = MODEL, y = VREDNOST, fill = MODEL) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  
  #prodaja električnih vozil v EU - hibridi
  ggplot(tabela5) + aes(x = MODEL, y = VREDNOST, fill = MODEL) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())

  #delež električne energije iz obnovljivih virov - po državah
  ggplot(tabela6 %>% filter(VREDNOST < 100 & DRZAVA != 'European Union' & DRZAVA != "Euro area" )) + aes(x = DRZAVA, y = VREDNOST, fill = DRZAVA) + geom_bar(stat="identity") + theme(axis.text.x=element_blank())
  
  
  
  #stevilo prodanih električnih avtomobilov
  tabela_1 <- tabela4 %>% group_by(LETO) %>% summarize(PRODANI_AVTOMOBILI_EL = sum(VREDNOST))
  tabela_2 <- tabela5 %>% group_by(LETO) %>% summarize(PRODANI_AVTOMOBILI_HIB = sum(VREDNOST))
  tabela_3 <- inner_join(tabela_1, tabela_2, by = c("LETO"))
  tabela_3_num <- apply(tabela_3[, -1], 1, sum)
  tabela_3 <- cbind(PRODANI_AVTOMOBILI = tabela_3_num, tabela_3) 
  prodani_avtomobili <- tabela_3[c(2,3,4,1)]