#' Get a list of devops builds
#'
#' This will list all the builds you have read access too
#'
#' @param ... additional arguments to GET
#' @param all show all columns, default = FALSE
#'
#' @return a data.frame
#'
#' @importFrom httr content
#'
#' @export
devops_builds <- function(..., all = FALSE) {
  # get a list of repositories
  res <-
    devops_get(
      devops_url(
      "builds",
      area = "build",
      team_project = "repositories"
    ),
    ...
  )
  cont <- content(res, simplifyVector = TRUE)
  builds <- cont$value

  if (all) {
    builds
  } else {
    # only show some of the content, for simplicity
    builds[
      c(
        "id", "buildNumber", "status", "result", "startTime", "finishTime",
        "url",
        "sourceBranch",
        "sourceVersion",
        "repository"
      )
    ]
  }
}
