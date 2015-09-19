## runs simulations on the effect of text size on NFD
## see analysis 3 in Bentz et al.

simulation <- function(corpusA, corpusB, fun, max.size,
                       random.sampling, smaller.corpus.size, verbosity) {
    ## corpus(A|B) should either be a character string
    ## (e.g. "this is a test sentence") or a
    ## character vector (e.g. c("this", "is", "a", "test", "sentence"))
    ## max.size should either be a monotonically increasing vector the maximum
    ## value of which is less than the size of the smaller corpus (otherwise
    ## it is trimmed to the length of the smaller corpus) or a scalar which
    ## assumes a sequence 1:max.size. If max.size == 1 then it returns
    ## NFD(fd(corpusA), fd(corpusB))

    ## preallocate vectors
    nfd.vec <- double(length(max.size))
    for (i in max.size) {
        nfd.vec[i] <- fun(freq.dist(corpusA[get.samples(i,
                                                   random.sampling,
                                                   smaller.corpus.size)]),
                          freq.dist(corpusB[get.samples(i,
                                                   random.sampling,
                                                   smaller.corpus.size)]))
        if (verbosity > 1) cat("\r", "Done", i/length(max.size)*100, "%    ")
    }
    return (nfd.vec)
}

setClass("text.size.simulation",
         representation(
             corpusA="character",
             corpusB="character",
             fun="function",
             fun_name="character",
             max.size="numeric",
             random.sampling="logical",
             diffvals="numeric")
         )

setMethod("initialize", "text.size.simulation", function(
    .Object,
    ...,
    corpusA=NULL,
    corpusB=NULL,
    fun=NFD,
    fun_name=NA_character_,
    max.size=NULL,
    random.sampling=TRUE,
    verbosity=2) {
              if (length(corpusA) == 1) cA <- split.string(corpusA) else cA <- corpusA
              if (length(corpusB) == 1) cB <- split.string(corpusB) else cB <- corpusB
              corpusAlength <- length(cA)
              corpusBlength <- length(cB)
              smaller.corpus.size <- min(corpusAlength, corpusBlength)
              
              ## carry out size tests
              if (length(max.size) > 1) {
                  if (!all(max.size == cummax(max.size)))
                      stop("Please provide a monotonically increasing vector.")
                  if (tail(max.size, n=1) > smaller.corpus.size)
                      max.size <- max.size[max.size<smaller.corpus.size]
              } else max.size <- 1:max.size
              
              if (corpusAlength != corpusBlength)
                  if (random.sampling)
                      warning("The corpora had unequal number of tokens.
The maximum text size now reduced to the size of the smaller corpus.")
                  else warning("If the number of tokens is not equal 
between the corpora it is advised to run the simulation with 
random.sampling = T to avoid skewness problems.")
              
              .Object@corpusA <- cA
              .Object@corpusB <- cB
              .Object@fun <- fun
              .Object@fun_name <- fun_name
              .Object@max.size <- max.size
              .Object@random.sampling <- random.sampling
              .Object@diffvals <- simulation(.Object@corpusA,
                                             .Object@corpusB,
                                             .Object@fun,
                                             .Object@max.size,
                                             .Object@random.sampling,
                                             smaller.corpus.size,
                                             verbosity)
              .Object
          })

setMethod("print", "text.size.simulation", function(x, ...)
    print("Distribution difference by text size object"))

setMethod("show", "text.size.simulation", function(object)
    print(object@diffvals))

setMethod("plot", "text.size.simulation", function(x, y, ...) {
              df <- data.frame(diff=x@diffvals, corpus.size=x@max.size)
              ggplot(df, aes(x = corpus.size, y = diff)) +
                  labs(x="Number of Tokens", y="NFD_lem") +
                      geom_smooth()
          })

setValidity("text.size.simulation",
            function(object) {
                ## tests whether the function provided is a valid one
                retval <- NULL
                tmpDistA <- 10:1
                tmpDistB <- rep(5, 10)
                ans <- object@fun(tmpDistA, tmpDistB)
                if (!length(ans) == 1 || !is.numeric(ans))
                    retval <- c(retval, "You need to provide a function that 
given two numerical vectors returns a numeric vector of length 1 (ie. scalar).")
                if (is.null(retval)) return (TRUE)
                else return(retval)
            })

setMethod("summary", "text.size.simulation", function(object, ...) {
              ## find boundaries
              if (length(object@corpusA) >= 50) maxA <- 50 else maxA <- length(object@corpusA)
              if (length(object@corpusB) >= 50) maxB <- 50 else maxB <- length(object@corpusB)
              corpusA.trunc <- paste(object@corpusA[1:maxA], collapse = " ")
              if (maxA == 50)
                  corpusA.trunc <- paste(corpusA.trunc, "...", collapse = " ")
              corpusB.trunc <- paste(object@corpusB[1:maxB], collapse = " ")
              if (maxB == 50)
                  corpusB.trunc <- paste(corpusB.trunc, "...", collapse = " ")
              ## trim down the sequence if need be
              if (length(object@max.size) > 10)
                  max.size.show <- paste(paste(object@max.size[1:4], collapse = " "),
                                         "...",
                                         paste(tail(object@max.size, n = 4), collapse = " "),
                                         collapse = " ")
              else max.size.show <- paste(object@max.size, collapse = " ")
              
              cat("Distribution difference by text size\n")
              cat("------------------------------------\n")
              cat("  Simulation parameters\n")
              cat("    Corpus A                    :", corpusA.trunc, "\n")
              cat("    Corpus B                    :", corpusB.trunc, "\n")
              cat("    Difference function         :", object@fun_name, "\n")
              cat("    Using random samples        :", object@random.sampling, "\n")
              cat("    Max text size               :", max.size.show, "\n")
              cat("  Results\n")
              cat("    Mean of difference values   :", mean(object@diffvals), "\n")
              cat("    Median of difference values :", mean(object@diffvals), "\n")
              cat("    Range of difference value   :", range(object@diffvals), "\n")
              cat("    SD of difference values     :", sd(object@diffvals), "\n")
          })

TSsim <- function(
    corpusA,
    corpusB,
    fun=getNFD,
    max.size=1:20,
    random.sampling=FALSE,
    verbosity=2) {
    fun_name <- as.character(substitute(fun))
    new("text.size.simulation",
        corpusA=corpusA,
        corpusB=corpusB,
        fun=fun,
        fun_name=fun_name,
        max.size=max.size,
        random.sampling=random.sampling,
        verbosity=verbosity)
}
