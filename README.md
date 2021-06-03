
<!-- README.md is generated from README.Rmd. Please edit that file -->

# onsetsync - Analysis and Visualisation of Synchronisation of Music Onset Data

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`onsetsync` is a R package for musical dynamics involving synchrony.
There are functions for common operations such as adding isochronous
beats based on metrical structure, adding annotations, calculating
classic measures of synchrony between two performers, and assessing
periodicity of the onsets, and visualising synchrony across cycles,
time, or another property.

## Installation

You can install the current version of `onsetsync` from Github by
entering the following commands into R:

``` r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("tuomaseerola/onsetsync")
```

## Usage

Note that `onsetsync` is not dedicated to extraction of onsets from
audio as that can be done in other packages (e.g. Librosa and Python, or
Matlab, or Sonic Visualiser) using well-known algorithms. Here we take
it as granted that we have extracted the onsets elsewhere and we have
the onset times recorded into the csv files.

``` r
# Onsets
invisible(GET("https://osf.io/8a347/?action=download", 
              write_disk("CSS_Song2_Onsets_Selected.csv", overwrite = T)))
CSS_Song2_Onset<-read.csv("CSS_Song2_Onsets_Selected.csv",header=T,sep=",")
knitr::kable(head(CSS_Song2_Onset[,1:8,]),format = "simple",
             caption = 'Onset data structure (see text for details).')
```

| Piece   | Label.SD |  SD | Clave\_. | Section | Clave |     Bass |   Guitar |
|:--------|:---------|----:|:---------|:--------|------:|---------:|---------:|
| Song\_2 | 1:1      |   1 | 1        | Son     |    NA |       NA |       NA |
| Song\_2 | 1:2      |   2 | N        | Son     |    NA |       NA | 5.281932 |
| Song\_2 | 1:3      |   3 | N        | Son     |    NA |       NA | 5.480643 |
| Song\_2 | 1:4      |   4 | 2        | Son     |    NA | 5.714555 | 5.707537 |
| Song\_2 | 1:5      |   5 | N        | Son     |    NA | 5.927078 | 5.939071 |
| Song\_2 | 1:6      |   6 | N        | Son     |    NA |       NA | 6.153243 |

Onset data structure (see text for details).

``` r
# Annotations
invisible(GET("https://osf.io/4cdpr/?action=download", 
              write_disk("CSS_Song2_Metre.csv", overwrite = TRUE)))
CSS_Song2_Metre <- read.csv("CSS_Song2_Metre.csv", header=T, sep=",")
knitr::kable(head(CSS_Song2_Metre[1:4,]),format = ,"simple")
```

| Cycle |      Time |
|------:|----------:|
|     1 |  5.037333 |
|     2 |  8.601000 |
|     3 | 12.123000 |
|     4 | 15.672000 |

``` r
CSS_Song2_Onset <- dplyr::select(CSS_Song2_Onset,
                                 Label.SD,SD,Clave,Bass,Guitar,Tres) 
```

As the onsets and annotations are in different files, let’s first
combine the raw onset and annotation with `onsetsync`. Here we first add
annotations about the cycles into the onset data and then we also add
isochronous beat times to the data frame, since are useful reference
points for future calculations.

``` r
# Add annotations about the cycle to the data frame
CSS_Song2 <- add_annotation(df = CSS_Song2_Onset,
                            annotation = CSS_Song2_Metre$Cycle,
                            time = CSS_Song2_Metre$Time,
                            reference = 'Label.SD')
# Add isochronous beats to the data frame
CSS_Song2 <- add_isobeats(df = CSS_Song2, 
                          instr = 'CycleTime', 
                          beat = 'SD')

print(knitr::kable(head(CSS_Song2),format = "simple",digits = 2))
#> 
#> 
#> Label.SD    SD   Clave   Bass   Guitar   Tres   CycleTime   Cycle   Isochronous.SD.Time
#> ---------  ---  ------  -----  -------  -----  ----------  ------  --------------------
#> 1:1          1      NA     NA       NA     NA        5.04       1                  5.04
#> 1:2          2      NA     NA     5.28     NA          NA       1                  5.26
#> 1:3          3      NA     NA     5.48     NA          NA       1                  5.48
#> 1:4          4      NA   5.71     5.71   5.73          NA       1                  5.71
#> 1:5          5      NA   5.93     5.94   5.92          NA       1                  5.93
#> 1:6          6      NA     NA     6.15   6.14          NA       1                  6.15
```

Before moving onto the analysis, let’s summarise the onset structures in
this piece.

``` r
tab1 <- summarise_onsets(df = CSS_Song2, 
                         instr = c('Clave','Bass','Guitar','Tres'))
print(knitr::kable(tab1,digits = 1,
     caption = 'Descriptives for the onset time differences (ms)'))
#> 
#> 
#> Table: Descriptives for the onset time differences (ms)
#> 
#> |       |    N|    Md|     M|    SD|   Min|    Max|
#> |:------|----:|-----:|-----:|-----:|-----:|------:|
#> |Clave  |  486| 666.4| 703.6| 173.9| 192.0| 1558.1|
#> |Bass   |  486| 471.4| 708.1| 432.0| 180.0| 1985.2|
#> |Guitar | 1401| 223.6| 244.5|  91.4| 175.1| 1694.9|
#> |Tres   |  906| 245.0| 371.4| 234.6| 147.1| 1986.5|
```

s a broad overview, we can visualise the relative synchrony to equal
division subdivision of the beat for each instrument across the time.
This gives a summary about when the instrument are playing relative to
the beat division and the sections of the song.

``` r
fig1 <- plot_by_beat(df = CSS_Song2, 
                     instr = c('Bass','Clave','Guitar','Tres'), 
                     beat = 'SD', 
                     virtual='Isochronous.SD.Time',
                     pcols=2)
print(fig1)
```

<div class="figure">

<img src="man/figures/README-synch2isochron-1.png" alt="Onsets arranged for beat sub-divisions for four instruments across the whole piece." width="75%" />
<p class="caption">
Onsets arranged for beat sub-divisions for four instruments across the
whole piece.
</p>

</div>
