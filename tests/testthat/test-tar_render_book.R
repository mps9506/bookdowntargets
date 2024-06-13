targets::tar_test("tar_render_book() works", {

  skip_rmarkdown()
  temp_dir <- fs::path_temp()
  bookdown_dir <- fs::dir_create(temp_dir, "book")

  ## write temp rmd file
  lines <- c(
    "---",
    "title: report",
    "---",
    "",
    "```{r}",
    "targets::tar_read(data)",
    "```"
  )
  rmd_file <- fs::file_create(fs::path(bookdown_dir,"index", ext = "rmd"))
  writeLines(lines, rmd_file)

  ## write temp _output.yml and _bookdown.yml files
  lines <- c(
    "---",
    "bookdown::html_document2",
    "---"
  )
  output_file <- fs::file_create(fs::path(bookdown_dir, "_output", ext = "yml"))
  writeLines(lines, output_file)


  targets::tar_script({
    library(tarchetypes)
    list(
      targets::tar_target(data, data.frame(x = seq_len(26L), y = letters)),
      tar_render_book(report, fs::path(bookdown_dir), quiet = TRUE)
    )
  })


  # First run.
  suppressMessages(targets::tar_make(callr_function = NULL))
  progress <- targets::tar_progress()
  progress <- progress[progress$progress != "skipped", ]
  expect_equal(sort(progress$name),
               sort(c("data", "report")))


  # Should return expected file paths and resources
  out <- targets::tar_read(report)
  expect_equal(sort(basename(out)),
               sort(c(basename(fs::dir_ls(bookdown_dir)),
                      basename(fs::dir_ls(temp_dir,
                                          type = "directory",
                                          regexp = "targets*",
                                          invert = TRUE)))))

  # Should not rerun the report.
  suppressMessages(targets::tar_make(callr_function = NULL))
  progress <- targets::tar_progress()
  progress <- progress[progress$progress != "skipped", ]
  expect_equal(nrow(progress), 0L)

})
