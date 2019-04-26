#!/usr/bin/env Rscript

library(plumber)
library(futile.logger)

predictionModule <- function(df)
{
	# all the prediction algorithm, function calls, sourcing of other
	# codes will be here

	# here is a dummy prediction
	n <- nrow(df)
	UID <- as.character(df$UID)
	PROB <- runif(n, min=0, max=1)
	
	output <- data.frame(UID = UID,PROB = PROB)
	
	return(output)

}

#' @filter log
function(req){
	flog.info('++++ REQUEST RECEIVED ++++')
	flog.info('METHOD: %s',req$REQUEST_METHOD)
	flog.info('API: %s',req$PATH_INFO)
	flog.info('HTTP USER AGENT: %s',req$HTTP_USER_AGENT)
	flog.info('REMOTE ADDRESS: %s',req$REMOTE_ADDR)

   plumber::forward()
}

# how to create a POST API in R
#=======================================
#* @post /apiEndPointName
#functionname <- function(){
	##put the function body here
#=====================================
# thus you can create as many API as you want and they will all be available at the same time when the server 
# is up and running


#* @post /predict
predictUtil <- function(input){

	# This is a Utility function, that calls the actual Prediction module
	
	# The payload input is sent to the API as json payload
	# and that input is coming as a dataframe
	# Assumption: the json input has fixed number of row and column

	df <- input 
	nr <- nrow(df)

	#logging details
	flog.info('INPUT RECORD SIZE: %d',nr)
	output <- predictionModule(df)
	flog.info('---- REQUEST SERVED ----')
	return(output)

}
flog.info('SERVER STARTED')

