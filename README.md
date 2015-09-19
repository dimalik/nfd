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

## Demo dataset

The package also includes as a demo corpus the english and italian translations of the UDHR on which you can either find the NFD value or run a text size simulation.

```R
data(udhr.demo)

nfd.score <- NFD(udhr.demo$english, udhr.demo$italian)

text.size.sim <- TSsim(udhr.demo$english, udhr.demo$italian, max.size = 1000, random.sampling = TRUE)
```

## Tips

- If you are going to run a text size simulation on larger corpora (> 100000 tokens) consider either setting the `random.sampling = FALSE` or provide a more sparse sequence in `max.size` (for an example see below)


### Example of `max.size` sequence

Suppose you have two 10mio token corpora you wish to find how the NFD value changes as we increase the text size. Running with `random.sampling = TRUE` would be too cumbersome to run so it might be a good idea to take random text sizes:

```R

my.max.size <- sort(sample(1e7, 50000, replace = FALSE))

```

you might also expect that as the size increases the differences are going to be much smaller (there is going to be minimial variation between 5 * 1e6 and 5 * 1e6 + 1). You can, therefore, supply a vector of probabilities on your call to sample such that you can weight more early values:

```R

## some sort of weighting function

max.size <- 1e7

wf <- function(k, t) 1 - ((k * t) / (k - t + 1)) 

rng <- linspace(0, 1, max.size)

probs <- wf(rng, .9)

## you can also try
##  probs <- wf(.9, rng)

my.max.size <- sort(sample(max.size, 5000, replace = FALSE, prob = probs))

```

For more information on the derivation of the measure you can consult [Bentz et al. (2015)](http://bit.ly/1KtlXzu). For more on how to perform different kinds of simulations either check the wiki page or evaluate `?nfd`
