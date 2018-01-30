require(ggplot2)
require(dplyr)
library(mgcv)

#POVEZAVA MED PRODANIMI ELEKRIČNIMI AVTOMOBILI IN PORABO V TRANSPORTU
#PORABA V TRANSPORTU
  transport <- tabela.panoga %>% filter(TIP == "Final Energy Consumption - Transport")
  transport$DRZAVA <- NULL
  transport$TIP <- NULL
  #ggplot(transport, aes(x = LETO, y = VREDNOST)) + geom_point()
  
  #izračun modela
  tran <- gam(data = transport, VREDNOST ~ s(LETO))
  #summary(tran)
  
  #izris modela
  model1 <- ggplot(transport, aes(x = LETO, y = VREDNOST)) + geom_point() +
    geom_smooth(method = "gam", formula = y ~ s(x), fullrange = TRUE)
  #print(model1)
  
  #predikcija
  nova_poraba <- data.frame(LETO = seq(2016, 2018, 1))
  predict(tran, nova_poraba)
  napoved <- nova_poraba %>% mutate(VREDNOST=predict(tran, .))
  #View(napoved)
  
  #izris napovedi
  model1 <- model1 + geom_point(data=napoved, aes(x = LETO, y = VREDNOST), color ='red', size =2)
  model1 <- model1 + labs(title ="Napoved porabe električne energije v transportu", x = "leto", y = "porabljena energija (PJ)")
  #print(model1)

#PRODANI ELEKTRIČNI AVTOMOBILI
  prodaja_el <- prodani_avtomobili %>% filter(TIP == "PRODANI_AVTOMOBILI_EL")
  prodaja_el$TIP <- NULL
  #ggplot(prodaja_el, aes(x = LETO, y = STEVILO)) + geom_point()
  
  pro1 <- lm(data=prodaja_el, STEVILO ~ LETO)
  #summary(pro1)
  
  model2 <- ggplot(prodaja_el, aes(x=LETO, y=STEVILO)) + geom_point() + geom_smooth(method = "lm")
  #print(model2)
  
  nova_prodaja1 <- data.frame(LETO=seq(2017, 2019, 1))
  predict(pro1, nova_prodaja1)
  napoved2 <- nova_prodaja1 %>% mutate(STEVILO = predict(pro1, .))
  #View(napoved2)
  
  enacba <- function(x) {
    lm_coef <- list(a = round(coef(x)[1], digits = 2),
                    b = round(coef(x)[2], digits = 2),
                    r2 = round(summary(x)$r.squared, digits = 2));
    lm_eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(R)^2~"="~r2,lm_coef)
    as.character(as.expression(lm_eq));                 
  }
  
  model2 <- model2 + geom_point(data=napoved2, aes(x=LETO, y=STEVILO), color="green", size=2) +
    annotate("text", x = 2017, y=50000, label = enacba(pro1), parse=TRUE)
  model2 <- model2 + labs(title ="Napoved prodaje električnih avtomobilov", x = "leto", y = "število avtomobilov")
  #print(model2)
  
#PRODANI HIBRIDI
  prodaja_hib <- prodani_avtomobili %>% filter(TIP == "PRODANI_AVTOMOBILI_HIB")
  prodaja_hib$TIP <- NULL
  #ggplot(prodaja_hib, aes(x = LETO, y = STEVILO)) + geom_point()
  
  pro2 <- lm(data=prodaja_hib, STEVILO ~ LETO)
  #summary(pro2)
  
  model3 <- ggplot(prodaja_hib, aes(x=LETO, y=STEVILO)) + geom_point() + geom_smooth(method = "lm")
  #print(model3)
  
  nova_prodaja2 <- data.frame(LETO=seq(2017, 2019, 1))
  predict(pro2, nova_prodaja2)
  napoved3 <- nova_prodaja2 %>% mutate(STEVILO = predict(pro2, .))
  #View(napoved3)
  
  model3 <- model3 + geom_point(data=napoved3, aes(x=LETO, y=STEVILO), color="green", size=2) +
    annotate("text", x = 2017, y=50000, label = enacba(pro2), parse=TRUE)
  model3 <- model3 + labs(title ="Napoved prodaje hibridnih avtomobilov", x = "leto", y = "število avtomobilov")
  #print(model3)
  
  


#SKUPAJ ELEKTRIČNI IN HIBRIDI  

vse <- bind_cols(napoved2, napoved3)
colnames(vse) <- c("LETO", "elektricni", "LETO", "hibridni")
vse <- melt(vse, id.vars="LETO", variable.name = "LETO", value.name = "STEVILO")
colnames(vse) <- c("LETO", "TIP", "STEVILO")
model4 <- graf3 + geom_smooth(method = "lm", fullrange = TRUE, se = FALSE) +
  ylim(0, 200000) + scale_x_continuous(breaks = seq(2010, 2020, 2))
model4 <- model4 + geom_point(data=vse, aes(x=LETO, y=STEVILO, color=TIP), color="green", size=2) + ggtitle("Napoved prodaje avtomobilov")
model4 <- model4 + annotate("text", x = 2016, y=25000, label = enacba(pro2), parse=TRUE)
model4 <- model4 + annotate("text", x = 2016, y=15000, label = enacba(pro1), parse=TRUE)