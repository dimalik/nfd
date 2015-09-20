\name{getNFD}
\alias{getNFD}
\title{Normalized Frequency Difference calculator}
\description{
  Wrapper function for \code{NFD} which returns the \code{nfd_value} as
  a scalar to be used with \code{TSsim}.
}
\usage{
getNFD(freqDistA, freqDistB)
}
\arguments{
  \item{freqDistA}{A numeric or character vector}
  \item{freqDistB}{A numeric or character vector}
}
\details{
  see \code{?NFD} for more information on the calculation.
}
\value{
  \item{\code{numeric}}{The \code{NFD} value between the two
    \code{freqDist}s as a \code{scalar}}.
}
\references{
  Bentz et al. (2015)\url{http://bit.ly/1KtlXzu}
}
\author{
  Dimitrios Alikaniotis \email{da352@cam.ac.uk}
}
\seealso{\code{\link{TSsim}}, \code{\link{NFD}},
    \code{\link{freq.dist}}}
  
\examples{
## load the demo corpora
data(udhr.demo)

getNFD(udhr.demo$english, udhr.demo$italian)
}