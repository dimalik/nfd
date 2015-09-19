# Normalized Frequency Difference Estimator

Supporting package for the Normalized Frequency Difference metric as described in [Bentz et al.](http://bit.ly/1KtlXzu).

# Installation notes

If you already have `devtools` then you can install the package directly from github:

```r
library(devtools)
install_github("dimalik/nfd")
```

otherwise, you can clone the package (or download the .zip file) and then install it either via the R GUI (or RStudio) or just invoke:

```r
install.packages("path/to/zip", repos = NULL, type = "source")
```

# Using the package

In order to get the NFD value between two discrete distributions you simply call:

```r

library(nfd)

## example distributions from pg. 6 of the paper

freqA <- c(45, 20, 15, 10, 5, 1, 1, 1, 1, 1)
freqB <- rep(10, 10)

NFD(freqA, freqB)
## > 0.5
```

`NFD` actually returns an R object which implements its own generic functions (such as `print`, `summary` and `plot`). You can, therefore, run:

```R
n <- NFD(freqA, freqB)
summary(n) # a nicely output summary
plot(n)    # a ggplot such as the ones in pg. 11
```

## Demo dataset

The package also includes as a demo corpus the english and italian translations of the UDHR on which you can either find the `NFD` value or run a text size simulation.

```R
data(udhr.demo)

nfd.score <- NFD(udhr.demo$english, udhr.demo$italian)
```

## Effect of text size simulations

The `nfd` package also provided another class that helps you run simulations to find the effect of text size on the `NFD` (or any similar measure).

```R
text.size.sim <- TSsim(udhr.demo$english, udhr.demo$italian, max.size = 1000, random.sampling = TRUE)
```

- `max.size` controls the text size. It implicitly creates a sequence (i.e. `2:max.size`) which at each step takes that big a chunk from each corpus. This assumes that `max.size < min(length(corpus1), length(corpus2))`. If this does not hold `max.size` is trimmed to be smaller than the smaller corpus. For larger corpora it is advisable to provide a custom sampling sequence (see below).
- `random.sampling` controls whether the samples taken from the corpora will be random or from the beginning.

For more details see Analysis 3 in the paper.

## Tips

- If you are going to run a text size simulation on larger corpora (> 100000 tokens) consider either setting the `random.sampling = FALSE` or provide a more sparse sequence in `max.size` (for an example see below)
- Both `NFD` and `TSsim` are `S4` objects the contents of which can be accessed using the `@` symbol. For example, in order to get the `nfd_value` from an `NFD` object you can type `n@nfd_value`. Both classes provide a getValue() method which returns the `nfd_value` and the vector of nfd values, respectively.
- The `TSsim` class lets you specify the frequency difference function (through `fun = `). While the default is NFD you can use any function that given two vectors of numbers returns a scalar.

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

rng <- seq(0, 1, length.out = max.size)

probs <- wf(rng, .9)

## you can also try
##  probs <- wf(.9, rng)

my.max.size <- sort(sample(max.size, 5000, replace = FALSE, prob = probs))

```

For more information on the derivation of the measure you can consult [Bentz et al. (2015)](http://bit.ly/1KtlXzu). For more on how to perform different kinds of simulations either check the wiki page or evaluate `?nfd`
