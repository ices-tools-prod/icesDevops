
[![Build
Status](https://travis-ci.org/ices-tools-prod/icesDevops.svg?branch=devel)](https://travis-ci.org/ices-tools-prod/icesDevops)
[![CRAN
Status](http://r-pkg.org/badges/version/icesDevops)](https://cran.r-project.org/package=icesDevops)
[![CRAN
Monthly](http://cranlogs.r-pkg.org/badges/icesDevops)](https://cran.r-project.org/package=icesDevops)
[![CRAN
Total](http://cranlogs.r-pkg.org/badges/grand-total/icesDevops)](https://cran.r-project.org/package=icesDevops)

[<img align="right" alt="ICES Logo" width="17%" height="17%"
  src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

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

To create a PAT login to <https://devops.ices.dk> and follow the
instructions in this
[link](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops-2019&tabs=preview-page)

once you have created the token you need to save it somewhere that is
accessible only to you. You must **store this token somewhere** because
you’ll never be able to see it again, once you leave that page or close
the windows. If you somehow goof this up, just generate a new PAT and,
so you don’t confuse yourself, delete the lost token.

It is customary to save the PAT as an environment variable in your
`.Renviron`, with the name `ICESDEVOPS_PAT`.

``` r
library(usethis)
edit_r_environ()
```

`usethis::edit_r_environ()` will open `.Renviron` for editing. Add a
line like this, **but substitute your PAT**:

``` sh
ICESDEVOPS_PAT=8c70fd8419398999c9ac5bacf3192882193cadf2
```

Make sure this file ends in a newline\! Lack of a newline can lead to
silent failure to load this environment variable, which can be tricky to
debug.

Restart R and confirm your PAT is now available:

``` r
Sys.getenv("ICESDEVOPS_PAT")
# or
devops_pat()
```

## list repositories you have access to

To get a list of the repositories you have access to use the following
conveinience function, what it does in more detail is listed below.

``` r
devops_repos()
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
    )
  )
```

    ## GETing ...https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1

``` r
res
```

    ## Response [https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1]
    ##   Date: 2020-02-29 19:14
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
repos <- devops_repos()
```

    ## GETing ...https://devops.ices.dk/TAF/_apis/git/repositories?api-version=5.1

``` r
# get remote url
remote_url <- repos$remoteUrl[repos$name == "test"]
# clone (into a temporary directory)
repo <-
  devops_clone(
    remote_url,
    local_dir = file.path(tempdir(), "test")
  )
```

    ## cloning into 'C:\Users\colin\AppData\Local\Temp\RtmpUbWoDh/test'...
    ## Receiving objects:   2% (1/34),    5 kb
    ## Receiving objects:  11% (4/34),    5 kb
    ## Receiving objects:  23% (8/34),    5 kb
    ## Receiving objects:  32% (11/34),    5 kb
    ## Receiving objects:  41% (14/34),    5 kb
    ## Receiving objects:  52% (18/34),    5 kb
    ## Receiving objects:  61% (21/34),    5 kb
    ## Receiving objects:  73% (25/34),    5 kb
    ## Receiving objects:  82% (28/34),    5 kb
    ## Receiving objects:  91% (31/34),    5 kb
    ## Receiving objects: 100% (34/34),    5 kb, done.

``` r
repo
```

    ## Local:    master C:/Users/colin/AppData/Local/Temp/RtmpUbWoDh/test
    ## Remote:   master @ origin (https://devops.ices.dk/TAF/repositories/_git/test)
    ## Head:     [c1a6758] 2020-02-29: test changes

## make a change to a repo, commit and push

``` r
# move into repo and make changes
old_dir <- setwd(workdir(repo))
# run taf.skeleton to ensure all taf files exist
icesTAF::taf.skeleton()
# as a test add some comments to the end of data.R
cat("# some more comments on", date(), "\n", file = "data.R", append = TRUE)
setwd(old_dir)

git2r::status(repo)
```

    ## Unstaged changes:
    ##  Modified:   data.R

``` r
# add all files
git2r::add(repo, path = "*")
# commit
git2r::commit(repo, all = TRUE, message = "test changes")
```

    ## [19bb9b6] 2020-02-29: test changes

``` r
# push!
devops_push(repo)
```

    ## NULL

# References
