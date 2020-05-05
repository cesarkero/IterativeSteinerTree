
<!-- README.md is generated from README.Rmd. Please edit that file -->

# IterativeSteinerTree

<!-- badges: start -->

<!-- badges: end -->

The goal of IterativeSteinerTree is to …

## Installation

You can install the released version of IterativeSteinerTree from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("IterativeSteinerTree")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(IterativeSteinerTree)
#> Loading required package: rgrass7
#> Loading required package: XML
#> GRASS GIS interface loaded with GRASS version: GRASS 7.8.2 (2019)
#> and location: grassdata
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
#> Loading required package: doParallel
#> Loading required package: foreach
#> Loading required package: iterators
#> Loading required package: parallel
#> Loading required package: mapview
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub\!
