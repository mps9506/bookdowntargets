#' targets: Archetypes for Targets
#' @description A pipeline toolkit for R, the `targets` package brings together
#'   function-oriented programming and Make-like declarative pipelines for
#'   Statistics and data science. The `tarchetypes` package provides
#'   convenient helper functions to create specialized targets, making
#'   pipelines in targets easier and cleaner to write and understand.
#' @name bookdowntargets-package
#' @importFrom fs dir_ls is_dir path_ext_remove path_rel
#' @importFrom targets tar_assert_chr tar_assert_package tar_assert_path tar_deparse_language tar_option_get tar_target_raw tar_tidy_eval
#' @importFrom withr local_options
NULL

utils::globalVariables(".x")
