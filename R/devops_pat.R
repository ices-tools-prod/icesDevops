#' Perform a push to the ICES devops git server
#'
#' user must have approprate access priviladges
#'
#' @return the users devops paersonal access token
#'
#' @export
devops_pat <- function() {

  token <- Sys.getenv("ICESDEVOPS_PAT", "")

  if (token == "") {
    stop(
      "Cannot proceed without a personal access token",
      "Please see the instructions at: ",
      "https://github.com/ices-tools-prod/icesDevops#getting-and-saving-your-personal-access-token-pat",
    )
  }

  token
}
