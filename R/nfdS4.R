## NFD S4 class specification
## authors: dimitrios alikaniotis (da352@cam.ac.uk)
##          christian bentz (cb696@cam.ac.uk)

nfdSim <- function(f1, f2, f1_length, f2_length) {
    ## C Wrapper function
    ## Returns a list of two objects: the nfd_value (scalar)
    ## and the absolute differences between the two distributions
    ## (vector)
    tmp <- .C("cnfd",
              f1=as.integer(f1),
              f2=as.integer(f2),
              f1_length=as.integer(f1_length),
              f2_length=as.integer(f2_length),
              freqDiff=integer(max(f1_length, f2_length)),
              nfd_value=as.double(0))
    return (list(nfd_value=tmp$nfd_value, freqDiff=tmp$freqDiff))
}


## main class definition
setClass("nfd",
         representation(
             freqDistA="numeric",
             freqDistB="numeric",
             freqDistA.NTypes="numeric",
             freqDistB.NTypes="numeric",
             freqDistA.NTokens="numeric",
             freqDistB.NTokens="numeric",
             nfd_value="numeric",
             freqDiff="numeric"
             ),
         prototype(
             freqDistA=NA_real_,
             freqDistB=NA_real_,
             freqDistA.NTypes=NA_real_,
             freqDistB.NTypes=NA_real_,
             freqDistA.NTokens=NA_real_,
             freqDistB.NTokens=NA_real_,
             nfd_value=NA_real_,
             freqDiff=NA_real_
             ))

## initialization method
setMethod("initialize", "nfd", function(.Object, ..., freqDistA, freqDistB) {
              .Object@freqDistA <- freqDistA
              .Object@freqDistB <- freqDistB
              .Object@freqDistA.NTypes <- length(.Object@freqDistA)
              .Object@freqDistB.NTypes <- length(.Object@freqDistB)
              .Object@freqDistA.NTokens <- sum(.Object@freqDistA)
              .Object@freqDistB.NTokens <- sum(.Object@freqDistB)
              simulation <- nfdSim(.Object@freqDistA,
                                   .Object@freqDistB,
                                   .Object@freqDistA.NTypes,
                                   .Object@freqDistB.NTypes)
              .Object@nfd_value <- simulation$nfd_value              
              .Object@freqDiff <- simulation$freqDiff
              .Object
          })

## redefinition of print
#setMethod(f = "print", signature = signature(x = "nfd"), function(x, ...) {
#              cat("The NFD value is: ", x@nfd_value, "\n")
#          })

## redefinition of plot
setMethod("plot", "nfd", function(x, y, ..., label1='A', label2='B') {
              max_value <- max(x@freqDistA.NTypes, x@freqDistB.NTypes)
              tempdf <- data.frame(Freq=c(
                                       x@freqDistA,
                                       x@freqDistB),
                                   Rank=c(
                                       seq(x@freqDistA.NTypes),
                                       seq(x@freqDistB.NTypes)),
                                   Text=as.factor(c(
                                       rep(label1, x@freqDistA.NTypes),
                                       rep(label2, x@freqDistB.NTypes)))
                                   )
              log.plot.frame <- ggplot(tempdf,aes(x=log(Rank),y=log(Freq),shape=Text,colour=Text))
              log.plot <- log.plot.frame + geom_point(size=3) +
                  labs(x="log(Rank)",y="log(Frequency)",size=2) +
                      scale_colour_grey() +
                          theme_bw() +
                              theme(
                                  legend.position=c(.75, .7),
                                  axis.title.x=element_text(size=18),
                                  axis.title.y=element_text(size=18),
                                  legend.text=element_text(size=16),
                                  legend.title=element_text(size=16),
                                  title=element_text(size=16)
                                  )  
              freqDiff.plot <- qplot(log(seq(max_value)),
                                     x@freqDiff,
                                     geom="segment",
                                     yend=0,
                                     xend=log(seq(max_value)),
                                     size = I(3)
                                     ) +
                  theme_bw() +
                      labs(y=expression(paste(Delta, "Freq")), size=3) +
                          theme(axis.title.x=element_blank())
              log.plot
              freqDiff.plot
              gridExtra::grid.arrange(freqDiff.plot,
                                      log.plot,
                                      ncol=1,
                                      nrow=2,
                                      heights=c(1,3)
                                      )  
          })

setMethod("show", "nfd", function(object) {cat(object@nfd_value, "\n")})

setMethod("summary", signature="nfd", function(object, ...) {
              cat("Normalized Frequency Difference\n")
              cat("  FreqDistA.NTypes      :", object@freqDistA.NTypes, "\n")
              cat("  FreqDistB.NTypes      :", object@freqDistB.NTypes, "\n")
              cat("  FreqDistA.NTokens     :", object@freqDistA.NTokens, "\n")
              cat("  FreqDistB.NTokens     :", object@freqDistB.NTokens, "\n")
              cat("  NFD Value             :", object@nfd_value, "\n")
          })

NFD <- function(freqDistA, freqDistB) {
    if (is.character(freqDistA)) freqDistA <- freq.dist(freqDistA)
    if (is.character(freqDistB)) freqDistB <- freq.dist(freqDistB)
    new("nfd", freqDistA=freqDistA, freqDistB=freqDistB)
}

getNFD <- function(freqDistA, freqDistB) {
    ## wrapper function which returns directly the nfd value
    ## to be used with simulation
    n <- NFD(freqDistA, freqDistB)
    return (n@nfd_value)
}
