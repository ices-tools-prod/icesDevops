% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/devops_url.R
\name{devops_url}
\alias{devops_url}
\title{Perform a GET request to devops server}
\usage{
devops_url(
  resource,
  area,
  team_project,
  version = "5.1",
  collection = "TAF",
  instance = "devops.ices.dk"
)
}
\arguments{
\item{resource}{required, name of resource being requested}

\item{area}{optional, which area within the resource}

\item{team_project}{optional, which team-project}

\item{version}{state the version of the api being targeted, default
"5.1"}

\item{collection}{the collection current default is "TAF"}

\item{instance}{the address of the devops server, default is
"devops.ices.dk"}
}
\value{
url string
}
\description{
Must be run in interactive mode.  User is promted for a password, and if successful
a Javascript Web Token (JWT) is saved to the project root (current working directory).
The token will last for 1 hour, after which the user needs to update the token using
this function again.
}
\details{
https://docs.microsoft.com/en-us/rest/api/azure/devops/?view=azure-devops-rest-5.1
}
