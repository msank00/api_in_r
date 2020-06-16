#!/usr/bin/env Rscript

library(versions)
# Function to check whether package is installed
is.installed <- function(mypkg){
  is.element(mypkg, installed.packages()[,1])
	} 

get_version_number <- function(mypkg){
	return(packageDescription(mypkg)$Version)

}


create_environment <- function(packages, versions){

	n_packages <- length(packages)
	for(i in seq(1,n_packages)){
	
		message('==================')
		print(paste0(packages[i], versions[i]))
		mypkg <- packages[i]
		req_version <- versions[i]

		# check if package "hydroGOF" is installed
		if (!is.installed(mypkg)){
			message('...package NOT INSTALLED already...')
			
			message(sprintf('installing package: %s:%s',mypkg,req_version))
			install.versions(mypkg,req_version)
			message('package installation completed...')

		} else if (is.installed(mypkg)){
			# if package is installed check the version
			message('package available...')

			pkg_version <- get_version_number(mypkg)
			message(paste0('available version: ',pkg_version))
			message(paste0('required version: ', req_version))

			if (all( pkg_version == req_version))
				message("version same, no need to install...")
			else {
				message(sprintf("...VERSION MISMATCH. Uninstalling old package: %s: %s",mypkg, pkg_version))
				remove.packages(mypkg)
				message('package uninstalled...')
				message(sprintf('installing package: %s:%s',mypkg,req_version))
				install.versions(mypkg,req_version)
				message('new package installation completed...')
			
			}
		}
	}

}
packages <- c("dplyr","mgcv","stringr","futile.logger","stringi","jsonlite","lubridate","cluster","doParallel","plumber","future","httr")
versions <- c("0.7.4", "1.8-22","1.2.0","1.4.3","1.1.5","1.5","1.6.0","2.0.7-1","1.0.11","0.4.6","1.6.2","1.3.1")


create_environment(packages, versions)
