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
corpusA <- "this is a test sentence"
corpusB <- "this is another test sentence"

nfd(corpusA, corpusB)
```
