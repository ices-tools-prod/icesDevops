
\[![Build
Status](https://travis-ci.org/ices-tools-prod/icesDevops.svg?branch=devel)\]
(<https://travis-ci.org/ices-tools-prod/icesDevops>) \[![CRAN
Status](http://r-pkg.org/badges/version/icesDevops)\]
(<https://cran.r-project.org/package=icesDevops>) \[![CRAN
Monthly](http://cranlogs.r-pkg.org/badges/icesDevops)\]
(<https://cran.r-project.org/package=icesDevops>) \[![CRAN
Total](http://cranlogs.r-pkg.org/badges/grand-total/icesDevops)\]
(<https://cran.r-project.org/package=icesDevops>)

[<img align="right" alt="ICES Logo" width="17%" height="17%"
  src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

``` r
library(knitr)
library(icesDevops)
```

# icesDevops

icesDevops functions to link to the ICES Devops webservices to allow
users to interact with ICES TAF git repositoroes, and download summaries
and data products from ICES TAF repositories.

icesDevops is implemented as an [R](https://www.r-project.org) package
<!-- and available on [CRAN](https://cran.r-project.org/package=icesDevops). -->
and available on GitHub

## Installation

icesVMS can be installed from GitHub using the `install_github` command
from the `remotes` package:

``` r
library(remotes)
install_github("ices-tools-prod/icesDevops")
```

## Usage

For a summary of the package:

``` r
library(icesDevops)
?icesDevops
```

## Examples

## getting and saving your Personal Access Token (PAT)

TODO: need to write this

## list repositories you have access to

To get a list of the repositories you have access to use the following
conveinience function, what it does in more detail is listed below.

``` r
devops_repos(pat)
```

    ## GETing ...https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1

    ##                               name
    ## 1         2019_sol.27.4_assessment
    ## 2 2019_hke.27.3a46-8abd_assessment
    ## 3                             test
    ##                                                                          webUrl
    ## 1         https://devops.ices.dk/TAF/repositories/_git/2019_sol.27.4_assessment
    ## 2 https://devops.ices.dk/TAF/repositories/_git/2019_hke.27.3a46-8abd_assessment
    ## 3                             https://devops.ices.dk/TAF/repositories/_git/test
    ##                                                                       remoteUrl
    ## 1         https://devops.ices.dk/TAF/repositories/_git/2019_sol.27.4_assessment
    ## 2 https://devops.ices.dk/TAF/repositories/_git/2019_hke.27.3a46-8abd_assessment
    ## 3                             https://devops.ices.dk/TAF/repositories/_git/test
    ##                                                                           sshUrl
    ## 1         ssh://devops.ices.dk:22/TAF/repositories/_git/2019_sol.27.4_assessment
    ## 2 ssh://devops.ices.dk:22/TAF/repositories/_git/2019_hke.27.3a46-8abd_assessment
    ## 3                             ssh://devops.ices.dk:22/TAF/repositories/_git/test

At the lowest level, this is how this is done. First form the url, then
perform the GET request. Note you will need to have created a Personal
Access Token (PAT) and saved this in a variable called `pat` for this
line to work.

``` r
res <-
  devops_get(
    devops_url(
      "repositories",
      area = "git"
    ),
    pat
  )
```

    ## GETing ...https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1

``` r
res
```

    ## Response [https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1]
    ##   Date: 2020-02-29 17:42
    ##   Status: 200
    ##   Content-Type: application/json; charset=utf-8; api-version=5.1
    ##   Size: 2.38 kB

once you have the response, you can extract the content, and parse into
a simplyfied structure (where possible, lists are converted to
data.frames)

``` r
cont <- httr::content(res, simplifyVector = TRUE)

# only show some of the content, for simplicity
repos <- cont$value
repos[c("name", "webUrl")]
```

    ##                               name
    ## 1         2019_sol.27.4_assessment
    ## 2 2019_hke.27.3a46-8abd_assessment
    ## 3                             test
    ##                                                                          webUrl
    ## 1         https://devops.ices.dk/TAF/repositories/_git/2019_sol.27.4_assessment
    ## 2 https://devops.ices.dk/TAF/repositories/_git/2019_hke.27.3a46-8abd_assessment
    ## 3                             https://devops.ices.dk/TAF/repositories/_git/test

## clone a repository

``` r
# get repository list
repos <- devops_repos(pat)
```

    ## GETing ...https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1

``` r
# get remote url
remote_url <- repos$remoteUrl[repos$name == "test"]
# clone (into a temporary directory)
repo <-
  devops_clone(
    remote_url,
    pat,
    local_dir = file.path(tempdir(), "test")
  )
```

    ## cloning into 'C:\Users\colin\AppData\Local\Temp\RtmpcDZ0kx/test'...
    ## Receiving objects:   5% (1/19),    3 kb
    ## Receiving objects:  15% (3/19),    3 kb
    ## Receiving objects:  21% (4/19),    3 kb
    ## Receiving objects:  31% (6/19),    3 kb
    ## Receiving objects:  42% (8/19),    3 kb
    ## Receiving objects:  52% (10/19),    3 kb
    ## Receiving objects:  63% (12/19),    3 kb
    ## Receiving objects:  73% (14/19),    3 kb
    ## Receiving objects:  84% (16/19),    3 kb
    ## Receiving objects:  94% (18/19),    3 kb
    ## Receiving objects: 100% (19/19),    3 kb, done.

``` r
repo
```

    ## Local:    master C:/Users/colin/AppData/Local/Temp/RtmpcDZ0kx/test
    ## Remote:   master @ origin (https://devops.ices.dk/TAF/repositories/_git/test)
    ## Head:     [d294e33] 2020-02-29: test changes

## make a change to a repo, commit and push

``` r
# move into repo and make changes
old_dir <- setwd(workdir(repo))
# run taf.skeleton to ensure all taf files exist
icesTAF::taf.skeleton()
# as a test add some comments to the end of data.R
cat("# some more comments on", date(), file = "data.R", append = TRUE)
setwd(old_dir)

git2r::status(repo)
```

    ## Unstaged changes:
    ##  Modified:   data.R

``` r
# add all files
git2r::add(repo, path = "*")
git2r::status(repo)
```

    ## Staged changes:
    ##  Modified:   data.R

``` r
# commit
git2r::commit(repo, all = TRUE, message = "test changes")
```

    ## [9554806] 2020-02-29: test changes

``` r
git2r::status(repo)
```

    ## working directory clean

``` r
# push!
devops_push(repo, pat = pat)
#Sys.sleep(1)

repo
```

    ## Local:    master C:/Users/colin/AppData/Local/Temp/RtmpcDZ0kx/test
    ## Remote:   master @ origin (https://devops.ices.dk/TAF/repositories/_git/test)
    ## Head:     [9554806] 2020-02-29: test changes

# References
