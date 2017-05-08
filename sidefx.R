# sidefx 

hasSFX <- function(func, recursive=FALSE) {
  stopifnot(is.function(func), is.logical(recursive))
  # scan input to character vectors
  params <- if (is.primitive(func)) {
    sig <- paste0(deparse(args(func)), collapse='')
    spl <- strsplit(sub('^.*\\(([^\\)]*)\\).*$', '\\1', sig, perl=TRUE), 
                    ',', fixed=TRUE)
    
    gsub('^\\s*|\\s*$', '', spl[[1]], perl=TRUE)
    # cast chr vector to list !!!
    
  } else {
    formals(func)
  }
  fbody <- if (is.primitive(func)) {
    sub('^.*function\\s\\([^\\)]*\\)\\s*', '', capture.output(func), perl=TRUE)
  } else {
    paste0(deparse(body(func)), sep='\n', collapse='')
  }
  # get all sidefx yielding builtins in a vector
  stdlib <- builtins()
  # ...
  # identify sidefx and inner functions in tokens !!!
 #token_df <- sourcetools::tokenize_string(paste0('{', fbody, '}'))
  list(params, fbody)
}