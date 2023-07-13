library(plotly)

# Your code for creating the initial plot
fig <- plot_ly(Library_Language_Statistics, x = ~Language, y = ~Translated, text = ~Language, type = 'scatter', mode = 'markers', marker = list(opacity = 0.5, sizemode = 'diameter'))
fig <- fig %>% layout(title = 'Gender Gap in Earnings per University',
                      xaxis = list(showgrid = FALSE),
                      yaxis = list(showgrid = FALSE),
                      showlegend = TRUE)

# Create a list of buttons for the dropdown menu
buttons <- lapply(unique(Library_Language_Statistics$Library), function(lib) {
  list(
    method = "restyle",
    args = list(
      list(
        x = list(Library_Language_Statistics$Language[Library_Language_Statistics$Library == lib]),
        y = list(Library_Language_Statistics$Translated[Library_Language_Statistics$Library == lib]),
        text = list(paste("Library:", Library_Language_Statistics$Library[Library_Language_Statistics$Library == lib], "<br>",
                          "Language:", Library_Language_Statistics$Language[Library_Language_Statistics$Library == lib], "<br>",
                          "Translated:", Library_Language_Statistics$Translated[Library_Language_Statistics$Library == lib])),
        hovertext = list(paste("Library:", Library_Language_Statistics$Library[Library_Language_Statistics$Library == lib], "<br>",
                               "Language:", Library_Language_Statistics$Language[Library_Language_Statistics$Library == lib], "<br>",
                               "Translated:", Library_Language_Statistics$Translated[Library_Language_Statistics$Library == lib]))  # Update hover text
        marker = list(
          color = "blue"
)
      )
    ),
    label = lib
  )
})

# Add the dropdown menu to the plot
fig <- fig %>% layout(
  updatemenus = list(
    list(
      y = 0.8,
      buttons = buttons
    )
  )
)

fig
