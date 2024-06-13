#' targets: Archetypes for Targets
#' @description A pipeline toolkit for R, the `targets` package brings together
#'   function-oriented programming and Make-like declarative pipelines for
#'   Statistics and data science. The `tarchetypes` package provides
#'   convenient helper functions to create specialized targets, making
#'   pipelines in targets easier and cleaner to write and understand.
#' @name tarchetypes-package
#' @importFrom fs dir_ls is_dir path_ext_remove path_rel
#' @importFrom withr local_options
NULL

utils::globalVariables(".x")
