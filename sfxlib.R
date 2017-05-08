# sfxlib - classifying builtins

#' sfxlib consists of a named list/JSON object with keys fetched directly from
#' the symbol table of the \code{R} interpreter and values assigned according
#' to a custom classification scheme that categorizes side-effects.
#' 
#' @section Side-effect categories:
#' exception, networking, input, output, leaking (modifying external state) 
#'
#' @details Each item of the \code{sfxlib} is assigned a character value,
#' \code{''} indicates the absence of side-effects, whereas any of the 
#' categories above indicate the type of side-effect.

# origin
#SFXLIB <- lapply(builtins(), function(b) '')
#names(SFXLIB) <- builtins()
# persistent store
#cat(jsonlite::toJSON(SFXLIB), file='sfxlib.json')

# read in WIP
sfxlib <- jsonlite::fromJSON('sfxlib.json')

# identified n sidefx yielding functions in sfxlib yet:
sum(sapply(sfxlib, function(b) b != ''))

# when marking do bulk processing
# sfxlib[grepl('^print', names(sfxlib))] <- 'category'
