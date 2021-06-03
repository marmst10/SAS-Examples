/**********************************************
STAT 7020 - HOMEWORK 2
**********************************************/

/*
1. Use SAS Code to create a permanent library on your PC. 
*/
libname hw2 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2";
run;

/*
2a. Use list input to import the cereal.csv file.  
*/
data hw2.cereal;
	infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2\cereal.csv" 
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=2;
	input NAME $ MFR $ TYPE $ CAL PROT FAT SOD FIBER CARB SUGAR POT WEIGHT CUPS;
run;	

/*
2b. Examine the log, what does it say? 
	755  data hw2.cereal;
	756      infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework
	756! 2\cereal.csv"
	757      delimiter = ','
	758      MISSOVER
	759      DSD
	760      lrecl=32767
	761      firstobs=2;
	762      input NAME $ MFR $ TYPE $ CAL PROT FAT SOD FIBER CARB SUGAR POT WEIGHT CUPS;
	763  run;

	NOTE: The infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework
	      2\cereal.csv" is:

	      Filename=C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework
	      2\cereal.csv,
	      RECFM=V,LRECL=32767,File Size (bytes)=4491,
	      Last Modified=12Sep2019:12:58:20,
	      Create Time=12Sep2019:12:58:17

	NOTE: 77 records were read from the infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS
	      Programming\Homework 2\cereal.csv".
	      The minimum record length was 44.
	      The maximum record length was 84.
	NOTE: The data set HW2.CEREAL has 77 observations and 13 variables.
	NOTE: DATA statement used (Total process time):
	      real time           0.01 seconds
	      cpu time            0.03 seconds
*/

/*
2c. Once you remove error messages from the log, print the data. 
*/
proc print data = hw2.cereal;
run;

/*
2d. Is the full name in the dataset? How many characters? 
	No. 8.
*/

/*
3a.	To fix the issue discovered in problem 3, insert the following 
	statement before the input statement (without quotes) – “length name $32.;” 
	Run the code, examine the log, and print the results. 
*/
data hw2.cereal2;
	infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2\cereal.csv" 
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=2;
	length name $32.;
	input NAME $ MFR $ TYPE $ CAL PROT FAT SOD FIBER CARB SUGAR POT WEIGHT CUPS;
run;	

/*
3b. Run the code, examine the log, and print the results. 
	There are still a couple who are too long, but this can be corrected by changing 32 to 40
*/
data hw2.cereal2; 
	infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2\cereal.csv" 
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=2;
	length name $40.;/*CORRECTION*/
	input NAME $ MFR $ TYPE $ CAL PROT FAT SOD FIBER CARB SUGAR POT WEIGHT CUPS;
run;

/*PRINTING RESULTS*/	
proc print data = hw2.cereal2;
run;

/*
4. print the first 10 obs
*/
proc print data = hw2.cereal2 (obs=10);
run;

/*
5. print obs 15 through 22
*/
proc print data = hw2.cereal2 (firstobs=15 obs=22);
run;

/*
6.	Use list output to create a new pipe delimited text file that contains 
only the name, mfr,  cal, and fat. To test your code, only output 10 records
at first and then output the entire dataset.
*/
proc export data = hw2.cereal2 (obs=10) /*TEST*/
	outfile = 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2\cerealpipetest.txt' 
	dbms = dlm
	replace;
	delimiter='|';
run;

proc export data = hw2.cereal2 /*REAL*/
	outfile = 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2\cerealpipe.txt' 
	dbms = dlm
	replace;
	delimiter='|';
run;

/*
7.	Use a filename reference and import the file just created but only import 5 records 
to test your code. Then, import all of the records.  
*/
filename cer_in 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 2\cerealpipe.txt';
options obs=6;/*NEED TO IMPORT 5+1 LINES TO INCLUDE COLUMN NAMES*/

data hw2.cerealtest; 
	infile cer_in
	delimiter = '|' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=2
	;
	length name $40.;
	input NAME $ MFR $ TYPE $ CAL PROT FAT SOD FIBER CARB SUGAR POT WEIGHT CUPS;
run; 

options obs=max;/*resetting global obs to max*/

data hw2.cerealpipe; 
	infile cer_in
	delimiter = '|' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=2
	;
	length name $40.;
	input NAME $ MFR $ TYPE $ CAL PROT FAT SOD FIBER CARB SUGAR POT WEIGHT CUPS;
run; 

/*
Did the name import correctly? 
	Yes.
If not, what should you do? 
	At first it didn't, but I noticed a typo in my code was setting the firstobs at 22. Easy fix :)
*/
