nfd <- function(f1, f2) UseMethod("nfd")

nfd.default <- function(f1, f2) {
  f1 <- as.integer(f1)
  f2 <- as.integer(f2)
  f1_length <- length(f1)
  f2_length <- length(f2)
  max_value <- max(f1_length, f2_length)
  tmp <- .C("nfd",
            f1=f1,
            f2=f2,
            f1_length=f1_length,
            f2_length=f2_length,
            freqDiff=integer(max_value),
            nfd_value=as.double(0)
  )
  tmp$max_value <- max_value
  class(tmp) <- "nfd"
  tmp
}

print.nfd <- function(x, ...) {
  cat("The NFD value is: ", x$nfd_value, "\n")
}

summary.nfd <- function(object, ...) {
  
  row.names <- c("F1.NTypes", "F2.NTypes", "F1.NTokens", "F2.NTokens", "NFD")
  values <- format(list(object$f1_length,
                        object$f2_length,
                        sum(object$f1),
                        sum(object$f2),
                        object$nfd_value),
                   scientific=F)
  res <- list(row.names=row.names,
              values=values)
  class(res) <- "summary.nfd"
  res
}

print.summary.nfd <- function(x, ...) 
{
  df <- data.frame(Values=x$values)
  rownames(df) <- x$row.names
  print(df)
}

plot.nfd <- function(x, y, ..., label1="A", label2="B", legend_pos=c(.75, .7)) {
  tempdf <- data.frame(Freq=c(x$f1, x$f2),
                       Rank=c(seq(x$f1_length), seq(x$f2_length)),
                       Text=as.factor(c(rep(label1, x$f1_length), rep(label2, x$f2_length)))
  )
  log.plot.frame <- ggplot(tempdf,aes(x=log(Rank),y=log(Freq),shape=Text,colour=Text))
  log.plot <- log.plot.frame+geom_point(size=3) +
    labs(x="log(Rank)",y="log(Frequency)",size=2) +
    scale_colour_grey() +
    theme_bw() +
    theme(
      legend.position=legend_pos,
      axis.title.x=element_text(size=18),
      axis.title.y=element_text(size=18),
      legend.text=element_text(size=16),
      legend.title=element_text(size=16),
      title=element_text(size=16)
    )  
  freqDiff.plot <- qplot(log(seq(x$max_value)),
                         x$freqDiff,
                         geom="segment",
                         yend=0,
                         xend=log(seq(x$max_value)),
                         size = I(3)
  ) +
    theme_bw() +
    labs(y=expression(paste(Delta, "Freq")), size=3) +
    theme(axis.title.x=element_blank())
  log.plot
  freqDiff.plot
  gridExtra::grid.arrange(freqDiff.plot,
                          log.plot,
                          ncol=1,
                          nrow=2,
                          heights=c(1,3)
  )
}
