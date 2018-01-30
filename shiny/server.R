library(shiny)

shinyServer(function(input, output) {
  
  output$graf <- renderPlot({
    data <- filter(tabela6,LETO == input$leto)
    
    g <- ggplot(data = data, aes(x = reorder(DRZAVA, -VREDNOST), y = VREDNOST, fill=factor(LETO))) + geom_bar(stat = "identity", position = "dodge") + labs(title ="Delež energije iz obnovljivih virov", x = "država",
                                                                                                                                                           y = "delež energije iz obnovljivih virov", fill = "Leto") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4))
    g <- g + geom_hline(yintercept = 20)
    
    g
  
  })
  
  output$graf1 <- renderPlot({
    data <- left_join(evropa1, 
                      filter2 %>% filter(LETO==input$leto1), by = c("NAME" = "DRZAVA"))
    
    g1 <- ggplot() + geom_polygon(data = data ,aes(x = long, y = lat, group = group, fill = VREDNOST)) +
      coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + labs(title ="", x = "long",
                                                            y = "lat", fill = "Delež")
    g1
})



output$graf2 <- renderPlot({
  data <- filter(tabela1, DRZAVA == input$drzava)
  
  g2 <- ggplot(data = data %>% filter(TIP %in% input$tip),
               aes(x = LETO, y = VREDNOST/1000, color = TIP)) + geom_line(stat = "identity") +
    ylab("Proizvidnja (PJ)")
  g2
})

})