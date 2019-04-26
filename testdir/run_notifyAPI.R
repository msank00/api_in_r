#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# -------------------------------------------------------------------
## CONTAINS THE PLUMBER SERVER CODE FOR MARINE2.0 PREDICTION
# -------------------------------------------------------------------
# contains : 
# - Plumber code for starting the sever
# -------------------------------------------------------------------


Sys.setenv(LANG = "en")
library(plumber)
library(futile.logger)

tryCatch(
	withCallingHandlers
	(
		{
			# call your unchanged code by sourcing it!
			portno <- as.numeric(args[1])
			r <- plumb("notifyAPI.R")
			r$run(port = portno)
		
		},  
		error = function(e) 
		{
          call.stack <- sys.calls()   # "sys.calls" within "withCallingHandlers" is like a traceback!
		  log.message <- e$message
		  flog.error(log.message)     # let's ignore the call.stack for now since it blows-up the output
		  #flog.error(call.stack)
		}, 
		warning = function(w) 
		{
          call.stack <- sys.calls()   # "sys.calls" within "withCallingHandlers" is like a traceback!
		  log.message <- w$message
		  flog.warn(log.message)      # let's ignore the call.stack for now since it blows-up the output
		  #flog.warn(call.stack)
		  invokeRestart("muffleWarning")  # avoid warnings to "bubble up" to being printed at the end by the R runtime
		}
	)
	, error = function(e) 
	{
       flog.info("Logging injector: The called user code had errors...")
	}
)
