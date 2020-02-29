#' Perform a GET request to devops server
#'
#' Must be run in interactive mode.  User is promted for a password, and if successful
#' a Javascript Web Token (JWT) is saved to the project root (current working directory).
#' The token will last for 1 hour, after which the user needs to update the token using
#' this function again.
#'
#' @param instance the address of the devops server, default is
#'   "devops.ices.dk"
#' @param collection the collection current default is "TAF"
#' @param team_project optional, which team-project
#' @param resource required, name of resource being requested
#' @param area optional, which area within the resource
#' @param version state the version of the api being targeted, default
#'  "5.1"
#'
#' @return url string
#'
#' @details
#'
#' https://docs.microsoft.com/en-us/rest/api/azure/devops/?view=azure-devops-rest-5.1
#'
#' @importFrom glue glue
#' @export

devops_url <- function(
    resource,
    area,
    team_project,
    version = "5.1",
    collection = "TAF",
    instance = "devops.ices.dk"
  )
{
  glue(
    "https://{instance}/{collection}",
    if (missing(team_project)) "" else "/{team_project}",
    "/_apis",
    if (missing(area)) "" else "/{area}",
    "/{resource}?api-version={version}"
  )
}
