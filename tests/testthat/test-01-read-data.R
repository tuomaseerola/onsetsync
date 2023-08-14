# test-01-read-data.R
test_that("Demo data is read properly", {
  expect_s3_class(CSS_Song2,"data.frame")
})

test_that("Demo data the correct dimensions", {
  expect_equal(dim(CSS_Song2),c(1568,9))
})

