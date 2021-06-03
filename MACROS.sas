/*
STAT 8020 - Homework 3
Due 3/8/2020
*/

/*Declaring Library for Homework 3 Files*/
libname hw3 "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 3";
run;

/*
1.	Import the CSV file into SAS.
*/

/* Importing "yr.mon.wk.csv" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 3\yr.mon.wk.csv"
	out = hw3.data
	DBMS = csv
	Replace;
run;

/*
2.	Define two macro variables: year and month. Assign a value of 2001 for year and 3 for month. 
Use whichever SAS procedure you would like to find the mean sales for March 2001 for each unique 
location. Make sure that your outputted table is appropriately and clearly titled.
*/
%let year = 2001;
%let month = 3;

proc sql;
select location as Location, avg(sale) as Average_Sales format 10.2
from hw3.data
group by location;
having year = &year and month = &month;
title "Mean Sales for March 2001 by Location";
quit;

/*
3.	Update the year macro variable to the value 2003. Now, using which SAS procedure you’d like, 
output a table containing the total sales and average sales for the unique locations.
*/
%let year = 2003;

proc sql;
select location as Location, avg(sale) as Average_Sales format 10.2, sum(sale) as Total_Sales format 10.2
from hw3.data
group by location;
having year = &year and month = &month;
title "Mean and Total Sales for March 2003 by Location";
quit;

/*
4.	Create three macro variables: city, year and amount. The macro variables values should be 
“DALLAS”, 2003 and 100, respectively. Subset the dataset by the above macro variables where sales
are less than 100. Output this subsetted dataset with appropriate titles.
*/

%let city = "DALLAS";
%let year = 2003;
%let amount = 100;

proc sql;
select *
from hw3.data
where sale < 100
having location = &city and year = &year; 
title "Observations in Dallas during 2003 where Sales < 100";
quit;

/*
5.	Output a report for the Dallas location over all available years where the total sales for 
each unique piece of equipment are outputted. Use macro variables to subset the dataset and use 
automatic macro variables in the footnotes of the report to show what time and date the report 
was generated. Use appropriate titles.
*/
title "Total Sales of each Equipment in Dallas for All Time";/*Use appropriate titles.*/
footnote "Created &systime &sysday, &sysdate9";/*use automatic macro variables in the footnotes
of the report to show what time and date the report was generated.*/
proc sql;
select distinct equipments as Equipment, sum(sale) as Total_Sales format 10.2
from hw3.data
group by Equipment/*for each unique piece of equipment are outputted.*/
having location = &city;/*Use macro variables to subset the dataset*/
quit;

/*
6.	Briefly describe each of the following macro functions: 
%PUT: Defines a macro variable as a particular value
%SYMBOLGEN: Displays the results of resolving macro variable references, useful when debugging
%STR: Masks special characters and operators during compilation of a macro statement
%NRSTR: Does the same as %STR but also includes & and %
%SUBSTR: produces a substring of the "argument" beginning at "position" for "length" # of characters
%QSUBSTR: same as %SUBSTR, but also masks special characters and mnemonic operators
%INDEX: searches "source" for first instance of "string" and returns position of first char, upon failure returns 0.
%SCAN: searches "argument" and returns n'th word.
%QSCAN: same as %scan, but masks special characters and mnemonic operators
*/

/*
7.	Write a macro function to split the dataset by unique location. This can be approached 
several different ways. Run the macro to save the individual location datasets. Try to write 
this code generally enough to be used with any number of unique locations.
*/

%macro split(newtable, dataset, variable, value);
proc sql;
create table &newtable as
select *
from &dataset
where &variable = &value;
quit;
%mend split;

%split(hw3.Boston, hw3.data, location, "BOSTON");
%split(hw3.Chicago, hw3.data, location, "CHICAGO");
%split(hw3.Dallas, hw3.data, location, "DALLAS");
%split(hw3.LA, hw3.data, location, "LA");

/*
8.	Use the same macro function you created in Question 7 to split the original dataset by 
unique year.
*/
%split(hw3.year2003, hw3.data, year, 2003);

/*
9.	Write a macro function to import a CSV file. Reimport the yr.mon.wk CSV using your function.
*/
%macro importcsv(location, tablename);
proc import datafile = &location
	out = &tablename
	DBMS = csv
	Replace;
run;
%mend importcsv;

%importcsv("C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 3\yr.mon.wk.csv", hw3.q9);

/*
10.	Some of the area codes have met their daily sales targets and some haven’t. Create a macro 
variable for area code and assign it a value of 3. Subset the larger dataset by areacode and 
determine if there were some days which locations in areacode 3 did not meet all of their daily 
sales targets. If they did, output the subsetted dataset with the footnote, “All locations meet 
target.” If they did not, output the subsetted dataset with the footnote, “Not all locations 
meet target.”
*/

/*Figuring out whether each area code has both yes and no and how many of each*/
proc sort data = hw3.data;
	by salestarget areacode;
run;
proc freq data = hw3.data;
	tables areacode;
	by salestarget;
run;

%let code = 3; /*Create a macro variable for area code and assign it a value of 3.*/

%split(hw3.code3, hw3.data, areacode, &code);

/*This code creates a dummy variable which detects no's and a nocheck variable which indicates 
whether there is a single no observation in the dataset. Done in a macro to generate global var*/
%macro q10;
data hw3.q10;
	set hw3.code3;
	if salestarget = "NO" then no = 1;
		else no = 0;
	sumno + no;
	%if sumno = 0 %then %do;
	%let nocheck = 0;
	%end;
	%else %do;
	%let nocheck = 1;
	%end;
run;
%mend q10;
%q10;
%put &nocheck;

%if &nocheck = 0 %then %do;
proc print data = hw3.code3;
	Footnote "All locations meet target.";
run;
%end;
%else %do;
proc print data = hw3.code3;
	Footnote "Not all locations meet target.";
run;
%end;

/*
11.	Briefly describe how indirect macro variable referencing works and a situation when it might 
be useful. 

During iterative processing, it is useful to be able to reference numbered macro variables so that
they can be referenced without having to type out each one. For example, if you had a series of macro
variables name1, name2, ... name100 then you could write an iterative macro program to perform some 
operation referencing each variable or according to some condition using a double ampersand with the 
index &n ie &&name&n.
*/
