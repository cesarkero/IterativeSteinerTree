Iterative Steiner Tree
================
2020-05-09

# Description

The goal of IterativeSteinerTree is to perform an Steiner Tree using
grass tools internaly. It has been conceived to calculate Steiner Tree
in large networks without burning out the PC. How does it work? The
algorith iterates over a list of points, creating an Steiner Tree with a
sample of these. After all the iterations, it pastes the different trees
and calculates a global Steiner Tree. This method allows the user to get
rid of never used paths and simplifies the informations the grass
v.net.steiner needs. Morover, the library contains tools to clean
topology error and “undchained” lines that can make grass crush.

## Notes

Currently, this package has been just tested in:

  - Ubuntu 20.04 with R 3.6.3
  - Windows 10 with R 4.0 + Rtools40

# Installation

First of all, GRASS 7.8 is needed before using these tools.

  - Windows:
    [Download](https://grass.osgeo.org/grass78/binary/mswindows/native/x86_64/WinGRASS-7.8.2-1-Setup-x86_64.exe)
  - Linux: the easiest way is to install it with QGIS from console: `r
    sudo apt-get update && sudo apt-get install qgis qgis-plugin-grass
    qgis-plugin-grass saga`

## Calculate Iterative Steiner Tree

This is the core of the library and the only tools that’s needed to
create the Steiner Tree. It can be used both to calculate a non
iterative Steiner Tree (by setting iterations = 0/1) or to calculate an
Iterative Steiner Tree. The main function will return a list of:

  - \[\[1\]\] –\> Merged Steiner Tree with all iterations
  - \[\[2\]\] –\> Total Steiner Tree calculated using Merged Steiner
    Trees and points layer
  - \[\[3\]\] –\> Total length of the Total Steiner Tree (m)
  - \[\[4\]\] –\> Total time of processing in
mins

<!-- end list -->

``` r
IST <- IterativeSteinerTree(l = lclean, p[1:100,], th=1000, iterations = 25,
                            samples = 10, clean = FALSE, rpushbullet=TRUE)
```

In this example, an Iterative Steiner Tree have been calculated for 100
points, making 25 iterations with 10 points each:

``` r
m3 <- mapview(IST[[1]], color="blue")+IST[[2]]+p[1:100,]
mapshot(m3, url = paste0(getwd(),'/man/html/m3.html')) ## create standalone .html
m3
```

<div class="figure" style="text-align: center">

<img src="./man/figures/SST.gif" alt="Iterative Steiner Tree" width="75%" />

<p class="caption">

Iterative Steiner Tree

</p>

</div>

Moreover, if you have previously configured
[rpushbullet](https://github.com/eddelbuettel/rpushbullet) you will get
a notification in your devices when the process in
completed.

<div class="figure" style="text-align: center">

<img src="./man/figures/rpushbullet.png" alt="Example of notification" width="25%" />

<p class="caption">

Example of notification

</p>

</div>

May be is a little bit rudimentary, but it works.
