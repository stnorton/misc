# misc
This folder contains R code that I have found useful in my own research, and that others may as well. This R code is freely available, and comes with no guarantee of working as intended (though I certainly hope it does). 

Googleway Geocoder
I ran into repeated problems using the googleway package to geocode because  1) Google internal server errors/slight interruptions in internet connectivity lead to NA results 2) true NA results are a nested list of a different length from valid results, making easy casting to dataframe impossible. This file contains an exception handler for the googleway geocoder that tries every address 5 times before moving on (in case of errors or internet connectivity issues) and a set of functions that flatten results, replace NAs with a list of the same number of elements, and cast to a dataframe. 
NB: trying each address 5 times will can run up the number of requests to Google's geocoding API (though in my experience, only very slightly). I thus recommend getting an API key rather than relying on the 2500 free daily requests, as you may hit the limit earlier than intended.
