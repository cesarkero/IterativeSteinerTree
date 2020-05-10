#' Function to initialize rgrass
#'
#' @param gisBase Location of the grass78 library
#' @param home Temporal file by default
#' @param gisDbase Temporal file by default
#' @param location Main folder for importing and processing
#' @param mapset Subfolder for importing and processgin
#' @param override TRUE by default
#' @param flags Options for rgrass7 package
#' @param epsg By default set to 25829
#'
#' @return There is no output, just setting the grass paths, flags...
#' @export
#'
#' @examples
#' \dontrun{
#' # linux
#' setGRASS(gisBase = '/usr/lib/grass78', epsg= 25829)
#'
#' # Windows
#' # Not working yet...
#' }
setGRASS <- function(gisBase = "/usr/lib/grass78", home = tempdir(), gisDbase = tempdir(),
                     location = 'grassdata', mapset = "PERMANENT", override = TRUE,
                     flags=c('c','quiet'), epsg= 25829){

    # define the GRASS executable path
    if(Sys.info()["sysname"] == "Windows"){
        print("Not ready yet to work in windows...")
        # gisBase <- 'C:/OSGeo4W64/apps/grass/grass-7.0.5'
    }else {
        # Grass config
        initGRASS(gisBase = gisBase, home = home, gisDbase = gisDbase,
                  location = location, mapset = mapset, override = override)
        use_sp()
        # assign GRASS projection according to data set (may be not needed)
        execGRASS('g.proj', flags = flags, epsg = epsg)
    }
}
