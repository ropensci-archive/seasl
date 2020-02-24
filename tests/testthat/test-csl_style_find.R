test_that("csl_style_find: after files downloaded", {
  # download files if they don't exist
  if (!suppressWarnings(styles_exist())) {
    csl_fetch_styles()
  }

  # single match
  aa <- csl_style_find(x = "American Journal of Epidemiology")
  expect_is(aa, "character")
  expect_length(aa, 1)
  expect_match(aa, "\\.csl")
  expect_match(aa, "american-journal")

  # many matches
  bb <- csl_style_find(x = "American Journal")
  expect_is(bb, "character")
  expect_gt(length(bb), 1)
  expect_true(all(grepl("\\.csl", bb)))
  expect_true(all(grepl("american-journal", bb)))

  # no matches
  cc <- csl_style_find(x = "foo bar")
  expect_null(cc)
})
