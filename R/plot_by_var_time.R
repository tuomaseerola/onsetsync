#' Plots a variables across time and possible by any other structure
#'
#' \code{plot_by_var_time} visualizes the
#' calculated asynchronies of instruments across time and
#' another variable.
#'
#' @param df data frame to be processed (required)
#' @param var1 Variable 1 (Time)  (required)
#' @param var2 Variable 2 (required)
#' @param var3 Variable 3 (optional)
#' @param colour Colour option (optional)
#' @param smoothline_colour Colour option (optional)
#' @param xlabel label for X axis (optional)
#' @param ylabel label for Y axis (optional)
#' @param zlabel label for Z axis (optional)
#' @return Graphic output
#' @seealso \code{\link{sync_sample_paired}} for synchronies between
#' instruments, \code{\link{plot_by_beat}} for plotting.
#' @import ggplot2

plot_by_var_time <- function(df,
                             var1 = 'Time',
                             var2 = 'Synchrony',
                             var3 = NULL,
                             colour = 'orange',
                             smoothline_colour = 'navyblue',
                             xlabel = NULL,
                             ylabel = NULL,
                             zlabel = NULL) {
  # T. Eerola, Durham University, IEMP project
  # 20/6/2022

 .data <- NULL # <- var2 <- var3 <- Time <- VAR2 <- VAR3 <- NULL

  if(is.null(xlabel)){xlabel <- var1}
  if(is.null(ylabel)){ylabel <- var2}
  if(is.null(zlabel)){zlabel <- var3}

  if(is.null(var3)){
#    DF <- df %>% dplyr::select(tidyr::all_of(c(var1, var2)))
#    colnames(DF) <- c('Time', 'VAR2')
    g1 <-
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[var1]], y = .data[[var2]])) +
      ggplot2::geom_point(colour=colour) +
      ggplot2::geom_smooth(ggplot2::aes(x = .data[[var1]], y = .data[[var2]]),method = lm,formula = y ~ splines::bs(x, 12), se = FALSE, colour=smoothline_colour) +
      ggplot2::xlab(xlabel)+
      ggplot2::ylab(ylabel)+
      #   ggplot2::scale_x_time()+
      ggplot2::theme_linedraw()
  }
  
  if(!is.null(var3)){
  #  DF<-df %>% dplyr::select(tidyr::all_of(c(var1, var2, var3)))
  #  colnames(DF) <- c('Time', 'VAR2','VAR3')
    g1 <-
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[var1]], y = .data[[var2]], colour = .data[[var3]])) +
      ggplot2::geom_point() +
      ggplot2::geom_smooth(ggplot2::aes(x = .data[[var1]], y = .data[[var2]]),method = lm,formula = y ~ splines::bs(x, 12), se = FALSE, colour=smoothline_colour) +
      ggplot2::xlab(xlabel)+
      ggplot2::ylab(ylabel)+
      ggplot2::scale_x_time()+
      ggplot2::scale_color_continuous(name=zlabel,low='red',high = 'yellow')+
      ggplot2::theme_linedraw()+
      ggplot2::theme(legend.position="top")
  }
    return <- g1
}
