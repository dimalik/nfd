\name{NFD}
\alias{NFD}
\title{Normalized Frequency Difference Calculator}
\description{
  Calculates the Normalized Frequency Difference between two frequency
  distributions as described in Bentz et al. (2015).
}
\usage{
NFD(freqDistA, freqDistB)
}
\arguments{
  \item{freqDistA}{A numeric or character vector}
  \item{freqDistB}{A numeric or character vector}
}
\details{
  The absolute difference of the respective ranks divided by the sum of
  the frequencies in the two distributions. More precisely,

  \deqn{NFD(A, B) = \frac{\sum |A[i] - B[i]|}{\sum A + \sumB}}

  for \code{i:max(length(A), length(B))}. For more on the derivation and uses
  of this metric consult Bentz et al. (2015).
}
\value{
  \item{\code{nfd}}{\code{S4 object}, containing all the calculation information.}
}
\references{
  Bentz et al. (2015)\url{http://bit.ly/1KtlXzu}
}
\author{
  Dimitrios Alikaniotis \email{da352@cam.ac.uk} and Christian Bentz \email{cb696@cam.ac.uk}
}
\seealso{\code{\link{TSsim}}, \code{\link{getNFD}},
    \code{\link{freq.dist}}}
  
\examples{
## load the demo corpora
data(udhr.demo)

NFD(udhr.demo$english, udhr.demo$italian)
}