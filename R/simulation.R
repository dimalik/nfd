## runs simulations on the effect of text size on NFD
## see analysis 3 in Bentz et al.

simulation <- function(corpusA, corpusB, fun, max.size, random.sampling, verbosity) {
    ## corpus(A|B) should either be a character string (e.g. "this is a test sentence") or a
    ## character vector (e.g. c("this", "is", "a", "test", "sentence"))
    ## if size == NULL then it returns the nfd value between the entire corpora.
    ## Otherwise, size should be > 10. 

    corpusAlength <- length(corpusA)
    corpusBlength <- length(corpusB)
    if (is.null(max.size)) {
        if (verbosity > 0) warning("Size was not provided. The NFD value will be between the entire corpora.")
        return (fun(freq.dist(corpusA), freq.dist(corpusB)))
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
            nfd.vec[i] <- fun(freq.dist(cA[get.samples(i, random.sampling, max.tokens)]),
                              freq.dist(cB[get.samples(i, random.sampling, max.tokens)]))
            if (verbosity > 1) cat("\r", "Done", i/max.size*100, "%    ")
        }
        return (nfd.vec)
    }
}

setClass("text.size.simulation",
         representation(
             corpusA="character",
             corpusB="character",
             fun="function",
             max.size="numeric",
             random.sampling="logical",
             verbosity="numeric",
             diffvals="numeric")
         )

setMethod("initialize", "nfd", function(.Object, ..., corpusA, corpusB, fun=NFD, max.size=NULL, random.sampling=TRUE, verbosity=2) {
              ## test difference function by asserting that providing two numerical
              ## vectors yields a scalar
              tmpDistA <- 10:1
              tmpDistB <- rep(5, 10)
              ans <- fun(tmpDistA, tmpDistB)
              if (!length(ans) == 1 || !is.numeric(ans))
                  stop("You need to provide a function that given two numerical vectors returns a numeric vector of length 1 (ie. scalar).")
              ## end testing
              .Object@corpusA <- corpusA
              .Object@corpusB <- corpusB
              .Object@fun <- fun
              .Object@max.size <- max.size
              .Object@random.sampling <- random.sampling
              .Object@verbosity <- verbosity
              .Object@diffvals <- simulation(.Object@corpusA,
                                             .Object@corpusB,
                                             .Object@fun,
                                             .Object@max.size,
                                             .Object@random.sampling,
                                             .Object@verbosity)
              .Object
          })

setMethod("print", "text.size.simulation", function(x, ...)
    print("Distribution difference by text size object"))
setMethod("show", "text.size.simulation", function(object)
    print(object@diffvals))
setMethod("plot", "text.size.simulation", function(x, y, ...) {
              plot(1:10)
          })

setMethod("summary", "text.size.simulation", function(object, ...) {
              cat("Distribution difference by text size\n")
              cat("  Simulation parameters\n")
              cat("    Corpus A                    :", object@corpusA, "\n")
              cat("    Corpus B                    :", object@corpusB, "\n")
              cat("    Difference function         :", object@fun, "\n")
              cat("    Using random samples        :", object@random.samping, "\n")
              cat("    Max text size               :", object@max.size, "\n")
              cat("  Results\n")
              cat("    Mean of difference values   :", mean(object@diffvals))
              cat("    Median of difference values :", mean(object@diffvals))
              cat("    Range of difference value   :", range(object@diffvals))
              cat("    SD of difference values     :", sd(object@diffvals))
          })

TSsim <- function(corpusA, corpusB, fun=NFD, max.size=NA_real_, random.sampling=FALSE, verbosity=2)
    new("text.size.simulation",
        corpusA=corpusA,
        corpusB=corpusB,
        fun=fun,
        max.size=max.size,
        random.sampling=random.sampling,
        verbosity=verbosity)
