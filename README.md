  <img src="https://img.shields.io/badge/application-REST%20API-yellow.svg?style=flat-square" alt="application API">  <img src="https://img.shields.io/badge/language-R-green.svg?style=flat-square" alt="made with R"> <img src="https://img.shields.io/badge/package-Plumber-blue.svg?style=flat" alt="made with plumber">

![image](images/rlogo.png)

# Expose R Machine Learning Project as REST API

This repo is a small setup to quickly refactor your `R` machine learning script in production ready format via `REST API` service.
The purpose of this meta project is to create `REST API` for your machine learning project in `R` and expose your model
to the end user. The project contains ready-made script to create the below APIs in `R`:

- `preprocessing` 
- `traiing`
- `prediction`

The user only needs to plug his original preprocessing, training and prediction logic as
function. And then call the respective modules from the respective API functions. Currently to simulate the above three tasks, dummy
code snippet is used, which the user will replace with his appropriate code. 
 
The code also implements basic `logging` facility for debugging purpose.



# Package Information


+ package `plumber`: for creating api
+ package `futile.logger`: for capturing the log
+ package `future`: for creating asynchronous function call for preprocessing and training

# Main Scripts


+ The `prediction_API.R` holds the actual code for prediciton module for the `/predict` api.
  + `run_prediction_API.R` is a wrapper script to start the `prediction_API.R`
+ The `training_model_API.py` holds the code for preprocessing and training module for the apis `/preprocess` and `/train`
  + `run_training_API.R` is a wrapper script to start the `training_model_API.R`
+ The `dummyAPI.R` under directory `/testdir` holds the dummy scipt for `/notify` api for implementing callback facility
+ The `start.sh` scripts can be used to start all the server at one go
+ You may need to start the dummy api separately.


# Start the PREDICTION SERVER (/predict API):


+ `Rscript run_prediction_API.R <prediction port number>` OR
  + use the `start.sh` file, run it as follows:
   + `./start.sh`
   + Remember to update the `start.sh` for port changing
## Run the client from terminal
  + following curl command can be used:
    + `curl http://localhost:<prediction_server_port>/predict --data '{"input": [{"UID":"1","AGE":"15"},{"UID":"2","AGE":"25"},{"UID":"3","AGE":"45"},{"UID":"4","AGE":"55"}]}' -H "Content-Type: application/json"`
	+ `/predict` is the prediction API end point
	+ You may need to update the `port number` in the above curl command


# Start the Training SERVER (/preprocess and /train API):
  +  `Rscript run_training_API.R <train port number>` OR
  + use the `start.sh` file and run `./start.sh`
  + As training and preprocessing can take several minutes, they should be called asynchronously using python package `future` followed by a post call to the `callback API` for sending the status of preprocessing and training.

##Run the client from the terminal 
  + curl for preprocessing api `/preprocess`
    + `curl http://localhost:<train_server_port>/prepro --data '{"callbackURL":"http://localhost:<notify_server_port>/notify"}' -H "Content-Type: application/json"`
  + curl for training api `/train`
    + `curl http://localhost:<train_server_port>/train --data '{"callbackURL":"http://localhost:<notify_server_port>/notify"}' -H "Content-Type: application/json"`
  + The above `callbackURL` is a dummy api for testing. The dummy api script is in `/testdir` folder. Run the dummy callback API `python dummy_API.py`

# Start the Notify Server for Callback facility
  + `Rscript notifyAPI.R <notify port number>` 

# Known issues for the repo:
  + Currently, the asynchronous call by the `future` package is not sending the response to client immediately.
  + ...

# Known issues in R
  + Nested file source may lose the argument value. So use sourcing as follows
  `source(filename, local=TRUE)`
  + Rememeber sourcing a file `outside` a function and `inside` a function are two different scenario.
    + It changes the scope of the variable to the sourced scripts.
	+ global variebles are not available to a sourced script if it's sourced inside a function.

