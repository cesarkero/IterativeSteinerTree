#ITERATIVE STEINER TREE (MAIN FUNCTION)
#l --> lines
#p --> points
#freecores --> number of cores to leave without working
#th --> threshold to connect points to lines
#iterations --> number of iterations in steiner tree
#samples --> number of points used in each iteration
IterativeSteinerTree <- function(l, p, freecores = 1 , th = 1000, iterations=1, samples=0, clean= TRUE){
    t0 <- Sys.time()

    # Grass config
    setGRASS()

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
        print("Steiner tree iterative...")
        cl <- parallel::makeCluster(detectCores()-freecores, type="FORK")
        doParallel::registerDoParallel(cl)
        # doesn't work I think because of GRASS paths...
        # SST <- parLapply(cl, px, function(x){ST(lx, x, th)})
        # HERE IS THE KEY TO SOLVE IT --> https://github.com/r-spatial/link2GI/issues/20
        # bypass of the fucking grass in parallel...
        SST <- pbapply::pblapply(px, function(x){ST(lx, x, th)})
        stopCluster(cl)

        # Merge Steiner trees (SST)
        SST <- sp2ones(SST) #join all list elements from parallel into one
        SST = aggit(SST,"All") # aggregate lines
        SST$cat <- 1:nrow(SST) #had to remove first variable and create another one ¡¡
        SST <- SST[,2] #get just lines with variable cat

        # Calculate Total Steiner Tree using SST
        print("Total steiner tree from merged steiner trees..")
        TST <- ST(SST, p, th)

    } else {
        print("Steiner tree simple...")
        SST <- ST(lx, px, th)
        TST <- SST
    }

    # Length of solution
    tlen <- sum(SpatialLinesLengths(TST))

    # time of processing
    mins <- difftime(Sys.time(), t0, units="mins")[[1]]

    return(c(SST, TST, tlen, mins))
}
