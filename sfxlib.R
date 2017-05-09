# sfxlib - classifying builtins

#' sfxlib consists of a named list/JSON object with keys fetched directly from
#' the symbol table of the \code{R} interpreter and values assigned according
#' to a custom classification scheme that categorizes side-effects.
#' 
#' @section Side-effect categories:
#' exception,
#' networking, 
#' input, 
#' output, 
#' leaking (modifying external state),
#' geeking (calling foreign code & external programs)
#'
#' @details Each item of \code{sfxlib} is assigned a character value,
#' \code{''} indicates the absence of side-effects, whereas any of the 
#' categories above indicate the type of side-effect. Category \code{geeking}
#' captures invocations of C, C++, Fortran code (not JavaScript, Python...), 
#' invocations of \code{base::system, base::system2, base::shell, 
#' base::shell.exec, sys::*}
#' 

# origin
#SFXLIB <- lapply(builtins(), function(b) '')
#names(SFXLIB) <- builtins()
#cat(jsonlite::toJSON(SFXLIB), file='sfxlib.json')

# read in WIP
sfxlib <- jsonlite::fromJSON('sfxlib.json')

# identified n sidefx yielding functions in sfxlib yet:
sum(sapply(sfxlib, function(b) b != ''))

# when marking do bulk processing
#sfxlib[grepl('^(s)?print', names(sfxlib))] <- 'output'

# saving 2 persistent store
cat(jsonlite::toJSON(sfxlib), file='sfxlib.json')
