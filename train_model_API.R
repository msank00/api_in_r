#!/usr/bin/env Rscript

#.NotYetUsed(arg, error = TRUE)

#args = commandArgs(trailingOnly=TRUE)
# -------------------------------------------------------------------
# -------------------------------------------------------------------
# contains sample script for training api: 
# - preprocess module
# - train module 
# 
# -------------------------------------------------------------------
# NOTE Preprocessing and Training functions are called as asynchronous 
# process using the package "future" 
#--------------------------------------------------------------------
#library(futile.logger)
#library(future)
preprocessingModule <- function(callbackURL) {
	##
	##.... Here goes the preprocessing logic, function call, file sourcing
	##

	# Preprocessing can takes several minutes, so We run this Preprocess module in 
	# server as asynchronous function, which needs to callback the Pythia layer using
	# the callback API. The following snippets uses the callback strategy to POST
	# status message, api_type and timestamp (Unix ) to the Pythia Callback API

	#print("m here ...")

	api_type <- "preprocessing"
	
	#UNIX timestamp
	timestamp_value <- 123456   #format(Sys.time(), "%a %d %b %Y, %H:%M:%S")  #strftime(Sys.Date(),'%B %d, %Y')
	
	#status message depending upon status of preprocessing OK or NOTOK
	status_message <- "OK"

	postStatus(callbackURL,api_type,status_message,timestamp_value)

    return()
}

trainingModule <- function(callbackURL) {
	##
	##.... Here goes the traning logic, function call, file sourcing
	##

	# Training can takes several minutes, so We run this training module in 
	# server as asynchronous function, which needs to callback the Pythia layer using
	# the callback API. The following snippets uses the callback strategy to POST
	# status message, api_type and timestamp (Unix ) to the Pythia Callback API

	api_type <- "traning"
	
	#UNIX timestamp
	timestamp_value <- as.character(as.integer(as.POSIXct(Sys.time())))   #format(Sys.time(), "%a %d %b %Y, %H:%M:%S")  #strftime(Sys.Date(),'%B %d, %Y')
	
	#status message depending upon status of preprocessing OK or NOTOK
	status_message <- "OK"

	postStatus(callbackURL,api_type,status_message,timestamp_value)

    return()
}

# Function for calling the callback API to post the status
postStatus <- function(callbackURL,api_type,status_message,timestamp_value)
{
	url <- callbackURL
	
	body <- list(type=api_type,status=status_message,timestamp=timestamp_value)
	
	flog.info("sending POST to callback URL")
	print(url)
	print(status_message)
	print(timestamp_value)

	r.result<-POST(url, body = body,encode="form")
	print("message from callBack URL")
	print(r.result)
	print(r.result$content)
	flog.info("Callback Successful...")
}

# ----------------------------------------------------------------- #

#' @filter log
function(req){
  
  flog.info('++++ REQUEST RECEIVED ++++')
  flog.info('METHOD: %s',req$REQUEST_METHOD)
  flog.info('API: %s',req$PATH_INFO)
  flog.info('HTTP USER AGENT: %s',req$HTTP_USER_AGENT)
  flog.info('REMOTE ADDRESS: %s',req$REMOTE_ADDR)
  
  plumber::forward()
}



#* @post /prepro
preprocessingUtility <- function(callbackURL){

	# This is an utility function for creating the preprocessing api
	flog.info("PREPROCESSING REQUEST: +++++RECEIVED+++++")

	#print("m here")
	# calling the preprocessing module as Asynchronous call with "future"
	f<-future(preprocessingModule(callbackURL))
	
	# sending an immediate status to the client
	status <- data.frame(list("PREPROCESSING"="STARTED"))
	return(status)
}

#* @post /train
trainingUtility <- function(callbackURL){
  	
	# This is an utility function for creating the preprocessing api
	  flog.info("TRAINING REQUEST: +++++RECEIVED+++++")
	  t <- future(trainingModule(callbackURL))
	  
	  #flog.info("TRAINING REQUEST: -----SERVED-----")
	  
	  status <- data.frame(list("TRAINING"="STARTED"))
	  
	  return(status)
}

#preprocessingUtility("http://scl000006038.sccloud.swissre.com:5042/notify")
#trainModelUtility()
