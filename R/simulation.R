## runs simulations on the effect of text size on NFD
## see analysis 3 in Bentz et al.

## setClass("nfd.simulation",
##          representation(
##              corpusA="character",
##              corpusB="character",
##              max.size="integer",
##              random.sampling="logical",
##              verbosity="integer"),
##          prototype(
##              max.size=NULL,
##              random.sampling=TRUE,
##              verbosity=2)
##          )

## nfd.simulation <- function(corpusA, corpusB, max.size, random.sampling, verbosity)
##     new("nfd.simulation",
##         corpusA=corpusA,
##         corpusB=corpusB,
##         max.size=max.size,
##         random.sampling=random.sampling,
##         verbosity=verbosity)


## setMethod(f = "runSimulation", signature = "nfd.simulation", definition = )
## setMethod(f = "plot", signature = "nfd.simulation", definition = )
## setMethod(f = "print", signature = "nfd.simulation", definition = )
## setMethod(f = "show", signature = "nfd.simulation", definition = )
## setMethod(f = "[", signature = "nfd.simulation", definition = )
## setMethod(f = "initialize", signature = "nfd.simulation", definition = )


nfd.simulation <- function(corpusA, corpusB, size=NULL, random=FALSE) UseMethod("nfd.simulation")

nfd.simulation.default <- function(corpusA, corpusB, max.size=NULL, random.sampling=FALSE, verbosity=2) {
    ## corpus(A|B) should either be a character string (e.g. "this is a test sentence") or a
    ## character vector (e.g. c("this", "is", "a", "test", "sentence"))
    ## if size == NULL then it returns the nfd value between the entire corpora.
    ## Otherwise, size should be > 10. 

    corpusAlength <- length(corpusA)
    corpusBlength <- length(corpusB)
    if (is.null(max.size)) {
        if (verbosity > 0) warning("Size was not provided. The NFD value will be between the entire corpora.")
        nfd.val <- nfd(freq.dist(corpusA), freq.dist(corpusB))
    } else {
        if (max.size < 10) stop("Size value too low. Try a value larger than 10.")
        cA <- split.string(corpusA)
        cB <- split.string(corpusB)
        if (corpusAlength == 1) corpusANtokens <- length(cA) else corpusAlength
        if (corpusBlength == 1) corpusBNtokens <- length(cB) else corpusBlength
        if (corpusANtokens != corpusBNtokens) {
            warning("The corpora had unequal number of tokens. Trimming the largest.")
            max.tokens <- min(corpusANtokens, corpusBNtokens)
            if (max.tokens < max.size) {
                warning("max.size cannot be larger than the maximum number of tokens. Re-setting max.size.")
                max.size <- max.tokens
            }
        }
        ## preallocate vectors
        nfd.vec <- double(max.size)
        for (i in 1:max.size) {
            nfd.vec[i] <- nfd(freq.dist(cA[get.samples(i, random.sampling, max.tokens)]),
                              freq.dist(cB[get.samples(i, random.sampling, max.tokens)]))
            if (verbosity > 1) cat("\r", "Done", i/max.size*100, "%    ")
        }
    }
    
    class(tmp) <- "NFDSimulation"
    tmp
}

print.nfd.simulation <- function(x, ...) {
    print(x$nfd_values)
}

summary.nfd.simulation <- function(object, ...) {
        ## size random mode
    cat("NFD Simulation on:", x$cA, "and", x$cB,
        "Random =", as.character(x$random),
        "Size =", as.character(x$size),
        "Mode =", as.character(Mode(x$vec)))
}

print.summary.nfd.simulation <- function(x, ...) {}

plot.nfd.simulation <- function(x, y, ...) {}
