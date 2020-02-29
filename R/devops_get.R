#' Perform a GET request to devops server
#'
#' Must be run in interactive mode.  User is promted for a password, and if successful
#' a Javascript Web Token (JWT) is saved to the project root (current working directory).
#' The token will last for 1 hour, after which the user needs to update the token using
#' this function again.
#'
#' @param url the url of the devops api
#' @param pat devops personal access token
#' @param ... additional arguments to GET
#'
#' @return http response object
#'
#' @importFrom httr GET authenticate accept
#'
#' @export
devops_get <- function(url, pat, ...) {
  message("GETing ...", url)

  httr::GET(
    url,
    httr::authenticate("", pat, type = "basic"),
    httr::accept("application/json"),
    ...
  )
}
