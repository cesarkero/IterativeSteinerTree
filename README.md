Iterative Steiner Tree
================
2020-05-08

<!-- README.md is generated from README.Rmd. Please edit that file -->

# IterativeSteinerTree

<!-- badges: start -->

<!-- badges: end -->

The goal of IterativeSteinerTree is to perform an Steiner Tree using
grass tools internaly. It has been conceived to calculate Steiner Tree
in large networks without burning out the PC. How does it work? The
algorith iterates over a list of points, creating an Steiner Tree with a
sample of these. After all the iterations, it pastes the different trees
and calculates a global Steiner Tree. This method allows the user to get
rid of never used paths and simplifies the informations the grass
v.net.steiner needs. Morover, the library contains tools to clean
topology error and “undchained” lines that can make grass crush.

## Installation

You can install the released version of IterativeSteinerTree from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("IterativeSteinerTree", dependencies = TRUE)
```

## Examples

### Clean lines to get rid of unchained lines and topology errors:

``` r
library(IterativeSteinerTree)
#> Loading required package: rgrass7
#> Loading required package: XML
#> GRASS GIS interface loaded with GRASS version: (GRASS not running)
#> Loading required package: rgdal
#> Loading required package: sp
#> rgdal: version: 1.4-8, (SVN revision 845)
#>  Geospatial Data Abstraction Library extensions to R successfully loaded
#>  Loaded GDAL runtime: GDAL 3.0.4, released 2020/01/28
#>  Path to GDAL shared files: 
#>  GDAL binary built with GEOS: TRUE 
#>  Loaded PROJ.4 runtime: Rel. 6.3.1, February 10th, 2020, [PJ_VERSION: 631]
#>  Path to PROJ.4 shared files: (autodetected)
#>  Linking to sp version: 1.4-1
#> Loading required package: raster
#> Loading required package: sf
#> Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 6.3.1
#> Loading required package: rgeos
#> Warning in fun(libname, pkgname): rgeos: versions of GEOS runtime 3.8.0-CAPI-1.13.1
#> and GEOS at installation 3.7.2-CAPI-1.11.2differ
#> rgeos version: 0.5-2, (SVN revision 621)
#>  GEOS runtime version: 3.8.0-CAPI-1.13.1 
#>  Linking to sp version: 1.4-1 
#>  Polygon checking: TRUE
#> Loading required package: mapview
#> Loading required package: doParallel
#> Loading required package: foreach
#> Loading required package: iterators
#> Loading required package: parallel

# basic setGRASS (based on iniGRASS params but simplified)
setGRASS(gisBase = "/usr/lib/grass78", epsg= 25829)
#> La región predeterminada fue actualizada a la nueva proyección, pero si
#> usted tiene múltiples Directorios de mapas debe correr 'g.region -d' en
#> cada uno para actualizar la región a partir de la predeterminada
#> Información de la proyección actualizada

# load sldf (l) and spdf (p)
data("l"); data("p")

