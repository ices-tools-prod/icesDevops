#' Get a list of repositories
#'
#' This will list all the repositories you have read access too
#'
#' @param pat devops personal access token
#' @param ... additional arguments to GET
#'
#' @return a data.frame
#'
#' @importFrom httr content
#'
#' @export
devops_repos <- function(...) {
  # get a list of repositories
  res <-
    devops_get(
      devops_url(
        "repositories",
        area = "git"
      ),
      ...
    )
  cont <- content(res, simplifyVector = TRUE)

  # only show some of the content, for simplicity
  repos <- cont$value
  repos[c("name", "webUrl", "remoteUrl", "sshUrl")]
}
