# img2piechart
Turning any images into a piechart. 
The app is available online [here](https://dmaspero.shinyapps.io/apps/)

## Description
This shiny app takes as input any image (PNG, JPEG) that could be read by imager, cluster the pixel color via kmean, and transform it in a piechart.
This shiny app was conceived for celebrating a PhD defense. 
The researcher developed a computational model for mapping on spatial transcriptomic data patter of cell population abundance 
(see. https://marcelosua.github.io/SPOTlight/). One of the main output of the tool is a piechart. 
Thus, we tought was a nice gift transform one of his picture into a piechart. 

![Figure1](https://github.com/DMaspero/img2piechart/blob/main/man/preview.png)

## Installation
```
devtools::install_github("DMaspero/img2piechart")
```

## Usage
Run the shiny interface by typing the following in R/RStudio
```
img2piechart::app() 
```

The app requires one image and two parameters
- 'Color Cluster #': defines the number of distinc color cluster. You can see a preview in the top right part of the screen
- 'piechart diameter' defines size of each pie chart and how many will be plotted.

You can export the final result in vectorial (PDF) using the corresponding button (Click it only once)
