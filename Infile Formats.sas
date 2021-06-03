/*
Stat 7020 - Homework 9
*/

libname hw9 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 9";
run;

/*
Problem 1 (55 points in total):
The following questions use the following datasets: staffmaster and staffchanges. The staffmaster dataset contains 
the Employee’s ID (EmpID), last name (LastName), first name (FirstName), city, State, phone number (phonenumber), 
salary, and department (dept). (5pts Each)
a.	Use an appropriate procedure to count up the number of people in each department. (5 pts). 
*/
proc sort data = hw9.staffmaster;
	by dept;
run;
proc freq data = hw9.staffmaster;
	tables dept;
run;

/*
Engineering 45
Sales 28
Support 75 
*/

/*
b.	Create a new dataset using only data steps that includes all of the individuals in staffmaster except for those 
in staffchanges. In other words, exclude in the dataset staffchanges from the staffmaster table. (10 pts). 
*/
data hw9.staffchanges;
	set hw9.staffchanges;
	exclude = "yes";
run;

proc sort data= hw9.staffchanges;
	by empid;
run;

proc sort data = hw9.staffmaster;
	by empid;
run;

data hw9.staffmerge;
	merge hw9.staffmaster hw9.staffchanges;
	by empid;
run;

data hw9.staffmerge;
	set hw9.staffmerge;
	if exclude = "yes" then delete;
	drop exclude;
run;

/*
c.	Use an appropriate procedure to calculate the average salary and the number of people in each department. (5 pts). 
*/
proc sort data = hw9.staffmerge;
	by dept;
run;
proc means data = hw9.staffmerge mean;
	var salary;
	by dept;
run;
/*
dept=Engineering
Analysis Variable
: salary  
Mean 
44589.19 

dept=Sales
Analysis Variable
: salary  
Mean 
48701.34 

dept=Support
Analysis Variable
: salary  
Mean 
48483.68 
*/
proc freq data = hw9.staffmerge;
	tables dept / nocum nopercent nofreq;
run;

/*
Engineering 45 
Sales 27 
Support 72 
*/

/*
d.	Create a new variable called “Name” that contains the first and last name (in that order) with a space between. 
(5 pts). 
*/
data hw9.staffmerge;
	set hw9.staffmerge;
	Name = catx(" ", FirstName, LastName);
run;

/*
e.	Create a new variable called “Area_Code” that contains the three digits representing the area code. Ensure it is 
stored as text and the length of the variable is appropriate. (5 pts). 
*/
data hw9.staffmerge;
	set hw9.staffmerge;
	Area_Code = substr(PhoneNumber, 1, 3);
run;


/*
f.	Use proc print to create a listing report with the subtotals for each department in such a way that it is one 
continuous report. (5 pts).
*/
proc print data = hw9.staffmerge;
sum salary;
by dept;
run;

/*
g.	Replace the “/” in the phone number with a dash. Ensure there is no space before or after the dash. (5 pts). 
*/
data hw9.staffmerge;
	set hw9.staffmerge;
	PhoneNumber = tranwrd(PhoneNumber, "/", "-");
run;


/*
h.	Create a new variable called City_prop that contains the city name but only the first letter(s) should be capital
ized of each word in the name and all others should be lower case. (5 pts). 
*/
data hw9.staffmerge;
	set hw9.staffmerge;
	City_Prop = propcase(City);
run;


/*
i.	Create a report that counts up the number of people in each state as well as the number of individuals in each 
state and department. (5 pts). 
*/
proc sort data = hw9.staffmerge;
	by state dept;
run;		
proc print data = hw9.staffmerge n;
	by state;
proc print data = hw9.staffmerge n;
	by state dept;
run;


/*
j.	Output the final dataset to a text file that is delimited by a “|” ensuring that the date maintains it 
formatting. The file should contain all of the updates completed above (5 pts). 
*/
proc export data = hw9.staffmerge
	outfile = 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 9\staffmerge.txt' 
	dbms = dlm
	replace;
	delimiter='|';
run;

/*
Problem 2 (40 pts in total):
The file Sales1.txt contains the following information. The start of the column and the length of the fields are 
provided.  The format of the variable in the text file is also included in the table below.  Use the data to complete
the questions below. 
a.   Create two SAS data sets from the raw data file, and base them on the country of the trainee. This should be 
done in one data step (not two or more). (15 pts) 
•	Name the data sets US_trainees and AU_trainees.  For this exercise, a trainee is anyone that has the job title of
Sales Rep. 
•	Each data set should contain the fields indicated by arrows in the layout table. 
•	Write only U.S. trainees to the US_trainees data set and only Australian trainees to the AU_trainees data set. Do
not keep the Country variable in the output data sets. 
*/
data hw9.US_trainees (DROP = COUNTRY);
	infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 9\sales1.txt" obs = 165 TRUNCOVER;
	input Employee_ID 1-6 /*First_Name $ 8-19*/ Last_Name $ 21-38 /*Gender $ 40*/ Job_Title $ 43-62 
		  Salary dollar10. Country $ 73-74 /*Birth_Date MMDDYY8. 76-85*/ Hire_Date mmddyy8.;  
	format Salary dollar10.;
	format Hire_Date mmddyy8.;
	if index(Job_Title, "Sales Rep.") > 0 and Country = "US";
run; 
data hw9.AU_trainees (DROP = COUNTRY);
	infile "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 9\sales1.txt" obs = 165 TRUNCOVER;
	input Employee_ID 1-6 /*First_Name $ 8-19*/ Last_Name $ 21-38 /*Gender $ 40*/ Job_Title $ 43-62 
		  Salary dollar10. Country $ 73-74 /*Birth_Date MMDDYY8. 76-85*/ Hire_Date mmddyy8.;  
	format Salary dollar10.;
	format Hire_Date mmddyy8.;
	if index(Job_Title, "Sales Rep.") > 0 and Country = "AU";
run;  

/*
b.   Print both of the data sets with appropriate titles and format the variables Salary and Hire Date appropriately.
(5 pts)
*/
proc print data = hw9.US_trainees;
	title "US Trainees";
run;
proc print data = hw9.AU_trainees;
	title "Australia Trainees";
run;

/*
c.   Use Proc Print to provide the grand total Salary paid out to US trainees. (5 pts)
*/
proc print data = hw9.US_trainees;
sum salary;
run;

/*
d.   Use proc means to create an output dataset that contains the average salary paid to the Australian trainees. 
(5 pts)
*/
proc means data = hw9.AU_trainees mean;
	var salary;
	output out = hw9.AU_average (drop=_type_ _freq_) mean=;
run;

/*
e.   Create one dataset called trainees by concatenating the two files. (5 pts)
*/
data hw9.trainees;
	set hw9.AU_trainees hw9.US_trainees;
run;

/*
f.   Output the dataset created in part ‘e’ to a csv file using data step coding. Ensure the dates are formatted 
correctly in the output file. Use the appropriate options to maintain the formats. (5 pts). 
*/
data _null_;
	set hw9.trainees;
	file "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 9\trainees.csv"
	dsd dlm = ",";
	put Employee_ID Last_Name Job_Title Salary Hire_Date;
run;




