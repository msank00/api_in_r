#!/usr/bin/env Rscript



# total loss package list
#ls_pkg <- c("forcats","plyr","dplyr","data.table","readxl","lubridate","stringr","ggplot2","GGally","caret","mgcv","futile.logger","stringr","jsonlite","httr","plumber","future","doParallel")


#partial loss package list
ls_pkg <- c("dplyr","mgcv","stringr","futile.logger","stringi","jsonlite","lubridate","cluster","doParallel","plumber","future","httr")

n_packages <- length(ls_pkg)

for(i in seq(1:n_packages)){	
	
	pkgname <- ls_pkg[i]
	version <- packageDescription(pkgname)$Version
	license_info <- packageDescription(pkgname)$License
	message(sprintf("package: %s, version: %s, license: %s", pkgname, version, license_info))
	#c(i,packageDescription(i)$Version,packageDescription(i)$License))
}
#print(ls_vrsn)
#print(ls_pkg)
