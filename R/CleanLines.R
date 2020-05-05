#' Clean lines (SpatialLinesDataFrame) for Steiner tree
#' @description This function will remove unchained parts of the lines layer
#' that can cause issues when executing v.net.steiner. After removing those parts,
#' the layer is imported into grass to execute v.clean and v.build to repare
#' topology issues#'
#' @param SpatialLinesDataFrame
#'
#' @return
#' @export
#'
#' @examples
#' CleanLines(x)
CleanLines <- function(x){
    # CRITICAL PART IN ORDER TO MAKE V.NET.STEINER

    # MiniBuffer, Merge, Singleparts and Unselect Lines out of the main network
    lx <- st_cast(st_union(st_buffer(st_as_sf(x),0.1)),"POLYGON")
    NotMainNet <- st_union(lx[st_area(lx)!=max(st_area(lx)),])
    xpart <- st_intersects(st_as_sf(x), NotMainNet, sparse = FALSE)

    # remove lines that intersect with any of the tiny buffers from NotMainNet
    ls <- x[!xpart[,1],]

    #ininiate grass
    setGRASS()

    #import lines
    writeVECT(ls, 'lx', v.in.ogr_flags = c('o','overwrite','quiet'),
              Sys_show.output.on.console = FALSE)

    # clean
    execGRASS("v.clean", input = 'lx', output = 'lc', tool = c('break','snap'),
              threshold = c(10,10), flags = c('o','overwrite','quiet'),
              Sys_show.output.on.console = FALSE)
    #build
    execGRASS("v.build", map = 'lc', option = 'build', flags = c('e', 'overwrite', 'quiet'),
              Sys_show.output.on.console = FALSE)

    return(readVECT('lc'))
}
