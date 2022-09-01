#Load libraries to be used
library(Matrix)
library(shiny)
library(ggplot2)
library(rsconnect)
library(gridExtra)

#Load count matrix as .rds file. The matrix is compressed to a large dgCMatrix. 
counts_rds_mcl <- readRDS("matrix_mcl.rds")
dim(counts_rds_mcl)
counts_rds_fl <- readRDS("matrix_fl.rds")
dim(counts_rds_fl)
counts_rds_cll <- readRDS("matrix_cll.rds")
dim(counts_rds_cll)
counts_rds_dlbcl <- readRDS("matrix_dlbcl.rds")
dim(counts_rds_dlbcl)

#Extract gene names for drop down menu 
gene_names <- read.csv("all_genes.csv", header=T)
gene_names <- sort(gene_names$x)

#read calculated expression percentages
#mcl
mcl_expression_percentages <- read.csv("gene_percentage_mcl.csv", sep = ",")
rownames(mcl_expression_percentages) <- mcl_expression_percentages$X
#fl
fl_expression_percentages <- read.csv("gene_percentage_fl.csv", sep = ",")
rownames(fl_expression_percentages) <- fl_expression_percentages$X
#cll
cll_expression_percentages <- read.csv("gene_percentage_cll.csv", sep = ",")
rownames(cll_expression_percentages) <- cll_expression_percentages$X
#dlbcl
dlbcl_expression_percentages <- read.csv("gene_percentage_dlbcl.csv", sep = ",")
rownames(dlbcl_expression_percentages) <- dlbcl_expression_percentages$X


