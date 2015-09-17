# Normalized Frequency Difference Estimator
Supporting package for [Bentz et al.](http://bit.ly/1KtlXzu)

# Installation notes

```r
library(devtools)
install_github("dimalik/nfd")
library("nfd")
```
# Using the package

In order to get the NFD value between two discrete distributions you simply call:

```R
corpusA <- "this is a test sentence"
corpusB <- "this is another test sentence"

nfd(corpusA, corpusB)
```
