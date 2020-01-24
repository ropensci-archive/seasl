test_that("csl_fetch_styles", {
  csl_cache$cache_path_set("csl_fetch_styles_test", type = "tempdir")
  on.exit(csl_cache$cache_path_set("seasl", type = "tempdir"))

  # before fetching
  expect_length(csl_cache$list(), 0)
  
  # fetch
  expect_message((aa = csl_fetch_styles()), "Done!")

  # after fetching
  expect_gt(length(csl_cache$list()), 0)

  expect_is(aa, "character")
  expect_length(aa, 1)
  expect_match(aa, "csl_fetch_styles_test")
})
