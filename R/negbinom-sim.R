##' Simulates species abundances along a single gradient simulated
##' from a negative binomial distribution assuming a Gaussian response
##' model.
##'
##' The response model used is the classical Gaussian response with
##' parameters \eqn{\mu}{mu}, the species optimum, \eqn{t}, the
##' species tolerance, and \eqn{h}, the height of the response curve
##' at the optimum.
##'
##' If \code{expectation = TRUE} the mean response for the parameters
##' is returned. If \code{expectation = FALSE} counts are drawn randomly
##' from a negative binomial distribution with mean (argument \code{lamba})
##' given by the Gaussian response.
##'
##' @section Note:
##' When called with \code{expectation = FALSE} the function does not use
##' the pseudorandom number generator, but when called with the defaults
##' two calls to the pseudorandom number generator are made.
##'
##' @title Simulate negative binomial counts along a single gradient
##'
##' @param x numeric; gradient locations.
##' @param opt numeric; species optima, one per taxon.
##' @param tol numeric; species tolerances, one per taxon.
##' @param h numeric; species abundance at optima, one per taxon.
##' @param alpha numeric; dispersion parameter for the negative binomial.
##' @param expectation logical; should expectations (mean response) be
##' returned?
##'
##' @return a matrix of simulated counts.
##'
##' @author Gavin L. Simpson
##'
##' @export
##'
##' @importFrom stats rpois rgamma
##'
##' @examples
##' set.seed(1)
##' x1 <- seq(from = 4, to = 6, length = 100)
##' Opt <- seq(4, 6, length = 5)
##' Tol <- rep(0.25, 5)
##' H <- rep(20, 5)
##' y <- sim1dNegbinom(x1, Opt, Tol, H, alpha = 1.1)
##'
##' y <- sim1dNegbinom(x1, Opt, Tol, H, expectation = TRUE)
##' matplot(x1, y, type = "l", lty = "solid")
##'
`sim1dNegbinom` <- function(x, opt, tol, h, alpha, expectation = FALSE) {
    n <- length(x)
    ex <- expandGauss(x, opt, tol, h)
    mu <- gaussianResponse(x = ex[,"x"], opt = ex[,"opt"],
                           tol = ex[,"tol"], h = ex[,"h"])
    if (expectation) {
        sim <- mu
    } else {
        nr <- nrow(ex)
        sim <- rpois(nr, mu * rgamma(nr, shape = alpha, rate = 1/alpha))
    }
    sim <- matrix(sim, nrow = n)
    sim
}

##' Simulates species abundances along two possibly correlated gradients
##' via simulation from a negative binomial distribution assuming a
##' Gaussian response model.
##'
##' The response model used is the classical Gaussian response with
##' parameters \eqn{\mu}{mu}, the species optimum, \eqn{t}, the
##' species tolerance, and \eqn{h}, the height of the response curve
##' at the optimum.
##'
##' If \code{expectation = TRUE} the mean response for the parameters
##' is returned. If \code{expectation = FALSE} counts are drawn randomly
##' from a negative binomial distribution with mean (argument \code{lamba})
##' given by the Gaussian response.
##'
##' @section Note:
##' When called with \code{expectation = FALSE} the function does not use
##' the pseudorandom number generator, but when called with the defaults
##' two calls to the pseudorandom number generator are made.
##'
##' @title Simulate negative binomial counts along two, possibly
##' correlated gradients
##' @param x1 numeric; locations along gradient 1.
##' @param x2 numeric; locations along gradient 2.
##' @param opt1 numeric; species optima on gradient 1, one per taxon.
##' @param tol1 numeric; species toleranceon gradient 1, one per taxon.
##' @param h numeric; species abundance at the optimum
##' @param opt2 numeric; species optima on gradient 2, one per taxon.
##' @param tol2 numeric; species tolerance on gradient 2, one per taxon.
##' @param corr numeric; the correlation between gradients.
##' @param alpha numeric; dispersion parameter for the negative binomial.
##' @param expectation logical; should expectations (mean response) be
##' returned?
##'
##' @return A matrix of simulate counts.
##'
##' @author Gavin L. Simpson
##'
##' @export
##'
##' @importFrom stats rpois rgamma
##'
##' @examples
##' set.seed(1)
##' x1 <- runif(300, min = 4, max = 6)
##' Opt1 <- seq(4, 6, length = 5)
##' Tol1 <- rep(0.25, 5)
##' x2 <- runif(300, min = 2, max = 20)
##' Opt2 <- seq(2, 20, length = 5)
##' Tol2 <- rep(1, 5)
##' H <- rep(20, 5)
##' y <- sim2dNegbinom(x1, x2, Opt1, Opt2, Tol1, Tol2, H,
##'                    corr = 0.5, alpha = 1.1)
##'
`sim2dNegbinom` <- function(x1, x2, opt1, tol1, h, opt2, tol2,
                            corr = 0, alpha, expectation = FALSE) {
    stopifnot(isTRUE(all.equal(n1 <- length(x1), n2 <- length(x2))))
    ex1 <- expandGauss(x1, opt1, tol1, h)
    ex2 <- expandGauss(x2, opt2, tol2, h)[, -4] ## don't need extra h
    colnames(ex1) <- c("x1", "opt1", "tol1", "h")
    colnames(ex2) <- c("x2", "opt2", "tol2")

    mu <- biGaussianResponse(x1 = ex1[, "x1"], x2 = ex2[, "x2"],
                             opt1 = ex1[, "opt1"], tol1 = ex1[, "tol1"],
                             opt2 = ex2[, "opt2"], tol2 = ex2[, "tol2"],
                             h = ex1[, "h"], corr = corr)
    if (expectation) {
        sim <- mu
    } else {
        mu <- mu * rgamma(nrow(ex1), shape = alpha, rate = 1/alpha)
        sim <- rpois(nrow(ex1), mu)
    }
    sim <- matrix(sim, nrow = n1)
    sim
}
