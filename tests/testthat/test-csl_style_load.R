test_that("csl_style_load", {
  # download files if they don't exist
  if (!suppressWarnings(styles_exist())) {
    csl_fetch_styles()
  }

  aa <- csl_style_load("apa")
  bb <- csl_style_load("ieee")
  expect_is(aa, "list")
  expect_is(bb, "list")

  expect_equal(aa$info$title, "American Psychological Association 7th edition")
  expect_equal(bb$info$title, "IEEE")
})
