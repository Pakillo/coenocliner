% Generated by roxygen2 (4.0.1): do not edit by hand
\name{sim2dBinom}
\alias{sim2dBinom}
\title{Simulate species occurrence along two, possibly correlated gradients}
\usage{
sim2dBinom(x1, x2, opt1, tol1, h, opt2, tol2, corr = 0, expectation = FALSE)
}
\arguments{
\item{x1}{numeric; locations along gradient 1.}

\item{x2}{numeric; locations along gradient 2.}

\item{opt1}{numeric; species optima on gradient 1, one per taxon.}

\item{tol1}{numeric; species tolerance on gradient 1, one per taxon.}

\item{h}{numeric between 0 and 1; species probability of presence at the optimum.}

\item{opt2}{numeric; species optima on gradient 2, one per taxon.}

\item{tol2}{numeric; species tolerance on gradient 2, one per taxon.}

\item{corr}{numeric; the correlation between gradients.}

\item{expectation}{logical; should expectations (probability of presence) rather than
discrete occurrence be returned?}
}
\value{
a matrix of simulated occurrences (if \code{expectation = FALSE}).
A matrix of probability of presence along the environmental gradients otherwise.
}
\description{
Simulates species occurrence along two possibly correlated gradients
via simulation from a binomial distribution assuming a
Gaussian response model.
}
\details{
The response model used is the classical Gaussian response with
parameters \eqn{\mu}{mu}, the species optimum, \eqn{t}, the
species tolerance, and \eqn{h}, the height of the response curve
at the optimum (see \code{\link{biGaussianResponse}}).

If \code{expectation = FALSE} species occurrence (either presence or absence)
is drawn randomly from a binomial distribution with probability given
by the Gaussian response.
If \code{expectation = TRUE} then a continuous probability of presence (according to
the Gaussian response) is returned.
}
\section{Note}{

When called with \code{expectation = FALSE} the function does not use
the pseudorandom number generator, but when called with the defaults
a single call to pseudorandom number generator is made.
}
\examples{
## One species:
set.seed(1)
x1 <- runif(100, 0, 30)
Opt1 <- 18
Tol1 <- 5
x2 <- runif(100, 400, 1000)
Opt2 <- 800
Tol2 <- 100
H <- 0.8
y <- sim2dBinom(x1, x2, Opt1, Tol1, H, Opt2, Tol2, corr = 0, expectation = TRUE)

## Multiple species
set.seed(1)
nsp <- 5
x1 <- runif(100, min = 0, max = 30)
Opt1 <- seq(5, 25, length = nsp)
Tol1 <- rep(5, nsp)
x2 <- runif(100, min = 400, max = 1000)
Opt2 <- seq(500, 900, length = nsp)
Tol2 <- rep(100, nsp)
H <- rep(0.9, 5)
y <- sim2dBinom(x1, x2, Opt1, Tol1, H, Opt2, Tol2, corr = 0.2)
}
\author{
F. Rodriguez-Sanchez, based on code by Gavin L. Simpson
}
\seealso{
\code{\link{biGaussianResponse}}
}

