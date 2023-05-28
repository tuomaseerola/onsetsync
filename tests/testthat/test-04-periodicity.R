# test-04-periodicity.R

extract <- dplyr::filter(CSS_Song2, Guitar >= 60 & Guitar < 65)
extract <- ungroup(extract) # drop grouping structure
frq_range <- c(0.10,0.50)

per1 <- periodicity(extract,instr='Guitar',freq_range=frq_range,
                    method = 'diff', title = 'Difference')
PM1 <- summarise_periodicity(per1$Curve)
period1 <- round(PM1$Per*1000)

test_that("Periodicity data has the correct value", {
  expect_equal(period1,195)
})

per2 <- periodicity(extract,instr='Guitar',freq_range=frq_range,
                    method = 'acf')
PM2 <- summarise_periodicity(per2$Curve)
period2 <- round(PM2$Per*1000)

test_that("Periodicity data has the correct value", {
  expect_equal(period2,204)
})

per3 <- periodicity(extract,instr='Guitar',freq_range=frq_range,
                    method = 'fft')
PM3 <- summarise_periodicity(per3$Curve)
period3 <- round(PM3$Per*1000)

test_that("Periodicity data has the correct value", {
  expect_equal(period3,217)
})
