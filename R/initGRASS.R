#' Function to initialize rgrass
#'
#' @param gisBase Location of the grass78 library
#' @param home Temporal file by default
#' @param gisDbase Temporal file by default
#' @param location Main folder for importing and processing
#' @param mapset Subfolder for importing and processgin
#' @param overrride TRUE by default
#' @param flags Options for rgrass7 package
#' @param epsg By default set to 25829
#'
#' @return There is no output, just setting the grass paths, flags...
#' @export
#'
#' @examples
#' setGRASS()
#' \dontrun{
#' setGRASS(home ='./temp', location = 'grassdata')
#' }
setGRASS <- function(gisBase = "/usr/lib/grass78", home = tempdir(), gisDbase = tempdir(),
                     location = 'grassdata', mapset = "PERMANENT", overrride = TRUE,
                     flags="c", epsg= 25829){
    # Grass config
    initGRASS(gisBase = gisBase, home = home, gisDbase = gisDbase,
                   location = location, mapset = mapset, override = overrride)
    use_sp()
    execGRASS("g.proj", flags = flags, epsg = epsg)
}
