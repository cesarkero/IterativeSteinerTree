#' SteinerTree function using v.net.steiner from GRASS as core function
#' It contains the v.net function to connect points to lines using threshold
#'
#' @param l Network to calculate Steiner Tree (SLDF)
#' @param p Points to be conected by Steiner Tree (SPDF)
#' @param th Threshold --> max distance of points to be connecte to lines
#'
#' @return
#' @export
#'
#' @examples
SteinerTree <- function(l, p, th) {
    tryCatch({
        # import whole lines layer and clean topology
        writeVECT(l, 'l', v.in.ogr_flags = c('o','overwrite','quiet'))

        # import clipped layers into grass
        writeVECT(p, 'p', v.in.ogr_flags = c('o','overwrite','quiet'))

        # lnet
        execGRASS("v.net", input = 'l', points = 'p', output = 'lnet',
                  operation = 'connect', threshold = th, flags = c('overwrite','quiet'))

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
