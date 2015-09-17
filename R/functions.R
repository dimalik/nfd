## helper routines

get.distribution.mode <- function(x) {
    ## retrieved from http://stackoverflow.com/a/8189441/1604619
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
}

split.string <- function(string) {
    if (is.character(string))
        if (length(string) == 1)
            return (unlist(strsplit(tolower(string), "\\W+")))
        else
            return (string)
    else
        stop("Please provide a character string (e.g. \"this is a string\")")
}

create.frequency.distribution <- function(string, df=F) {
    if (!is.character(string))
        stop("Argument should be a character object")
    if (length(string) == 1) s <- split.string(string) else s <- string
    if (df) {
        freq.list <- table(s)
        dframe <- as.data.frame(freq.list)
        colnames(dframe) <- c("Word", "Freq")
        dframe <- dframe[with(dframe, order(-Freq)), ]
        dframe$Rank <- seq(length(freq.list))
        return (dframe)
    } else return (sort(as.vector(table(s)), decreasing=T))
}

get.samples <- function(i, random, max.tokens) {
    if (!random) return (1:i)
    return (.Internal(sample(max.tokens, i, F, NULL)))
}
