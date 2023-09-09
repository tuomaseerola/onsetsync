# onsetsync 0.5.0

* Revised `plot_by_beat` function for font size and position when `griddeviation` is used.

# onsetsync 0.4.9

* Added CONTRIBUTING.md to the repository

* Added "Advanced Topics" and "Analysis of Periodicity" to documentation, which both relate to paper.

* Added very simple unit tests to package to verify loading the data, calculating asynchrony, plotting figures, and estimating periodicity.

# onsetsync 0.4.8

* Added "Analysis example" article to documentation. Relates to the paper.

# onsetsync 0.4.7

## Changes to parameters

* Changed all input parameters to lowercase letters and coordinated them across functions (`n` = number of samples, `bootn` = number of bootstraps, `beat` and not `beats`, etc.)
* default option to set sampling 0 and bootstrapping to NULL in `sync_sample_paired` and related functions.
* removed warnings from missing observations from plotting section of `periodicity`
* Allow sampling to cope with different number of samples between instrument pairs

## New functions

* Added new function to calculate onset time difference _relative_ to the mean of other instrument onsets (see [`sync_sample_paired_relative.R`](https://tuomaseerola.github.io/onsetsync/reference/sync_sample_paired_relative.html))
* Added new function to auralise onsets (see [`synthesise_onsets.R`](https://tuomaseerola.github.io/onsetsync/reference/synthesise_onsets.html))

## New documentation
* Added article to documentation about synthesis (see [synthesise_onsets](https://tuomaseerola.github.io/onsetsync/articles/synthesise_onsets.html))
* Added article to documentation about adding annotations (see [adding_annotations](https://tuomaseerola.github.io/onsetsync/articles/adding_annotations.html))

# onsetsync 0.4.6

## Bug Fixes

* removed an element from `summarise_sync.R`, 
* added calculation of sync across subdivisions in `summarise_sync_by_pair.R`
* revised `plot_by_pair.R` color options when each subdivision is requested (`bybeat`) and flipped the histogram for clarity.
* replaced the use of `reshape2::melt` function with `tidyr::pivot_longer`

# onsetsync 0.4.5

## Bug Fixes

* renamed functions (summary_measures, periodicity_moments, nPVI, stats_by_pair)

# onsetsync 0.4.4

## Bug Fixes

* gaussify_onsets changed

# onsetsync 0.4.0

* This is the first release of onsetsync.
