library(mgcv)

# 4. faza: Analiza podatkov

#Oglejmo si trend pridobivanja energije Islandije
#linearna predikcija za leto 2016,2017,2018
pred_isl_lin <- lm(data = skupni_podatki_preb %>% filter(DRZAVA == "Iceland"), PROIZ_NA_PREB ~ LETO)
predict(pred_isl_lin , data.frame(LETO=seq(2016,2018, 1)))

graf_pred_isl <- ggplot(skupni_podatki_preb %>% filter(DRZAVA == "Iceland")) + aes(x = LETO, y = PROIZ_NA_PREB) + geom_point()

#kvadratna predikcija za leto 2016, 2017, 2018
pred_isl_kv <- lm(data = skupni_podatki_preb %>% filter(DRZAVA == "Iceland"), PROIZ_NA_PREB ~ LETO + I(LETO^2))
predict(pred_isl_kv, data.frame(LETO=seq(2016,2018, 1)))
graf_pred_isl_kv <- graf_pred_isl  + geom_smooth(method = "lm", formula = y ~ x + I(x^2))

#kompleksnejši model
islandija <- skupni_podatki_preb %>% filter(DRZAVA == "Iceland")
pred_isl_mls <- loess(data = islandija, PROIZ_NA_PREB ~ LETO)
predict(pred_isl_mls, data.frame(LETO=seq(2016,2018, 1)))
graf_pred_isl_mls <- ggplot(skupni_podatki_preb %>% filter(DRZAVA == "Iceland")) + aes(x = LETO, y = PROIZ_NA_PREB) + geom_point() + geom_smooth(method = "loess")


pred_isl_mgam <- gam(data = islandija, PROIZ_NA_PREB ~ s(LETO))
predict(pred_isl_mgam,data.frame(LETO=seq(2016,2018, 1)))
graf_pred_isl_mgam <- graf_pred_isl + geom_smooth(method = "gam", formula = y ~ s(x))


#Trend prodaje električnih avtomobilov
prodani_avtomobili_el <- prodani_avtomobili %>% filter(TIP == "PRODANI_AVTOMOBILI_EL")
pred_avt <- lm(data = prodani_avtomobili_el, STEVILO ~ LETO)
predict(pred_avt, data.frame(LETO=seq(2016,2020, 1)))
prodani_avtomobili_hib <- prodani_avtomobili %>% filter(TIP == "PRODANI_AVTOMOBILI_HIB")
pred_avt_h <- lm(data = prodani_avtomobili_hib, STEVILO ~ LETO)
predict(pred_avt_h, data.frame(LETO=seq(2016,2020, 1)))



#transport
transport <- tabela.panoga %>% filter(TIP == "Final Energy Consumption - Transport")
pred_tran <- lm(data = transport, VREDNOST ~ LETO)
predict(pred_tran, data.frame(LETO = seq(2016, 2018, 1)))
graf_pred_tran <- ggplot(pred_tran) + aes(x = LETO, y = VREDNOST)+ geom_point() + geom_smooth(method = "loess")