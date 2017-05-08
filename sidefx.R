# sidefx 

hasSFX <- function(func, recursive=FALSE) {
  stopifnot(is.function(func), is.logical(recursive))
  # scan input to character vectors
  sig <- paste0(deparse(args(func)), collapse='')
  spl <- strsplit(sub('^.*\\(([^\\)]*)\\).*$', '\\1', sig, perl=TRUE), 
                  ',', fixed=TRUE)[[1]]
  params <- gsub('^\\s*|\\s*$', '', spl, perl=TRUE)
  fbody <- if (is.primitive(func)) {
    sub('^.*function\\s\\([^\\)]*\\)\\s*', '', capture.output(func), perl=TRUE)
  } else {
    paste0(deparse(body(func)), sep='\n', collapse='')
  }
  # get all sidefx yielding builtins in a vector
  stdlib <- builtins()
  # ...
  # identify sidefx and inner functions in tokens !!!
  token_df <- sourcetools::tokenize_string(paste0('{', fbody, '}'))
  token <- split(token_df, 1L:nrow(token_df))  # df to list
  token <- Filter(function(t) t$type != 'whitespace', token)  # toss whitespace
  # find inner functions among symbols
  token <- lapply(token, function(tok) {
    append(tok, 
           c(isFunc=!is.null(get0(tok$value, mode='function', inherits=TRUE))))
  })
  # demark brackets and 'function' (anonymous) - just been marked as funcs
  token <- lapply(token, function(tok) {
    if (tok$type == 'bracket' || tok$value == 'function') tok$isFunc <- FALSE
    tok
  })
  token
}
