#uvoz zemljevida
evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Turkey", "Cyprus"),
                                  long > -30)
#zemljevid brez podatkov
ggplot() + geom_polygon(data = evropa, aes(x = long, y = lat, group = group)) + coord_map(xlim = c(-25, 40), ylim = c(32, 72))


#poskrbim, da se imena držav (oziroma po čemer združujem), ujemajo
evropa1 <- evropa 
tabela.1$DRZAVA <- gsub("Czech Republic", "Czechia", tabela.1$DRZAVA)
tabela.1$DRZAVA <- gsub("Bosnia and Herzegovina", "Bosnia and Herz.", tabela.1$DRZAVA)  
filter2$DRZAVA <- gsub("Czech Republic", "Czechia", filter2$DRZAVA)
filter2$DRZAVA <- gsub("Bosnia and Herzegovina", "Bosnia and Herz.", filter2$DRZAVA)  
evropa1$NAME <- gsub("Serbia", "Former Yugoslav", evropa1$NAME)
evropa1$NAME <- gsub("Bosnia and Herz.", "Former Yugoslav", evropa1$NAME)
evropa1$NAME <- gsub("Albania", "Former Yugoslav", evropa1$NAME)
evropa1$NAME <- gsub("Montenegro", "Former Yugoslav", evropa1$NAME)
evropa1$NAME <- gsub("Macedonia", "Former Yugoslav", evropa1$NAME)
evropa1$NAME <- gsub("Kosovo", "Former Yugoslav", evropa1$NAME)


#narisem zemljevide

#Po proizvodnji električne energije
zemljevid1 <- ggplot() + geom_polygon(data = left_join(evropa, 
                                                      tabela.1,
                                                      by = c("NAME" = "DRZAVA")),
                                     aes(x = long, y = lat, group = group, fill = SKUPNO)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72))

#Po deležu električne energije iz obnovljivih virov
zemljevid2 <- ggplot() + geom_polygon(data = left_join(evropa1, 
                                                       filter2,
                                                       by = c("NAME" = "DRZAVA")),
                                      aes(x = long, y = lat, group = group, fill = VREDNOST)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72))