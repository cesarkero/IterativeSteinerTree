#' @title UnifyLines (after steiner)
#' @description The algorith transform an SLDF with multiple and overlaping lines
#' into a unique line that works as a clean network to caltulate the final
#' Total Steiner Tree
#' @param sldf SpatialLinesDataFrame entry
#' @param attr "All" by default
#'
#' @return sldf unified into one feature
#' @export
#'
#' @examples
#' data("l")
#' ls <- list()
#' for(i in 1:length(l[1:100,])){ls[i] <- l[i,]}
#' l1 <- spatials2one(ls)
#'
#' # multiply x2 the lines to tryout UnifyLines
#' l2 <- rbind(l1,l1)
#'
#' # UnifyLines (network)
#' UnifyLines(l2)
UnifyLines <- function(l){
    mergedlines <- as_Spatial(st_line_merge(st_union(st_as_sf(l))))
    df <- data.frame(1); rownames(df) <- 1; colnames(df) <- "cat"
    sldf <- SpatialLinesDataFrame(mergedlines, df, match.ID = FALSE)
    return(sldf)
}
