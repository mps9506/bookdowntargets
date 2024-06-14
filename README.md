
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bookdowntargets

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/mps9506/bookdowntargets/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mps9506/bookdowntargets/actions/workflows/R-CMD-check.yaml)
[![bookdowntargets status
badge](https://mps9506.r-universe.dev/badges/bookdowntargets)](https://mps9506.r-universe.dev/bookdowntargets)
[![codecov](https://codecov.io/gh/mps9506/bookdowntargets/graph/badge.svg?token=XPzgCybMuv)](https://codecov.io/gh/mps9506/bookdowntargets)
<!-- badges: end -->

Experimental package implementing the targets pipeline for bookdown
projects as shown in this
[demo](https://github.com/jdtrat/tar-render-book-demo) by
[@jdtrat](https://github.com/jdtrat). There are no promises this will be
submitted to CRAN.

## To do

- [ ] Ensure `tar_render_book()` works for rmd files located in the main
  project directory. Currently, it works as expected when the bookdown
  files are in a sub directory of the project.
- [ ] How to generate an example? Maybe just in the Readme.
- [ ] Unit tests.

## Installation

``` r
install.packages("bookdowntargets", repos = c("https://mps9506.r-universe.dev", "https://cloud.r-project.org"))
```

## Example

This package has one function: `tar_render_book()`. This is a drop in
replacement for
[`tarchetypes::tar_render()`](https://github.com/ropensci/tarchetypes)
but points to a directory with bookdown files.

Note that `tar_render_book()` tracks dependency files (`_output.yml`,
`_bookdown.yml`) and these files are expected to be in the same
directory as the `index.Rmd` file. Targets should also track changes in
`.bib`, `.lua`, or other files in the same directory that if changed,
will result in `tar_make()` running the target again.

``` r
library(targets)
library(bookdowntargets)
list(
  tar_target(dataset, data.frame(x = letters)),
  tar_render_book(report, path = "report_directory")
)
```
