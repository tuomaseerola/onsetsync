% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/periodicity.R
\name{periodicity}
\alias{periodicity}
\title{Estimate the periodicity of the onsets by a specific method}
\usage{
periodicity(
  df = NULL,
  instr = NULL,
  method = "per",
  sampling_rate = 500,
  freq_range = c(0, 2),
  resolution = 0.01,
  colour = "navyblue",
  title = NULL
)
}
\arguments{
\item{df}{data frame to be processed  (required)}

\item{instr}{Instrument name to be processed  (required)}

\item{method}{Periodicity analysis method: per (default), diff, acf, or fft}

\item{sampling_rate}{Sampling rate (Hz), default 500 Hz}

\item{freq_range}{Frequency range to be included in the periodicity analysis (in seconds), default 0 to 2}

\item{resolution}{Resolution for some of the analyses (in seconds), default 0.01}

\item{colour}{Line colour for plotting (optional)}

\item{title}{Title for plotting (optional)}
}
\value{
Graphic output
}
\description{
This function plots the calculated asynchronies of instruments and labels these by instruments.
}
\seealso{
\code{\link{summarise_periodicity}}

\code{\link{summarise_periodicity}} for summary function.
}
