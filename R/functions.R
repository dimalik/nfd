## helper routines
## ----------------
## author: dimitrios alikaniotis <da352@cam.ac.uk>
## ----------------
## FUNCTIONS
## ----------------
## 1) is.split checks if the provided string is a multielement vector of character
## objects or an unsplit string
## 2) get.distribution.mode finds the mode of the provided distribution
## 3) split.string essentially strsplit with some checks
## 4) create.frequency.distribution takes a string (either a multielement vector or a unitary one)
## and returns the frequency distribution (either as a two column df or a vector)
## 5) get.samples used in simulations to provide either a random range or a sequence

is.split <- function(string) ifelse(length(string) > 1, TRUE, FALSE)

get.distribution.mode <- function(x) {
    ## retrieved from http://stackoverflow.com/a/8189441/1604619
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
}

split.string <- function(string) {
    if (is.character(string))
        if (!is.split(string))
            return (unlist(strsplit(tolower(string), "\\W+")))
        else
            return (string)
    else
        stop("Please provide a character string (e.g. \"this is a string\")")
}

create.frequency.distribution <- function(string, df=F) {
    if (!is.character(string))
        stop("Argument should be a character object")
    if (!is.split(string)) s <- split.string(string) else s <- string
    if (df) {
        freq.list <- table(s)
        dframe <- as.data.frame(freq.list)
        colnames(dframe) <- c("Word", "Freq")
        dframe <- dframe[with(dframe, order(-Freq)), ]
        dframe$Rank <- seq(length(freq.list))
        return (dframe)
    } else return (sort(as.vector(table(s)), decreasing=T))
}

get.samples <- function(i, random=FALSE, max.tokens=NULL) {
    if (!random) return (1:i)
    return (.Internal(sample(max.tokens, i, F, NULL)))
}
