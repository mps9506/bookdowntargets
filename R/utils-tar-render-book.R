
# Find dependencies in all RMarkdown documents that will be rendered in
# bookdown.
tar_bookdown_deps <- function(path) {

    do.call(c,
            lapply(
              fs::dir_ls(path, regexp = "Rmd$", ignore.case = TRUE),
              function(file) {
                tarchetypes::tar_knitr_deps(file)
              }
            )
    )

}

# Adapted from tarchetypes:::tar_render_command
tar_render_book_command <- function(path, args) {
  args$input <- path
  args$knit_root_dir <- quote(getwd())

  if(fs::is_dir(path)){
    deps <- call_list(as_symbols(
      tar_bookdown_deps(path)
    ))
  } else {
    deps <- lapply(c(path), tarchetypes::tar_knitr_deps)
  }

  fun <- as.symbol("tar_render_book_run")
  exprs <- list(fun, path = path, args = args, deps = deps)

  as.expression(as.call(exprs))
}

# From tarchetypes:::tar_render_run
#' Render an bookdown report inside a `tar_render_book()` target.
#' @description
#' Internal function needed for `tar_render_book()`.
#' Users should not invoke it directly.
#' @export
#' @keywords internal
#' @return Character vector with the path to the R Markdown source file
#'   and the relative path to the output. These paths depend on the input
#'   source file path and have no defaults.
#' @param path Path to bookdown directory
#' @param args Named list of arguments to `bookdown::render_book()`.
#' @param deps An unnamed list of target dependencies of the R Markdown
#'   report, automatically created by `tar_bookdown_deps()`.
#' @import targets withr
#' @importFrom targets tar_envir
#' @importFrom bookdown render_book
#'
tar_render_book_run <- function (path, args, deps)
{
  targets::tar_assert_package("bookdown")
  withr::local_options(list(crayon.enabled = NULL))
  envir <- parent.frame()
  args$envir <- args$envir %|||% targets::tar_envir(default = envir)
  force(args$envir)
  output <- do.call(bookdown::render_book, args)
  output <- fs::path_real(output)
  source <- fs::path_real(path)

  if(fs::is_dir(source)) {
    ## if the path == working directory, we don't need to return the _targets
    ## subdirectory
    if(fs::path_real(fs::path_wd()) == source) {
      files <- fs::dir_ls(source,
                          regexp = "(_targets)$",
                          invert = TRUE)
    } else {
      files <- fs::dir_ls(source)
    }
  } else {
    files <- source
  }


  out <- unique(c(sort(output), sort(files)))
  out <- as.character(fs::path_rel(out))


  return(out)
}



