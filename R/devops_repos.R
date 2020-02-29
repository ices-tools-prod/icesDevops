#' Get a list of repositories
#'
#' This will list all the repositories you have read access too
#'
#' @param ... additional arguments to GET
#' @param all show all columns, default = FALSE
#'
#' @return a data.frame
#'
#' @importFrom httr content
#'
#' @export
devops_repos <- function(..., all = FALSE) {
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
  repos <- cont$value

  if (all) {
    repos
  } else {
    # only show some of the content, for simplicity
    repos[c("name", "webUrl", "remoteUrl", "sshUrl")]
  }
}
