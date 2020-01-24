test_that("as.location", {
  skip_if_not(length(csl_cache$list()) > 0,
    "skipping as.location tests: no files")
  
  a <- as.location("apa")

  expect_is(a, "location")
  expect_length(a, 1)
  expect_equal(attr(a, "type"), "file")
})

test_that("as.location fails well", {
  expect_error(as.location("foobar"), "File does not exist")
})

