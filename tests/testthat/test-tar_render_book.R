targets::tar_test("tar_render_book() runs from subdirectory", {

  skip_rmarkdown()
  temp_dir <- fs::path_temp("subdirectory")
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
               sort(c(basename(fs::dir_ls(bookdown_dir)))))

  # Should not rerun the report.
  suppressMessages(targets::tar_make(callr_function = NULL))
  progress <- targets::tar_progress()
  progress <- progress[progress$progress != "skipped", ]
  expect_equal(nrow(progress), 0L)

})

targets::tar_test("tar_render_book() runs from project root", {
  skip_rmarkdown()
  ## write temp rmd file
  lines <- c(
    "---",
    "title: report",
    "output: bookdown::html_document2",
    "---",
    "",
    "```{r}",
    "targets::tar_read(data)",
    "```"
  )
  writeLines(lines, "index.Rmd")

  targets::tar_script({
    library(tarchetypes)
    list(
      targets::tar_target(data, data.frame(x = seq_len(26L), y = letters)),
      tar_render_book(report, fs::path_wd(), quiet = TRUE)
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
               sort(c(basename(fs::dir_ls(fs::path_wd(),
                                          regexp = "(_targets)$",
                                          invert = TRUE)))))

  # Should skip everything.
  suppressMessages(targets::tar_make(callr_function = NULL))
  progress <- targets::tar_progress()
  progress <- progress[progress$progress != "skipped", ]
  expect_equal(nrow(progress), 0L)


  })
