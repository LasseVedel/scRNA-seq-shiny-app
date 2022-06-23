#Load libraries to be used 
library(Matrix)
library(shiny)
library(ggplot2)

#Load count matrix as .rds file. The matrix is compressed to a large dgCMatrix. 
counts_rds <- readRDS("mcl_count_matrix.rds")

#Extract gene names for drop down meny 
gene_names <- sort(colnames(counts_rds))

#read calculated expression percentages 
expression_percentages <- read.csv("gene_percentage.csv", sep = ",")
rownames(expression_percentages) <- expression_percentages$X


ui <- fluidPage(
  
  titlePanel(title = span(img(src = "citco.png", height = 35), "Single cell RNA-seq analysis"), windowTitle = "Single cell RNA-seq analysis"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("gene", "Please enter a gene of interest (Examples: CD19, MS4A1, TNFRSF13C):", gene_names),
      strong("scRNA-seq of sorted CD19+ MCL patient cells."),
      p("The data is from Hansen, S. V., et al. (2021)."),
      p("Mantle cell lymphoma cells were collected from bone marrow samples from 8 patients and sorted for CD19. cDNA libraries were prepared using the 10X Chromium platform and sequenced using NovaSeq 6000."),
      p("A total of 30.565 cells were included in the dataset."),
      width = 4
    ),
    
    mainPanel(
      plotOutput("plot1", width = "700px"),
      downloadButton("dndPlot1", "Download plot"),
    )
  )
)
