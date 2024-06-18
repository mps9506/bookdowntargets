#' bookdowntargets: tarchetype pipeline for bookdown reports.
#' @description A pipeline toolkit for R, the `targets` package brings together
#'   function-oriented programming and Make-like declarative pipelines for
#'   Statistics and data science. The `bookdowntargets` package provides a
#'   convenient helper function to create specialized targets.
#' @name bookdowntargets-package
#' @importFrom fs dir_ls is_dir path_ext_remove path_rel
#' @importFrom targets tar_assert_chr tar_assert_package tar_deparse_language tar_option_get tar_target_raw tar_tidy_eval
#' @importFrom withr local_options
NULL

utils::globalVariables(".x")
