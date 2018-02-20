#!/usr/bin/env Rscript

#.NotYetUsed(arg, error = TRUE)

#args = commandArgs(trailingOnly=TRUE)
# -------------------------------------------------------------------
# contains the dummy API
# -------------------------------------------------------------------




#' @filter log
function(req){
	flog.info('++++ REQUEST RECEIVED ++++')
	flog.info('METHOD: %s',req$REQUEST_METHOD)
	flog.info('API: %s',req$PATH_INFO)
	flog.info('HTTP USER AGENT: %s',req$HTTP_USER_AGENT)
	flog.info('REMOTE ADDRESS: %s',req$REMOTE_ADDR)

   plumber::forward()
}



#* @post /notify
poststatus <- function(type,status,timestamp){

	#print(input)
	print(type)
	print(status)
	print(timestamp)
	flog.info('++++ REQUEST	SERVED ++++')

	return("OK")
}


