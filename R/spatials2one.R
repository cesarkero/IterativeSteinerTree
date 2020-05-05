#' Title
#'
#' @param spatials
#'
#' @return
#' @export
#'
#' @examples
spatials2one <- function(spatials){

    if (length(spatials)==1){
        s <- spatials[[1]]
    }else if (class(spatials)=="SpatialLinesDataFrame"){
        s <- spatials
    }else{
        spatials <- spatials[!is.na(spatials)]
        if (length(spatials)==1){
            s <- spatials[[1]]
        }else{
            s <- spatials[[1]]
            for (i in 1:(length(spatials)-1)){s <- rbind(s, spatials[[i+1]])}
        }
    }
    return(s)
}
