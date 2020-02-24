# make sure theres no files first
csl_cache$delete_all()

test_that("csl_locales: no files present", {
  expect_equal(length(csl_locales()), 0)
  expect_is(csl_locales(), "character")
  expect_null(csl_locales("fr-FR"))

  expect_false(csl_locale_exists("fr-FR"))
})

suppressMessages(csl_fetch_locales())

test_that("csl_locales: after files downloaded", {
  expect_gt(length(csl_locales()), 10)
  expect_is(csl_locales(), "character")

  expect_is(csl_locales("fr-FR"), "character")
  expect_match(csl_locales("fr-FR"), "locales-fr-FR.xml")

  expect_true(csl_locale_exists("fr-FR"))
})

test_that("csl_locales fails well", {
  expect_error(csl_locales(4:5))
  expect_error(csl_locales(letters[1:2]))

  expect_error(csl_locale_exists(4:5))
  expect_error(csl_locale_exists(letters[1:2]))
})
