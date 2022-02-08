This gaze following folder provides all the data and R scripts to do
the pre-processing necessary for analyses for the multi lab gaze following study.

folders:
~ AOIs
	- in this folder the Area's of Interest (AOIs) of each lab are visualized
	- these files are generated using the 'visualize_AOI.R' script in the R_functions folder
~ data_analysis
	- contains the raw data and eye-tracking detail file of the lab 
	- a log file that mentions possible issues with the data
	- an R script that pre-processes the data into fixations and saves all data into a Rdata file for further analysis
	- an Rdata file that contains the raw data, processed data, AOIs information and Lab settings such as screen dimensions and samplerate
~ processed_data
	- contains the processed data of each lab in the pre-registered format
	- these files are generated using the 'analyze_data.R' script in the R_functions folder
~ R_functions
	- contains the 3 R functions to visualize and analyze the data
~ visualizations
	- contains for each lab visualizations of the raw x- and y-coordinate gaze data of each participant on every trial as a function of time
	- a readme file that explains what is shown on every plot
	- these plots are generated using the 'visualize_data.R' script in the R_functions folder

analysis.R:
~ This is the R script that calls the different functions described above to analyze and visualize the data of all labs

