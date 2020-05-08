#' @title IterativeSteinerTree
#' @description This algorithm will perform parametric Steiner Trees based on the iterations
#' and samples (of points). The goal (not ready yet is to iterate in parallel).
#' By now, this work sequentially. In each iteration, an Steiner Tree is calculated
#' using a SLDF an a SPDF, which would be sampled, in each iteration, by a given
#' number. After all iterations have been performed, a dissolved network of the partials
#' steiner trees will be created in order to do a last final complete Steiner tree.
#' This process allows, by sampling and iterating several times, to get the
#' main network and remove all those patch, terminals and other lines that are not
#' usefull and add noise to calculations.
#'
#' @param l SLDF
#' @param p SPDF
#' @param th threshold to connect points to lines
#' @param iterations number of iterations of Steiner Trees (0/1 to make just one ST)
#' @param samples number of samples from SPDF in each iteration (0/1 to use full SPDF)
#' @param clean if TRUE, lines will be previously cleaned (using CleanLines())
#' Even this CleanLines is already implemented within the SteinerTree(), here
#' it will be executed independently to get a perfect lines layer from the begining
#' and avoid cleaning in each iteration.
#'
#' @param rpushbullet FALSE by default. Use TRUE just if you have it previously configured.
#' This allows yo to go have a coffe while Steiner Tree is calculated. You will receive
#' a notification with the minutes of processing and final length.
#'
#' @return List of four items: (1) Merged Steiner Tree of all iterations; (2)
#' Total Steiner Tree from Merged Steiner Trees and points; (3) length of the Total
#' Steiner Tree; (4) Time of processing in mins
#'
#' @export
#'
#' @examples
#' data("l"); data("p")
#' setGRASS(gisBase = "/usr/lib/grass78", epsg= 25829)
#' IST <- IterativeSteinerTree(l, p, 1000, 3, samples = 10, clean = TRUE, rpushbullet=TRUE)
IterativeSteinerTree <- function(l, p, th=1000, iterations=1, samples=0, clean=TRUE,
                                 rpushbullet=FALSE){
    t0 <- Sys.time()

    # clean lines (or not)
    if (clean==TRUE){
        # Clean lines
        print("Cleaning lines...")
        lx <- CleanLines(l)
    }else{lx <- l}

    # Set points for iterations (or not)
    if (iterations <= 1){
        if (samples <= 1){
            # dont divide and dont sample
            px <- p
        }else{
            # dont divide, just sample
            px <- p[sample(nrow(p),samples, replace = FALSE),]
        }
    }else{
        px <- list()
        if(samples<=1){
            # divide points by iterations
            for(i in 1:iterations){
                px <- append(px, p[sample(nrow(p), ceiling(nrow(p)/iterations), replace = FALSE),])
            }
        }else{
            # divide points by iterations and sample
            for(i in 1:iterations){
                px <- append(px, p[sample(nrow(p), samples, replace = FALSE),])
            }
        }
    }

    #PARALLEL SAMPLED STEINER TREE (PST) (or simple ST if iterations <=1 )
    if (iterations > 1){
        print("Steiner tree iterative...Not yet in parallel...")
        # cl <- parallel::makeCluster(detectCores()-freecores, type="FORK")
        # doParallel::registerDoParallel(cl)
        # doesn't work I think because of GRASS paths...
        # SST <- parLapply(cl, px, function(x){ST(lx, x, th)})
        # HERE IS THE KEY TO SOLVE IT --> https://github.com/r-spatial/link2GI/issues/20
        # bypass of the fucking grass in parallel...
        SST <- pbapply::pblapply(px, function(x){SteinerTree(lx, x, th)})
        # stopCluster(cl)

        # Merge Steiner trees (SST)
        SST <- UnifyLines(spatials2one(SST))

        # Calculate Total Steiner Tree using SST
        print("Total steiner tree from merged steiner trees..")
        TST <- SteinerTree(SST, p, th)

    } else {
        print("Steiner tree simple...")
        SST <- SteinerTree(lx, px, th)
        TST <- SST
    }

    # Length of solution
    tlen <- sum(SpatialLinesLengths(TST))

    # time of processing
    mins <- difftime(Sys.time(), t0, units="mins")[[1]]

    # pushbullet
    if (rpushbullet == TRUE){
        msg <- paste("Ended in", round(mins), "minutes, with a total length of",
                      round(tlen), "m")
        RPushbullet::pbPost("note", title="Steiner Tree completed", body=msg)
    }

    return(c(SST, TST, tlen, mins))
}
