# Normalized Frequency Difference Estimator
Supporting package for [Bentz et al.](http://bit.ly/1KtlXzu)

# Installation notes

If you have `devtools` installed then you can install the package directly from github:

```r
library(devtools)
install_github("dimalik/nfd")
```

otherwise, you can clone the package and then install it either via the R GUI (or RStudio) or just invoke

```R
install.packages("path/to/zip", repos = NULL, type = "source")
```
# Using the package

In order to get the NFD value between two discrete distributions you simply call:

```R
library(nfd)

## first create two mini-corpora
corpusA <- "this is a test sentence"
corpusB <- "this is another test sentence"

## then find their frequency distributions
corpusA.fd <- create.frequency.distribution(corpusA)
corpusB.fd <- create.frequency.distribution(corpusB)

## find their nfd value
nfd(corpusA.fd, corpusB.fd)
## >
```
For more information on the derivation of the measure you can consult [Bentz et al. (2015)](http://bit.ly/1KtlXzu). For more on how to perform different kinds of simulations either check the wiki page or evaluate `?nfd`
