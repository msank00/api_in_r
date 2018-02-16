## Sample API in R
+ For API, package used `plumber`
+ For capturing the logging, package used `futile.logger`
+ The `prediction_API.R` holds the actual code for prediciton module
+ The `run_prediction_API.R` is a wrapper around the prediction script. You need to run this wrapper for starting the API servre.
+ To start the SERVER API:
  + `Rscipt run_prediction_API.R <port number>` OR
  + use the `start.sh` file, run it as follows:
   + `./start.sh`
   + Remember to update the `start.sh` for port changing
+ To run the client from terminal
  + following curl command can be used:
    + ```
	curl http://localhost:<port number>/predict --data '{"input": [{"UID":"1","AGE":"15"},{"UID":"2","AGE":"25"},{"UID":"3","AGE":"45"},{"UID":"4","AGE":"55"}]}' -H "Content-Type: application/json"
	```
	+ `/predict` is the prediction API end point
	+ You may need to update the `port number` in the above curl command
+ Create the `training_API.R` similarly like `prediction_API.R` 
+ Create the `run_training_API.R` similarly like the `training_API.R`
+ Set a port number for training server and update the `start.sh` with the port number
+ As training and preprocessing can take several minutes, they should be called asynchronously using r package `future` followed by a post call to the `callback API` for sending the status of preprocessing and training.
+ Write a `curl` command as above to call the preprocessing and training API with `callback URL`
  + ```
	curl http://localhost:<port number>/prepro --data '{"callbackURL":"http://localhost:<port number>/notify"}' -H "Content-Type: application/json"
  ```
  + ```
	curl http://localhost:<port number>/train --data '{"callbackURL":"http://localhost:<port number>/notify"}' -H "Content-Type: application/json"
  ```
  + The above callback url is a dummy api for testing. The dummy api script is in `/test` folder. Run the dummy callback API `Rscript run_dummy_API.R <port number>`
