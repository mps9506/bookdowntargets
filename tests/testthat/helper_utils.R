skip_rmarkdown <- function() {
  skip_if_not_installed("rmarkdown")
  skip_pandoc()
}
skip_pandoc <- function() {
  has_pandoc <- rmarkdown::pandoc_available(version = "1.12.3", error = FALSE)
  skip_if_not(has_pandoc, "no pandoc >= 1.12.3")
}


skip_latex <- function() {

  skip_if(!check_tex())

}

check_tex <- function() {
  path = Sys.which("tlmgr")

  if (path == "") {
    return(FALSE)
  } else {
    return(TRUE)
  }
}
