createFreqDist <-
function(string, df=F) {
  if (!is.character(string))
    stop("String should be a character object")
  if (df) {
    freq.list <- table(unlist(strsplit(tolower(string), "\\W+")))
    dframe <- as.data.frame(freq.list)
    colnames(dframe) <- c("Word", "Freq")
    dframe <- dframe[with(dframe, order(-Freq)), ]
    dframe$Rank <- seq(length(freq.list))
    return (dframe)
  } else {
    return (sort(as.vector(table(unlist(strsplit(tolower(string), "\\W+")))), decreasing=T))
  }
}
