\name{TSsim}
\alias{TSsim}
\title{Effect of text size on frequency differences}
\description{
  Performs simulations on various text sizes to find how the difference
  score evolves (see Analysis 3 in Bentz et al. (2015)).
}
\usage{
TSsim(corpusA, corpusB, fun = getNFD, max.size = 1:20, random.sampling =
TRUE, verbosity = 2)
}
\arguments{
  \item{corpusA}{A character vector.}
  \item{corpusB}{A character vector.}
  \item{fun}{A frequency difference function (see Details).}
  \item{max.size}{A numeric vector. It can either be a scalar which
    implies \code{1:max:size} or a monotonically ascending
    sequence (see Details).}
  \item{random.sampling}{logical, whether the samples are going to be
    taken randomly from the corpora or from start to end.}
  \item{verbosity}{A scalar.}
}
\details{
  
  Function to run simulations to find the effect of text size on any
  frequency difference measure as specified in \code{fun}. \code{fun}
  has to be a function taking two arguments (both of class
  \code{character} returning a scalar (Note that instead on \code{NFD} here you
  can use \code{getNFD()})). The simulation then is going to be run calling
  this function repeatedly as many times as it is specified in
  \code{max.size}.
  
  The parameter \code{max.size} controls the sizes of the text we wish
  to find the \code{NFD} value for. It can either be a scalar or a
  monotonically increasing sequence. If you supply a scalar it assumes a
  sequence \code{1:max.size}.

  \code{random.sampling} controls whether the samples are going to be
  taken randomly from the entire corpus or sequentially from the
  beginning. While it is advisable to have this always on in order to
  avoid skewness problems, in practice it does not have any significant
  effect (see Analysis 3 in Bentz et al. (2015)) as well as it
  introduces a computational bottleneck on larger corpora.
}

\note{
  For large datasets (especially if you have provided
  \code{random.sampling = TRUE} it is advisable to use a custom sequence
  (e.g. \code{seq(1, 1e7, 1e3)}) as it would alleviate some of the overhaul of
  repeatedly sampling from very large texts. (see github README.md for
  another example)
}

\value{
  \item{\code{text.size.simulation}}{\code{S4 object},
    containing all the simulation details.}
}
\references{
  Bentz et al. (2015)\url{http://bit.ly/1KtlXzu}
}
\author{
  Dimitrios Alikaniotis \email{da352@cam.ac.uk}
}

\seealso{\code{\link{NFD}}, \code{\link{getNFD}},
  \code{\link{freq.dist}}}

\examples{
## load the demo corpora
data(udhr.demo)

tssim <- TSsim(udhr.demo$english, udhr.demo$italian, max.size = 1000,
random.sampling = TRUE)

summary(tssim)
}