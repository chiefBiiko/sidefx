# sidefx 

hasSFX <- function(func, recursive=FALSE) {
  stopifnot(is.function(func), is.logical(recursive))
  # scan input to character vectors
  sig <- paste0(deparse(args(func)), collapse='')
  spl <- strsplit(sub('^.*\\(([^\\)]*)\\).*$', '\\1', sig, perl=TRUE), ',')
  params <- gsub('^\\s*|\\s*$', '', spl[[1]], perl=TRUE)
  fbody <- if (is.primitive(func)) {
    sub('^.*function\\s\\([^\\)]*\\)\\s*', '', capture.output(func), perl=TRUE)
  } else {
    paste0(deparse(body(func)), sep='\n', collapse='')
  }
  # get all sidefx yielding builtins in a vector
  stdlib <- builtins()
  # ...
  list(params, fbody)
}