# clean lines
lclean <- CleanLines(l)
#> ADVERTENCIA: El umbral para la herramienta 1 no puede >0, establecido a 0
#> Exportando 13061 elementos...
#>    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
#> v.out.ogr completo. 13458 elementos (tipo Line String) escritos a <lc>
#> (formato GPKG).
#> OGR data source with driver: GPKG 
#> Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/601.0.gpkg", layer: "lc"
#> with 13458 features
#> It has 13 fields
```

Here you can check the differences between clean and dirty lines:
<img src="README_files/figure-gfm/unnamed-chunk-2-1.png" width="100%" />

### Calculate simple Steiner Tree

In this example we are goint to calculate a simple Steiner Tree with a
sample of 50 points, conecting those out of the network by a threshold
of 1000 m

``` r
# calculate Steiner Tree
ST <- SteinerTree(lclean, p[1:50,], th = 1000)
#> ADVERTENCIA: 50 puntos encontrados, pero no se ha solicitado exportarlos.
#>              Verifique el parámetro 'type'.
#> ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
#>              los números de categoría como atributos
#> Exportando 499 elementos...
#>    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
#> v.out.ogr completo. 499 elementos (tipo Line String) escritos a <st>
#> (formato GPKG).
#> OGR data source with driver: GPKG 
#> Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/835.0.gpkg", layer: "st"
#> with 499 features
#> It has 1 fields
ST
#> class       : SpatialLinesDataFrame 
#> features    : 221 
#> extent      : 479875.6, 557134.7, 4735664, 4796091  (xmin, xmax, ymin, ymax)
#> crs         : +proj=utm +zone=29 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs 
#> variables   : 1
#> names       :  cat 
#> min values  :   73 
#> max values  : 5568
```

### Calculate Iterative Steiner Tree

This is the core of the library and the only tools that’s needed to
create the Steiner Tree. It can be used both to calculate a non
iterative Steiner Tree (by setting iterations = 0/1) or to calculate an
Iterative Steiner Tree. The main function will return a list of:
\[\[1\]\] –\> Merged Steiner Tree with all iterations \[\[2\]\] –\>
Total Steiner Tree calculated using Merged Steiner Trees and points
layer \[\[3\]\] –\> Total length of the Total Steiner Tree (m) \[\[4\]\]
–\> Total time of processing in
mins

``` r
IST <- IterativeSteinerTree(l = lclean, p = p[1:50,], th=1000, iterations = 10,
                            samples = 25, clean = FALSE, rpushbullet=TRUE)
FALSE [1] "Steiner tree iterative...Not yet in parallel..."
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 381 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 381 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/183.0.gpkg", layer: "st"
FALSE with 381 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 394 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 394 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/405.0.gpkg", layer: "st"
FALSE with 394 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 331 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 331 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/161.0.gpkg", layer: "st"
FALSE with 331 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 390 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 390 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/577.0.gpkg", layer: "st"
FALSE with 390 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 378 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 378 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/731.0.gpkg", layer: "st"
FALSE with 378 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 365 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 365 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/95.0.gpkg", layer: "st"
FALSE with 365 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 408 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 408 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/273.0.gpkg", layer: "st"
FALSE with 408 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 392 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 392 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/846.0.gpkg", layer: "st"
FALSE with 392 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 378 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 378 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/20.0.gpkg", layer: "st"
FALSE with 378 features
FALSE It has 1 fields
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 25 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 362 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 362 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/74.0.gpkg", layer: "st"
FALSE with 362 features
FALSE It has 1 fields
FALSE [1] "Total steiner tree from merged steiner trees.."
FALSE ADVERTENCIA: El mapa vectorial <l> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <p> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <lnet> ya existe y será sobrescrito.
FALSE ADVERTENCIA: El mapa vectorial <st> ya existe y será sobrescrito.
FALSE ADVERTENCIA: 50 puntos encontrados, pero no se ha solicitado exportarlos.
FALSE              Verifique el parámetro 'type'.
FALSE ADVERTENCIA: No se encontró ninguna tabla de atributos -> sólo se usan
FALSE              los números de categoría como atributos
FALSE Exportando 153 elementos...
FALSE    5%  11%  17%  23%  29%  35%  41%  47%  53%  59%  65%  71%  77%  83%  89%  95% 100%
FALSE v.out.ogr completo. 153 elementos (tipo Line String) escritos a <st>
FALSE (formato GPKG).
FALSE OGR data source with driver: GPKG 
FALSE Source: "/tmp/RtmpBnCr6J/grassdata/PERMANENT/.tmp/cesarkero-PC/241.0.gpkg", layer: "st"
FALSE with 153 features
FALSE It has 1 fields
```

Moreover, if you have previously configured
[rpushbullet](https://github.com/eddelbuettel/rpushbullet) you will get
a notification in your devices when the process in completed.

![Notification example…](./man/figures/rpushbullet.png)

That’s all ¡
