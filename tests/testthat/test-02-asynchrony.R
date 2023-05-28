# test-02-asynchrony.R

d1 <- sync_sample_paired(df = CSS_Song2, 
                         instr1 = 'Clave',
                         instr2 = 'Bass',
                         n = 0, 
                         beat = 'SD')

test_that("Demo data the correct length", {
  expect_equal(length(d1$asynch),241)
})

test_that("Demo data has the correct mean value", {
  expect_equal(mean(d1$asynch),0.0162328797)
})


