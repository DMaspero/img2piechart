# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

img2piechart <- function(imageFN=NULL, nColors=10, diameter=10, outFN = NULL) {
  IMG <- load.image(file = ImageFN)
  plot(IMG)

  pixelInfo <- data.frame(matrix(data = NA,
                                 nrow = (dim(IMG)[1]*dim(IMG)[2]),
                                 ncol = 6))
  colnames(pixelInfo) <- c("idx","x","y", "R", "G", "B")
}
