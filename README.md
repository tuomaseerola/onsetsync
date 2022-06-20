
<!-- README.md is generated from README.Rmd. Please edit that file -->

# onsetsync - Analysis and Visualisation of Synchronisation of Music Onset Data

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`onsetsync` is a R package for musical assessing synchrony between
onsets in music.
<img src="man/figures/logo.png" align="right" height="139"/> There are
functions for common operations such as adding isochronous beats based
on metrical structure, adding annotations, calculating classic measures
of synchrony between performers, and assessing periodicity of the
onsets, and visualising synchrony across cycles, time, or another
property.

## Installation

You can install the current version of `onsetsync` from Github by
entering the following commands into R:

``` r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("tuomaseerola/onsetsync")
```

## Usage

``` r
library(onsetsync)
library(dplyr)
library(ggplot2)
packageVersion("onsetsync")
#> [1] '0.4.1'
```

### Reading in data

Read onsets of one Cuban Son performance titled *Palo Santo* from *IEMP*
dataset at <https://osf.io/sfxa2/>. This song has the onsets and the
annotations about the metric cycles already extracted and defined and
**comes with the package**.

Go and <A HREF="https://osf.io/z9uxs/" target="_blank">listen to the song at OSF</A>.

``` r
CSS_Song2 <- onsetsync::CSS_IEMP[[2]]   # Read one song from internal data
CSS_Song2 <- dplyr::select(CSS_Song2,Label.SD,SD,Clave,Bass,Guitar,Tres,
                           CycleTime,Cycle,Isochronous.SD.Time) # Select some columns
print(knitr::kable(head(CSS_Song2),format = "simple",digits = 2))
```

| Label.SD |  SD | Clave | Bass | Guitar | Tres | CycleTime | Cycle | Isochronous.SD.Time |
|:---------|----:|------:|-----:|-------:|-----:|----------:|------:|--------------------:|
| 1:1      |   1 |    NA |   NA |     NA |   NA |      5.04 |     1 |                5.04 |
| 1:2      |   2 |    NA |   NA |   5.28 |   NA |        NA |     1 |                5.26 |
| 1:3      |   3 |    NA |   NA |   5.48 |   NA |        NA |     1 |                5.48 |
| 1:4      |   4 |    NA | 5.71 |   5.71 | 5.73 |        NA |     1 |                5.71 |
| 1:5      |   5 |    NA | 5.93 |   5.94 | 5.92 |        NA |     1 |                5.93 |
| 1:6      |   6 |    NA |   NA |   6.15 | 6.14 |        NA |     1 |                6.15 |

Reading data from is easy either from CSV files in your computer or
directly from OSF using `get_OSF_csv` function.

### Visualise onsets structures

As an overview, we can visualise the onsets across the beat
sub-divisions for each instrument and do this across the time. Note that
time run vertically (from bottom to up) here.

``` r
fig1 <- plot_by_beat(df = CSS_Song2, 
                     instr = c('Bass','Clave','Guitar','Tres'), 
                     beat = 'SD', 
                     virtual='Isochronous.SD.Time',
                     pcols=2)
print(fig1)
```

<img src="man/figures/README-synch2isochron-1.png" width="75%" />

### Calculate asynchronies

To what degree are the pairs of instruments synchronised to each other?
Let’s visualise the synchrony of all pairings of the instruments in this
example.

``` r
inst <- c('Clave','Bass','Guitar','Tres') # Define instruments 
dn <- sync_execute_pairs(CSS_Song2,inst,0,1,'SD')
fig2 <- plot_by_pair(dn)  # plot
print(fig2)  
```

<img src="man/figures/README-fig2-1.png" width="75%" />

As we saw in the first figure, the instruments usually play widely
different amounts of onsets in a piece, and these are bound to be at
different beats sub-divisions, the mutual amount of comparable onsets
for each pair often varies dramatically. Comparison of mean asynchronies
across sub-divisions can be facilitated by taking random samples of the
joint onsets. Here we choose a random 200 matching onsets and
re-calculate the comparison of asynchrony with this subset 1000 times.

``` r
set.seed(1234) # set random seed
N <- 200 # Let's select 200 onsets
Bootstrap <- 1000
d1 <- sync_sample_paired(CSS_Song2,'Clave','Bass',N,Bootstrap,'SD',TRUE)
#> [1] "onsets in common: 241"
print(paste('Mean asynchrony of',round(mean(d1$asynch*1000),1),
    'ms & standard deviation of',round(sd(d1$asynch*1000),1),'ms'))
#> [1] "Mean asynchrony of 16.2 ms & standard deviation of 19.5 ms"
```

There are other measures to summarise the asynchronies and visualise
them.

### Calculate synchrony across performances

We can apply the measures to a corpus of performances. Here we load five
Cuban Son and Salsa performances and run the same analysis as above
across the performances.

``` r
corpus <- onsetsync::CSS_IEMP
D <- sync_sample_paired(corpus,'Tres','Bass',N=0,beat='SD')
#> [1] "Calculating across the corpora"
D <- D$asynch
D$asynch_abs <- abs(D$asynch)*1000
fig3 <- plot_by_dataset(D,'asynch_abs','name', box = TRUE)
print(fig3)
```

<img src="man/figures/README-corpus-1.png" width="75%" />

For more examples, see
[documentation](https://tuomaseerola.github.io/onsetsync/) and
associated [paper IN PROGRESS](http://).

#### Note: How do I get onsets from my music?

Note that `onsetsync` is not dedicated to extraction of onsets from
audio as that should be done using other tools
(e.g. [Librosa](https://librosa.org), or [MIR Toolbox for
Matlab](https://www.jyu.fi/hytk/fi/laitokset/mutku/en/research/materials/mirtoolbox),
or [Sonic Visualiser](https://www.sonicvisualiser.org) using established
onset detection algorithms). Here we assume that you have extracted the
onsets of the music from a recording already in one of these tools, and
preferably checked them by hand. It is already more meaningful to carry
out analyses of synchrony when you have the metrical information (cycles
and beats) identified. If your starting point is MIDI, getting the
onsets is just a conversion operation away (I would recommend
[music21](https://web.mit.edu/music21/doc/moduleReference/moduleConverter.html)
for this purpose), although annotation might still be required.
