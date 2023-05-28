# test-03-figures.R

fig1 <- plot_by_beat(df = CSS_Song2, 
                     instr = c('Bass','Clave','Guitar','Tres'), 
                     beat = 'SD', 
                     virtual='Isochronous.SD.Time',
                     pcols=2)

test_that("Plot is created", {
  expect_s3_class(fig1,"ggplot")
})


inst <- c('Clave','Bass','Guitar','Tres') # Define instruments 
dn <- sync_execute_pairs(CSS_Song2,inst,beat = "SD")
fig2 <- plot_by_pair(dn)

test_that("Plot is created", {
  expect_s3_class(fig2,"ggplot")
})
