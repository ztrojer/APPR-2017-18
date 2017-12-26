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
  
  
  #trend prodaje električnih avtomobilov v Evropi
  ggplot(tabela5) + aes(x = LETO, y = VREDNOST) + geom_bar(stat="identity") +  theme(axis.text.x=element_blank())

