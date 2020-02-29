#' Perform a push to the ICES devops git server
#'
#' user must have approprate access priviladges
#'
#' @param repo optional, a repository (git2r) or path, defaults to
#'  current workng directory.
#' @param pat personal access token for devops
#'
#' @return a git2r push object
#'
#' @importFrom git2r push remote_set_url remote_url
#' @importFrom glue glue
#'
#' @export
devops_push <- function(repo = ".", pat = devops_pat()) {

  # get current remote url
  remote_url <- remote_url(repo)

  # add pat to remote
  remote_url_pat <-
    glue(
      gsub(
        "^https://|^https://.*@",
        "https://pat:{pat}@",
        remote_url
      )
    )
  remote_set_url(repo, name = "origin", url = remote_url_pat)

  # push changes
  out <- push(repo)

  # reset remote so that it does not hold pat
  remote_set_url(repo, name = "origin", url = remote_url)

  out
}
