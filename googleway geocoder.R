############################
##Googleway Geocoder      ##
##Sean Norton             ##
##stnorton@live.unc.edu   ##
##Last updated: 10/3/2017 ##
############################

##Many thanks to the kind stackoverflow users who helped me create this code!

##GEOCODER----------------------------------------------------------------------

##creating an adverb to handle errors when geocoding
##in case of errors, this condition-handler
##attempts the same input five times before returning NULL and moving on

safely <- function(fn, ..., max_attempts = 5) {
  function(...) {
    this_env <- environment()
    for(i in seq_len(max_attempts)) {
      ok <- tryCatch({
        assign("result", fn(...), envir = this_env)
        TRUE
      },
      error = function(e) {
        FALSE
      }
      )
      if(ok) {
        return(this_env$result)
      }
    }
    msg <- sprintf(
      "%s failed after %d tries; returning NULL.",
      deparse(match.call()),
      max_attempts
    )
    warning(msg)
    NULL
  }
}

#creater a closure to run the geocode function w/in exception handler

safe_google_geocode <- safely(google_geocode)

##function can now be run over a list of addresses with lapply()

##DATA CLEANING-----------------------------------------------------------------

#Flattens the JSON results, turns NAs into an element with the same number of 
#elments to enable easy conversion to dataframe, converts to df

#MUST CREATE TEMPLATE FROM VALID RESULT

flatten_googleway <- function(df) {
  require(jsonlite)
  res <- jsonlite::flatten(df)
  res[, names(res) %in% c("geometry.location_type", "geometry.location.lat", 
                          "geometry.location.lng", "formatted_address")]
}

template_res <- flatten_googleway("your valid result")

your.dataframe <- do.call(rbind, lapply(yourgeocodeddata, function(x) {
  if (length(x$results) == 0| length(x$results$formatted_address) > 1) 
    template_res[1, ] else flatten_googleway(x$results)
}))