server <- function(input, output) {
  
  DataInput1 <- reactive({
    
    #Read data file containing UMAP coordinates and prepare the dataframe  
    umap_coords <- read.csv("umap_coordinates_mcl.csv") 
    rownames(umap_coords) <- umap_coords[,1]
    umap_coords <- umap_coords[, 2:3]
    
    #The gene is given as an input by the user 
    gene <- input$gene
    
    #Extract the counts from the gene of interest 
    spec_gene <- counts_rds_mcl[gene,]
    
    #Cind the counts to the UMAP coordinates to create the the final data frame to be used for the plot 
    df_mcl <- cbind(umap_coords, Expression = spec_gene)
    
    return(df_mcl)
    
  })
  
  DataInput2 <- reactive({
    
    #Read data file containing UMAP coordinates and prepare the dataframe  
    umap_coords <- read.csv("umap_coordinates_fl.csv") 
    rownames(umap_coords) <- umap_coords[,1]
    umap_coords <- umap_coords[, 2:3]
    
    #The gene is given as an input by the user 
    gene <- input$gene
    
    #Extract the counts from the gene of interest 
    spec_gene <- counts_rds_fl[gene,]
    
    #Cind the counts to the UMAP coordinates to create the the final data frame to be used for the plot 
    df_fl <- cbind(umap_coords, Expression = spec_gene)
    
    return(df_fl)
    
  }) 
  
  DataInput3 <- reactive({
    
    #Read data file containing UMAP coordinates and prepare the dataframe  
    umap_coords <- read.csv("umap_coordinates_cll.csv") 
    rownames(umap_coords) <- umap_coords[,1]
    umap_coords <- umap_coords[, 2:3]
    
    #The gene is given as an input by the user 
    gene <- input$gene
    
    #Extract the counts from the gene of interest 
    spec_gene <- counts_rds_cll[gene,]
    
    #Cind the counts to the UMAP coordinates to create the the final data frame to be used for the plot 
    df_cll <- cbind(umap_coords, Expression = spec_gene)
    
    return(df_cll)
    
  }) 
  
  DataInput4 <- reactive({
    
    #Read data file containing UMAP coordinates and prepare the dataframe  
    umap_coords <- read.csv("umap_coordinates_dlbcl.csv") 
    rownames(umap_coords) <- umap_coords[,1]
    umap_coords <- umap_coords[, 2:3]
    
    #The gene is given as an input by the user 
    gene <- input$gene
    
    #Extract the counts from the gene of interest 
    spec_gene <- counts_rds_dlbcl[gene,]
    
    #Cind the counts to the UMAP coordinates to create the the final data frame to be used for the plot 
    df_dlbcl <- cbind(umap_coords, Expression = spec_gene)
    
    return(df_dlbcl)
    
  }) 
  
  plotInput1 <- reactive({
    
    gene <- input$gene
    plot <- ggplot(DataInput1(), aes(x=UMAP_1, y=UMAP_2, color= Expression)) + 
      geom_point() + 
      theme_classic() + 
      scale_color_gradient(low="light grey", high="black") +
      xlim(-7, 7) + 
      ylim(-9, 6) +
      labs(x="UMAP 1", y = "UMAP 2", title = paste(gene, "expression - Mantle cell lymphoma (MCL)")) +
      theme(
        axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 14, margin=margin(b = 10, unit = "pt")),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 14, margin=margin(b = 20, unit = "pt"), hjust = 0.5, face = "bold")) +
      annotate("label", 
               x = 4, 
               y = -6, 
               label = paste("Positive cells: ", paste(mcl_expression_percentages[gene, ]$Percentage_positive, "%", sep = ""), sep = ""))
      
    print(plot)
    
  })
  
  plotInput2 <- reactive({
    
    gene <- input$gene
    plot <- ggplot(DataInput2(), aes(x=UMAP_1, y=UMAP_2, color= Expression)) + 
      geom_point() + 
      theme_classic() + 
      scale_color_gradient(low="light grey", high="red") + 
      labs(x="UMAP 1", y = "UMAP 2", title = paste(gene, "expression - Follicular lymphoma (FL)")) +
      xlim(-7, 2.4) + 
      ylim(-6, 5) +
      theme(
        axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 14, margin=margin(b = 10, unit = "pt")),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 14, margin=margin(b = 20, unit = "pt"), hjust = 0.5, face = "bold")) + 
      annotate("label", 
               x = -5, 
               y = -5, 
               label = paste("Positive cells: ", paste(fl_expression_percentages[gene, ]$Percentage_positive, "%", sep = ""), sep = ""))
    
    print(plot)
    
  })
  
  plotInput3 <- reactive({
    
    gene <- input$gene
    plot <- ggplot(DataInput3(), aes(x=UMAP_1, y=UMAP_2, color= Expression)) + 
      geom_point() + 
      theme_classic() +  
      scale_color_gradient(low="light grey", high="blue") + 
      labs(x="UMAP 1", y = "UMAP 2", title = paste(gene, "expression - Chronic lymphocytic leukemia (CLL)")) +
      xlim(-6, 6) + 
      ylim(-6, 4) +
      theme(
        axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 14, margin=margin(b = 10, unit = "pt")),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 14, margin=margin(b = 20, unit = "pt"), hjust = 0.5, face = "bold")) + 
      annotate("label", 
               x = 4, 
               y = -5, 
               label = paste("Positive cells: ", paste(cll_expression_percentages[gene, ]$Percentage_positive, "%", sep = ""), sep = ""))
    
    print(plot)
    
  })
  
  plotInput4 <- reactive({
    
    gene <- input$gene
    plot <- ggplot(DataInput4(), aes(x=UMAP_1, y=UMAP_2, color= Expression)) + 
      geom_point() + 
      theme_classic() + 
      scale_color_gradient(low="light grey", high="green") + 
      labs(x="UMAP 1", y = "UMAP 2", title = paste(gene, "expression - Diffuse large B cell lymphoma (DLBCL)")) +
      theme(
        axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 14, margin=margin(b = 10, unit = "pt")),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 14, margin=margin(b = 20, unit = "pt"), hjust = 0.5, face = "bold")) + 
      annotate("label", 
               x = -5, 
               y = -6, 
               label = paste("Positive cells: ", paste(dlbcl_expression_percentages[gene, ]$Percentage_positive, "%", sep = ""), sep = ""))
    
    print(plot)
    
  })
 
  
  #
  #All of the outputs generated from this script 
  #
  
  #Plot for the normalized expression 
  output$plot1 <- renderPlot({
    
    grid.arrange(plotInput1(),plotInput2(),plotInput3(),plotInput4(), ncol=2)
    
  })
}