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
    "bookdown::html_document2: default",
    "bookdown::pdf_document2: default",
    "---"
  )
  output_file <- fs::file_create(fs::path(bookdown_dir, "_output", ext = "yml"))
  writeLines(lines, output_file)


  targets::tar_script({
    library(tarchetypes)
    list(
      targets::tar_target(data, data.frame(x = seq_len(26L), y = letters)),
      tar_render_book(report, fs::path(bookdown_dir), output_format = "all", quiet = TRUE)
    )
  })


  # First run.
  suppressMessages(targets::tar_make(callr_function = NULL))
  progress <- targets::tar_progress()
  progress <- progress[progress$progress != "skipped", ]
  expect_equal(sort(progress$name),
               sort(c("data", "report")))


  # tar_render book Should return tracked file paths and resources
  out <- targets::tar_read(report)
  expect_equal(sort(basename(out)),
               sort(c(basename(fs::dir_ls(bookdown_dir,
                                          recurse = TRUE)))))
  # Should contain _main.html and _main.pdf
  expect_in(c("_main.html", "_main.pdf"),
            c(basename(fs::dir_ls(bookdown_dir,
                                  recurse = TRUE))))


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
      tar_render_book(report, ".", quiet = TRUE)
    )
  })

  # First run.
  suppressMessages(targets::tar_make(callr_function = NULL))
  progress <- targets::tar_progress()
  progress <- progress[progress$progress != "skipped", ]
  expect_equal(sort(progress$name),
               sort(c("data", "report")))

  # tar_render book Should return tracked file paths and resources
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

targets::tar_test("tar_render_book() returns errors", {
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
      tar_render_book(report, "index.Rmd", quiet = TRUE)
    )
  })

  # First run.
  testthat::expect_error(
    targets::tar_make(callr_function = NULL)
    )


})
