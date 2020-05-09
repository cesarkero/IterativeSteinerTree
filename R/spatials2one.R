#' @title spatials2one
#' @description Merge list of SLDF's. In case the object if already a SLDF, just returns it
#'
#' @param spatials SLDF or list of SLDF's
#'
#' @return SLDF
#' @export
#'
#' @examples
#' \dontrun{
#' data("l")
#' ls <- list()
#' for(i in 1:length(l[1:100,])){ls[i] <- l[i,]}
#' spatials2one(ls)
#' }
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
