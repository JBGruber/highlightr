library("devtools")
library("roxygen2")

setwd(here::here())

## set for spelling package
Sys.setenv(NOT_CRAN = TRUE)

## Update date and version
update_description <- function() {
  desc <- readLines("DESCRIPTION")
  date <- desc[grepl("^Date:", desc)]
  date2 <- gsub("[^[:digit:]-]", "", date)
  desc[grepl("^Date:", desc)] <- gsub(date2, Sys.Date(), desc[grepl("^Date:", desc)])
  vers <- desc[grepl("^Version:", desc)]
  vers2 <- gsub("[^[:digit:].]", "", vers)
  vers3 <- readline(prompt = paste("New Version? Old:", vers2))
  if (vers3 == "") {
    vers3 <- vers2
  }
  desc[grepl("^Version:", desc)] <- gsub(vers2, vers3, desc[grepl("^Version:", desc)])
  writeLines(desc, "DESCRIPTION")
}
update_description()

## Update Citation
update_citation <- function() {
  cit <- readLines("./inst/CITATION")
  note <- grep("note =", cit)
  desc <- readLines("DESCRIPTION")
  date <- desc[grepl("^Date:", desc)]
  date2 <- gsub("[^[:digit:]-]", "", date)
  desc[grepl("^Date:", desc)] <- gsub(date2, Sys.Date(), desc[grepl("^Date:", desc)])
  vers <- desc[grepl("^Version:", desc)]
  vers2 <- gsub("[^[:digit:].]", "", vers)
  vers3 <- gsub("\\d+{3}", "", vers2)
  vers3 <- gsub("[[:punct:]]$", "", vers3)
  cit[note] <- gsub("\\d+.\\d+.\\d+", vers3, cit[note])
  writeLines(cit, "./inst/CITATION")
}
update_citation()

# update documentation
roxygen2::roxygenise(clean = TRUE)

# Checks
devtools::check()

spelling::update_wordlist()

lintr::lint_package()

devtools::install()


# build manual
system("cd .. && rm highlightr.pdf && R CMD Rd2pdf highlightr")


# For release on CRAN
## test on winbuilder
devtools::check_win_devel()
devtools::check_win_oldrelease()
devtools::check_win_release()

## check r_hub
devtools::check_rhub()

## release
devtools::release()
