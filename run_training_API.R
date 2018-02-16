#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

Sys.setenv(LANG = "en")


# -------------------------------------------------------------------
# CONTAINS THE PLUMBER SERVER CODE FOR MARINE2.0 
# PREPROCESSING AND TRAINING
# -------------------------------------------------------------------
# contains : 
# - Plumber code for starting the sever
# -------------------------------------------------------------------

library(plumber)
library(futile.logger)
library(future)
library(httr)
library(stringr)
#library(lubridate)

plan(multiprocess)

tryCatch(
	withCallingHandlers
	(
		{
			#source("test_code.R")     # call your unchanged code by sourcing it!
			portno <-as.numeric(args[1])
			
			flog.threshold(args[2])
			layout <- layout.format('~t\t~l\t~m')
			flog.layout(layout)
			flog.appender(appender.file('r_API_training_server.log'))
			r <- plumb("train_model_API.R")
			r$run(host = '0.0.0.0',port = portno)
		
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
