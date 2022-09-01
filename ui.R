#Load libraries to be used 
library(Matrix)
library(shiny)
library(ggplot2)
library(rsconnect)
library(gridExtra)

#Extract gene names for drop down menu 
gene_names <- read.csv("all_genes.csv", header=T)
gene_names <- sort(gene_names$x)


ui <- fluidPage(
  
  titlePanel(title = span("The B cell cancer scRNA-seq visualization app, (v2)"), windowTitle = "Single cell RNA-seq analysis"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("gene", "Please enter a gene of interest (Examples: CD19, MS4A1, TNFRSF13C):", gene_names),
      strong("Mantle cell lymphoma (MCL) - Hansen, S. V., et al. (2021)"),
      p("scRNA-seq of sorted CD19+ MCL patient cells."),
      p("Mantle cell lymphoma cells were collected from bone marrow samples from 8 patients and sorted for CD19. cDNA libraries were prepared using the 10X Chromium platform and sequenced using the NovaSeq 6000 platform."),
      p("A total of 27.067 mantle cell lymphoma/B cells were included for the plot."),
      strong("Follicular lymphoma (FL) - Roider, T., et al. (2020)"),
      p("scRNA-seq of lymph node derived FL patient cells."),
      p("Cells were derived from lymph nodes from 4 patients. cDNA libraries were prepared using the 10X Chromium platform and sequenced using the NextSeq 550 platform. T cells, monocytes and dendritic cells were cleared from the data set based on clustering and expressional analysis."),
      p("A total of 12.219 follicular lymphoma/B cells were included for the plot."),
      strong("Chronic lymphocytic leukemia (CLL) - Rendeiro, A.F., et al. (2020)"),
      p("scRNA-seq of PBMCs derived from CLL patients."),
      p("Chronic lymphocytic leukemia cells were collected from PBMC samples from 4 patients. cDNA libraries were prepared using the 10X Chromium platform and sequenced using the HiSeq 3000/4000 platform. Several other mononuclear cells were cleared from the data set based on clustering and expressional analysis."),
      p("A total of 11.160 chronic lymphocytic leukemia/B cells were included for the plot."),
      strong("Diffuse large B cell lymphoma (DLBCL) - Roider, T., et al. (2020)"),
      p("scRNA-seq of lymph node derived DLBCL patient cells."),
      p("Cells were derived from lymph nodes from 3 patients. cDNA libraries were prepared using the 10X Chromium platform and sequenced using the NextSeq 550 platform. T cells, monocytes and dendritic cells were cleared from the data set based on clustering and expressional analysis."),
      p("A total of 11.257 diffuse large B cell lymphoma/B cells were included for the plot."),
      strong(""),
      strong(""),
      strong("Cells were assigned as positive for a gene if >0.01% of total reads belonged to that gene."),
      width = 4
    ),
    
    mainPanel(
      plotOutput("plot1", width = "1400px", height = "1000px"),
    )
  )
)