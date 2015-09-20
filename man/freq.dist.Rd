\name{freq.dist}
\alias{freq.dist}
\title{Frequency Distribution of a Given Text}
\description{
  Helper function that returns the frequency distribution of a given
  \code{character vector}.
}

\usage{
freq.dist(string, df = FALSE)
}

\arguments{
  \item{string}{A character vector, either multielement
  (\code{strsplit}'d) or single-element (i.e. spaced corpus)}
  \item{df}{\code{logical}. Whether it returns a \code{data.frame} a
    \code{numeric vector}.}
}


\value{
  \item{\code{numeric}}{A \code{numeric vector} if \code{df = FALSE}
    containing the \code{sort}ed frequency values}.
  \item{\code{data.frame}}{If \code{df = TRUE} it returns a three-column
  \code{data.frame} containing the \code{sort}ed words their frequencies
  and their ranks.
   }
}
\references{
  Bentz et al. (2015)\url{http://bit.ly/1KtlXzu}
}
\author{
  Dimitrios Alikaniotis \email{da352@cam.ac.uk}
}

\seealso{\code{\link{NFD}}, \code{\link{getNFD}},
  \code{\link{TSsim}}}

\examples{
## load the demo corpora
data(udhr.demo)

freq.dist(udhr.demo$english, df = FALSE) # this should return a numeric
                                         # c(121, 106, 90, ...)

freq.dist(udhr.demo$english, df = TRUE) # this returns a data.frame
}