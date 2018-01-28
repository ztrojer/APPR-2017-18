#uvoz zemljevida
evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Turkey", "Cyprus"),
                                  long > -30)
#zemljevid brez podatkov
#ggplot() + geom_polygon(data = evropa, aes(x = long, y = lat, group = group)) + coord_map(xlim = c(-25, 40), ylim = c(32, 72))


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

#Po proizvodnji električne energije na prebivalca
zemlj_1 <- tabela.1 %>% group_by(DRZAVA) %>% summarise(SKUPAJ = sum(SKUPNO))
tabela8$DRZAVA <- gsub("Czech Republic", "Czechia", tabela8$DRZAVA )
zemlj_1 <- inner_join(zemlj_1, tabela8, by = c("DRZAVA"))
zemlj_1["PROIZ_NA_PREB"] <- NA
zemlj_1$PROIZ_NA_PREB <- zemlj_1$SKUPAJ / zemlj_1$POPULACIJA
zemlj_1$SKUPAJ <- NULL
zemlj_1$POVRSINA <- NULL
zemlj_1$POPULACIJA <- NULL
zemlj_1$DRZAVA <- gsub("Czech Republic", "Czechia", zemlj_1$DRZAVA)

zemljevid1 <- ggplot() + geom_polygon(data = left_join(evropa, zemlj_1,
                                                       by = c("NAME" = "DRZAVA")),
                                      aes(x = long, y = lat, group = group, fill = PROIZ_NA_PREB)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + labs(title ="Proizvodnja električne energije na prebivalca", x = "long", y = "lat", fill = "TJ na prebivalca")

#Po deležu električne energije iz obnovljivih virov
filter5 <- filter2 %>% filter(LETO == 2004)
zemljevid2 <- ggplot() + geom_polygon(data = left_join(evropa1, 
                                                       filter5,
                                                       by = c("NAME" = "DRZAVA")),
                                      aes(x = long, y = lat, group = group, fill = VREDNOST)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + labs(title ="Delež el. energije iz obnovljivih virov 2004", x = "long", y = "lat", fill = "Delež (%)")
zemljevid2 <- zemljevid2 + scale_fill_gradient(low = "brown3", high = "green", guide = "colourbar")

filter6 <- filter2 %>% filter(LETO == 2016)
zemljevid3 <- ggplot() + geom_polygon(data = left_join(evropa1, 
                                                       filter6,
                                                       by = c("NAME" = "DRZAVA")),
                                      aes(x = long, y = lat, group = group, fill = VREDNOST)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + labs(title ="Delež el. energije iz obnovljivih virov 2016", x = "long", y = "lat", fill = "Delež (%)")
zemljevid3 <- zemljevid3 + scale_fill_gradient(low = "brown3", high = "green", guide = "colourbar")

