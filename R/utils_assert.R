#' Assertions
#'
#' Asserts the correctness of user inputs and generate custom error conditions
#'   as needed.
#' @param x R object to be validated.
#' @param msg Character of length 1, a message to be printed to the console if
#'   `x` is invalid.
#'
#' @export
#' @keywords internal
#'
#' @examples
#' tar_assert_dir(getwd())
tar_assert_dir <- function(x, msg = NULL) {
  if (any(!dir.exists(x))) {
    targets::tar_throw_validate(
      msg %|||% paste(targets::tar_deparse_safe(x), "must be a directory.")
    )
  }
}
