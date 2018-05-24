Small repository to implement modules for Rolnik project: 

https://github.com/lambdaacademy/2018.05_erlang

cd("C:/Users/alekl/Documents/ErlangProtorypes/Rolnik").
c(db).

Module:
	database
API:
        init/0,            
			initializes Database whatever it is.
        terminate/0,            
			shutdowns down and cleans up after Database
        insert_measurement/2,
			inserts Temperature (first argument) and Humidity (second anrgument) with current date and time (sugested format {{Year, Month, Day}, {Hour, Minute, Second}}) to Database
        insert_measurement/3,
			inserts Temperature (first argument) and Humidity (second anrgument) with date and time (sugested format {{Year, Month, Day}, {Hour, Minute, Second}}) (third argument) to Database
        get_measurements/0,
			returns list of measurements (recommended [{measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}])
        get_measurements/1]
			returns list of measurements (recommended [{measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}]) and allows to filter them by passing Filtering function as argument
Additional Requirements:
	-
	
Module:
	website
API:
		get_web_address/0
			returns address of website that displays result graph
Additional Requirements:
	Sets website with graph of measurements in time
	
Module:
	measure_temperature

	
