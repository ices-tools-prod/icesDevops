#' Perform a clone from the ICES devops git server
#'
#' user must have approprate access priviladges
#'
#' @param remote_url the url of the devops git repo
#' @param pat personal access token for devops
#' @param local_dir the local directory you want to clone into
#'
#' @return a git2r repository object
#'
#' @importFrom git2r clone remote_set_url
#' @importFrom glue glue
#'
#' @export
devops_clone <- function(remote_url, pat, local_dir = NULL) {

  # add pat to remote
  remote_url_pat <-
    glue(
      gsub(
        "https://",
        "https://pat:{pat}@",
        remote_url
      )
    )

  repo <-
    clone(
      remote_url_pat,
      if (is.null(local_dir)) basename(remote_url) else local_dir
    )

  # reset remote so that it does not hold pat
  remote_set_url(repo, name = "origin", url = remote_url)

  repo
}
