library(Matrix)
library(shiny)
library(ggplot2)


server <- function(input, output) {
  
  DataInput <- reactive({
    
    #Read data file containing UMAP coordinates and prepare the dataframe  
    umap_coords <- read.csv("umap_coordinates.csv") 
    rownames(umap_coords) <- umap_coords[,1]
    umap_coords <- umap_coords[, 2:3]
    
    #The gene is given as an input by the user 
    gene <- input$gene
    
    #Extract the counts from the gene of interest 
    spec_gene <- counts_rds[,gene]
    
    #Cind the counts to the UMAP coordinates to create the the final data frame to be used for the plot 
    df <- cbind(umap_coords, Expression = spec_gene)
    
    return(df)
    
  }) 
  
  plotInput1 <- reactive({
    
    gene <- input$gene
    plot <- ggplot(DataInput(), aes(x=UMAP_1, y=UMAP_2, color= Expression)) + 
      geom_point() + 
      theme_classic() + 
      scale_color_gradient(low="light grey", high="red") + 
      labs(x="UMAP 1", y = "UMAP 2", title = paste("Normalized expression of", gene)) +
      theme(
        axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 14, margin=margin(b = 10, unit = "pt")),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 14, margin=margin(b = 20, unit = "pt"))) + 
      annotate("label", 
               x = 12, 
               y = -8, 
               label = paste("Positive cells: ", paste(expression_percentages[gene, ]$Percentage_positive, "%", sep = ""), sep = ""))
    
    print(plot)
    
  })
  
  #
  #All of the outputs generated from this script 
  #
  
  #Plot for the normalized expression 
  output$plot1 <- renderPlot({
    print(plotInput1())
    ggsave("plot1.png", plotInput1(), dpi = 300)
  })
  
}
