# img2piechart
Turning any images into a piechart. 

## Description
This shiny app takes as input any image (PNG, JPEG) that could be read by imager, cluster the pixel color via kmean, and transform it in a piechart.
This shiny app was conceived for celebrating a PhD defense. 
The researcher developed a computational model for mapping on spatial transcriptomic data patter of cell population abundance 
(see. https://marcelosua.github.io/SPOTlight/). One of the main output of the tool is a piechart. 
Thus, we tought was a nice gift transform one of his picture into a piechart. 

## Installation
devtools::install_github("DMaspero/img2piechart")

## Usage
Run the shiny interface by typing img2piechart::app() in R/RStudio

