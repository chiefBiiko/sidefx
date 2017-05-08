# sidefx 

hasSFX <- function(func, recursive=FALSE) {
  stopifnot(is.function(func), is.logical(recursive))
  # scan input to character vectors
  params <- if (is.primitive(func)) {
    sig <- paste0(deparse(args(sum)), collapse='')
    spl <- strsplit(sub('^.*\\(([^\\)]*)\\).*$', '\\1', sig, perl=TRUE), ',')
    gsub('\\s|=.*$', '', spl[[1]], perl=TRUE)
  } else {
    names(formals(func))
  }
  fbody <- if (is.primitive(func)) {
    sub('^.*function\\s\\([^\\)]*\\)\\s*', '', capture.output(sum), perl=TRUE)
  } else {
    paste0(deparse(body(func)), sep='\n', collapse='')
  }
  print(params)
  print(fbody)
  # tokenize function body
  stdlib <- builtins()
  token_df <- sourcetools::tokenize_string(paste0('{', fbody, '}'))
  token_df
}