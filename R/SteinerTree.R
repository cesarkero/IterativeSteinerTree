#' @title  Steiener tree function
#' @description  Steiner Tree function using v.net.steiner from GRASS as core function
#' It contains the v.net function to connect points to lines using threshold
#'
#' @param l Network to calculate Steiner Tree (SLDF)
#' @param p Points to be conected by Steiner Tree (SPDF)
#' @param th Threshold --> max distance of points to be connected to lines
#' @param clean If true, sldf will be cleaned internaly using CleanLines()
#'
#' @return Steiner tree for the lines and points given. In case
#' there is some error, it return NA
#' @export
#'
#' @examples
#' \dontrun{
#' setGRASS(gisBase = "/usr/lib/grass78", epsg= 25829)
#' data("l"); data("p")
#' st <- SteinerTree(l, p[1:20,], th = 1000, clean = TRUE)
#' mapview(l)+st+p[1:20,]
#' }
SteinerTree <- function(l, p, th, clean = FALSE) {
    if (clean == TRUE){
        print("Cleaning lines...")
        l <- CleanLines(l)
    }

    tryCatch({
        # import whole lines layer and clean topology
        writeVECT(l, 'l', v.in.ogr_flags = c('o','overwrite','quiet'))

        # import clipped layers into grass
        writeVECT(p, 'p', v.in.ogr_flags = c('o','overwrite','quiet'))

        # lnet
        execGRASS("v.net", input = 'l', points = 'p', output = 'lnet',
                  operation = 'connect', threshold = th, flags = c('overwrite','quiet'))

        print("Calculating Steiner Tree...")
        # steiner tree
        execGRASS("v.net.steiner",
                  input = 'lnet',
                  output = 'st',
                  node_layer = '2',
                  terminal_cats = '1-5000',
                  flags = c('overwrite','quiet'))

        return(readVECT('st'))
    },
    error=function(cond) {return(NA)}
    )
}
