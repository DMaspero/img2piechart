library(shiny)
library(imager)
library(ggplot2)
library(scatterpie)
library(dplyr)
library(tidyr)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Image 2 piecharts"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          fileInput("imgF", "Choose image",
                    multiple = FALSE,
                    accept = c("jpge","jpg","png")),

            sliderInput("nclust",
                        "Color cluster #:",
                        min = 2,
                        max = 30,
                        value = 5),

            sliderInput("diameter",
                        "piechart diameter:",
                        min = 5,
                        max = 100,
                        value = 30),
          downloadButton('export', label = "Export piechart (PDF)")
        ),
        # Show a plot of the generated distribution
        mainPanel(
          fluidRow(
            splitLayout(cellWidths = c("50%", "50%"), plotOutput("baseImg"), plotOutput("clusteredImg"))
          ),
           plotOutput("piechart")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    IMGdata <- reactive({

      req(input$imgF)

      IMG <- imager::load.image(file = input$imgF$datapath)

      })

    output$baseImg <- renderPlot({

        plot(IMGdata(), axes = FALSE, main = "Source image")

    })

    IMGclustered <- reactive({

      IMG <- IMGdata()

      pixelInfo <- data.frame(matrix(data = NA,
                                     nrow = (dim(IMG)[1]*dim(IMG)[2]),
                                     ncol = 6))
      colnames(pixelInfo) <- c("idx","x","y", "R", "G", "B")

      pixelInfo$R <- as.vector(imager::R(IMG))
      pixelInfo$G <- as.vector(imager::G(IMG))
      pixelInfo$B <- as.vector(imager::B(IMG))

      pixelInfo$idx <- 1:(dim(IMG)[1]*dim(IMG)[2])

      pixelInfo$x <- ((pixelInfo$idx-1) %% dim(IMG)[1]) + 1
      pixelInfo$y <- floor((pixelInfo$idx-1) / dim(IMG)[1]) + 1

      ColorCluster <- kmeans(pixelInfo[,c("R","G","B")],
                             centers = input$nclust,
                             nstart = 1)

      pixelInfo$cluster <- ColorCluster$cluster

      imager::R(IMG)[,,1,1] <- matrix(data = ColorCluster$centers[ColorCluster$cluster,"R"],
                              nrow = dim(IMG)[1])
      imager::G(IMG)[,,1,1] <- matrix(data = ColorCluster$centers[ColorCluster$cluster,"G"],
                              nrow = dim(IMG)[1])
      imager::B(IMG)[,,1,1] <- matrix(data = ColorCluster$centers[ColorCluster$cluster,"B"],
                              nrow = dim(IMG)[1])

      list(img = IMG,
           colorCluster = ColorCluster,
           pixelInfo = pixelInfo)
    })

    output$clusteredImg <- renderPlot({

      plot(IMGclustered()$img, axes = FALSE, main = "Color clusters")

    })


    finalInfo <- reactive({

      diameter <- input$diameter
      pixelInfo <- IMGclustered()$pixelInfo
      colorCluster <- IMGclustered()$colorCluster

      pixelInfo$binN <- ceiling(pixelInfo$x/diameter) + (floor(pixelInfo$y / diameter) * ceiling(max(pixelInfo$x) / diameter))

      binInfoA <- pixelInfo %>%
        group_by(binN) %>%
        count(cluster) %>%
        pivot_wider(names_from = cluster,
                    values_from = n,
                    names_sort = TRUE,
                    values_fill = 0)
      binInfoB <- pixelInfo %>% group_by(binN) %>% summarise_at(vars(x,y), list(name = mean))
      #Fix bottom and right lines
      # right
      mR <- max(binInfoB$x_name)
      mR2 <- max(binInfoB$x_name[binInfoB$x_name < mR])
      binInfoB$x_name[binInfoB$x_name == mR] <- (mR2 + diameter)
      # bottom
      mR <- max(binInfoB$y_name)
      mR2 <- max(binInfoB$y_name[binInfoB$y_name < mR])
      binInfoB$y_name[binInfoB$y_name == mR] <- (mR2 + diameter)

      binInfoM <- merge(binInfoA,binInfoB, by = "binN")

      # Pie charts
      colorList <- rgb(colorCluster$centers)
      names(colorList) <- as.character(1:input$nclust)

      list(binInfo = binInfoM,
           colorList = colorList)


    })

    piechartPlot <- reactive({

      PCplot <- ggplot2::ggplot() +
        scatterpie::geom_scatterpie(ggplot2::aes(x=x_name, y=y_name, group=binN, r = (input$diameter/2)),
                                    data=finalInfo()$binInfo,
                                    cols = as.character(1:input$nclust),
                                    color=NA) +
        ggplot2::scale_fill_manual(values = finalInfo()$colorList, "Colors") +
        ggplot2::coord_equal() +
        ggplot2::scale_y_reverse() +
        ggplot2::theme_void()

      PCplot

    })

    output$piechart <- renderPlot({

      piechartPlot()

    })


    output$export <- downloadHandler(
      filename = "piechart.pdf",
      content = function(file) {
        ggsave(file, plot = piechartPlot(), device = "pdf")
      }
    )
}

# Run the application
shinyApp(ui = ui, server = server)
