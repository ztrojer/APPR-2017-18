#uvoz zemljevida
evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Turkey", "Cyprus"),
                                  long > -30)
#zemljevid brez podatkov
ggplot() + geom_polygon(data = evropa, aes(x = long, y = lat, group = group)) + coord_map(xlim = c(-25, 40), ylim = c(32, 72))
