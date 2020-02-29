#' Open a browser where you create ICES Devop personal access tokens
#'
#' user must have approprate access priviladges
#'
#' @return nothing - opens a web browser.
#'
#' @importFrom glue glue
#' @importFrom utils browseURL
#'
#' @export
browse_devops_tokens <- function() {
  url <- "https://devops.ices.dk/TAF/_usersSettings/tokens"
  if (interactive()) {
    message(glue("Opening URL {url}"))
    browseURL(url)
  }
  else {
    message(glue("Open URL {url}"))
  }

  message("Call 'usethis::edit_r_environ()' to open '.Renviron'.")
  message("Store your PAT with a line like:")
  message("ICESDEVOPS_PAT=xxxyyyzzz")
  message("Make sure '.Renviron' ends with a newline!")
  invisible()
}
