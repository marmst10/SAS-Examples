/***************************************
STAT 7100 - HOMEWORK 4
***************************************/

libname hw4 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 4";
run;
	proc export data = hw4.soldbooks2
		outfile = "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 4\soldbookstest.csv"
		dbms = csv
		replace;
	run;
/*
1. Format the dollar values appropriately so there are 2 decimal places and a dollar sign.
Wholesale cost, list price, and sale price
*/

	
	data hw4.soldbooks;
		set hw4.soldbooks;
		format Wholesale Cost Dollar16.2;
	run;
	data hw4.soldbooks;*This is not Working, so I am going to export Soldbooks as a txt document.;
		set hw4.soldbooks;
		format List Price Dollar16.2;
	run;
	data hw4.soldbooks;*This is not Working, so I am going to export Soldbooks as a txt document.;
		set hw4.soldbooks;
		format Sale Price Dollar16.2;
	run;

	proc export data = hw4.soldbooks
		outfile = "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 4\soldbookstest.txt"
		dbms = csv
		replace;
	run;*/
*Discovered that the columns are actually called cost, listprice, and saleprice. They are formatted to
appear as Wholesale cost etc. This is why wholesale cost dollar16.2 worked.;

data hw4.soldbooks;
	set hw4.soldbooks;
	format cost Dollar10.2 listprice dollar10.2 saleprice dollar10.2;
run;
 

/*
2. Format the date variable so it has day/month/year formatting. 
*/

data hw4.soldbooks;
	set hw4.soldbooks;
	format date ddmmyy10.;
	drop wholesale list price sale;*previous error caused new columns to appear;
run;


/*
3. It cost the store 3% to process Visa cards and 4% to process Mastercard transactions.  
Calculate a new variable called profit that is the difference between the sale price and 
the cost. This profit should also account for the additional cost associated with the 
processing fees. 
*/

data hw4.soldbooks;
	set hw4.soldbooks;
	if paytype = 0 or paytype = 1
		then profit = saleprice - cost;
	else if paytype = 2
		then profit = (saleprice * 0.97) - cost;
	else profit = (saleprice * 0.96) - cost;
	format profit dollar10.2;
run;


/*
4. Create an accumulator variable that determines the total amount the store spent on the 
inventory.
*/

/*This works, but a better solution is below.

data hw4.soldbooks;
	set hw4.soldbooks;
	totalcost + cost;
	drop totalcost;
run;

*/


/*SAME THING FOUND ON SAS WEBSITE, CREATES A NEW DATASET WITH ONLY DESIRED VARIABLE
	options pagesize=60 linesize=80 pageno=1 nodate;
	data total2(keep=TotalBookings);
	   set mylib.tourrevenue end=Lastobs;
	   TotalBookings + NumberOfBookings;
	   if Lastobs;
	run;

	proc print data=total2;
	   title 'Total Number of Tours Booked';
	run;
*/

options pageno=1 nodate;
data hw4.totalcost(keep=totalcost);
	set hw4.soldbooks end=lastobs;
	totalcost + cost;
	if lastobs;
	format totalcost dollar10.2;
run;
proc print data=hw4.totalcost;
	title 'Total that Store spent on Inventory';
run;


/*
5. Create another accumulator variable that determines the total amount made by the store 
in profit. 
*/

options pageno=1 nodate;
data hw4.totalprof(keep=totalprof);
	set hw4.soldbooks end=lastobs;
	totalprof + profit;
	if lastobs;
	format totalprof dollar10.2;
run;
proc print data=hw4.totalprof;
	title 'Total Store Profit';
run;


/*
6. The variable store is not standardized. Create a new variable called storetype that 
contains a 1 if the item was sold in the store and 0 if it was not.
*/

*process the frequencies of the variables to show how many unique observations for this
variable are present in this dataset;
proc freq data = hw4.soldbooks;
	tables store / out=hw4.storefreq;
	Title 'Types of Responses for Variable: store';
run;
	
/*From data science project file
	proc freq data=ds7900.sales;
		tables order_date / out=ds7900.sales_order_date_FCount;
		title 'Sales order_date Frequencies';
	run;*/

/*From Lecture 6 code
	proc format;
		value $ Emer
			"N", "No", "n", "no" = "No"
			"Y", "y", "YES", "Yes", "yes" = "Yes"
			otherwise = "Do not know.";
	run;

	data lecture6.claims;
		set lecture6.claims;
		format emer emer.;
	run;*/


/*huge failure here
			proc format;
				value sto
					"N", "No" = 0
					"Y", "YES", "Yes" = 1
					otherwise = 2;*"Do not know.";
			run;

			data hw4.soldbooks;
				set hw4.soldbooks;
				format store sto.;

			run;

			proc freq data = hw4.soldbooks;*checking for 2's;
				tables store / out = hw4.stofreq;
				title "Checking to make sure there are no 2's present";
			run;*No 2's :) ;
end of huge failure*/


data hw4.soldbooks;
	set hw4.soldbooks;
	if store = "N" or store = "No" then storetype = 0;
	else storetype = 1;
run;

/*
7. Create another dataset that contains information on all of the internet orders. Do 
this in one step and calculate the total amount paid for each book as the saleprice plus 
mail. Also accumulate the amount made from the internet orders (profit).
*/

data hw4.internet;
   	set hw4.soldbooks;
   	if storetype=0;
   	drop storetype;*redundant;
 	totalpaid = saleprice + mail;
   	interprof = mail+profit;/*assuming here that all money taken in from mail is "profit"*/
	totintprof + interprof;/*cumulative internet profit variable, this time stays in dataset*/
	format totintprof dollar10.2 interprof dollar10.2 mail dollar10.2 totalpaid dollar10.2;
	drop profit;/*confusing to have 2 profit variables?*/
run;


/*
8. Create a new dataset with the last record from the total dataset only. Keep only the 
totals and name it appropriately. Look up the keyword “End.” 
~I interpret this as the soldbooks dataset. I already kinda did this above with 
	options pageno=1 nodate;
	data hw4.totalprof(keep=totalprof);
		set hw4.soldbooks end=lastobs;
		totalprof + profit;
		if lastobs;
		format totalprof dollar10.2;
	run;
	proc print data=hw4.totalprof;
		title 'Total Store Profit';
	run;
~This does not include the total profits for internet or total costs. I will create a dataset for these.
*/
options pageno=1 nodate;
data hw4.total(keep=totalprof totalcost totintprof);
	set hw4.soldbooks end=lastobs;
		totalprof + profit;
		totalcost + cost;
		if storetype=0 then
		   	interprof = mail+profit;/*assuming here that all money taken in from mail is "profit"*/
		if storetype=0 then
			totintprof + interprof;/*cumulative internet profit variable, this time stays in dataset*/
		if lastobs;
		output;
	format totalprof dollar10.2 totalcost dollar10.2 totintprof dollar10.2;
run;
proc print data=hw4.total;
	title 'Total Store Profits';
run;



/*
9. Bonus question: Attempt to use proc freq to determine the highest volume days in the 
month of the September.  Does it vary if we also account for the store type?
*/
proc freq data = hw4.soldbooks;
	tables date / out = hw4.datefreq;
	title "Date Frequency Table";
run;

*need to export to find names of variables;

proc export data = hw4.datefreq
	outfile = "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 4\datefreqtest.txt"
	dbms = csv
	replace;
run;*the "Frequency Count" variable is called "count";
*So, all observations are from the month of september, so we do not need to take any out.
The highest frequency day;
proc means data=hw4.datefreq max;
  var count;
run;
proc sort data=hw4.datefreq;
	by descending count;
run;*The max is 638 on september 3rd, second highest is the 24th, third is the 17th.;

*Does it vary if we also account for the store type?;

proc freq data = hw4.internet;
	tables date / out = hw4.intdatefreq;
	title "Internet Only Date Frequency Table";
run;

proc sort data=hw4.intdatefreq;
	by descending count;
run;

data hw4.store;*create dataset for store purchases only;
   	set hw4.soldbooks;
   	if storetype=1;
   	drop storetype;*redundant;
run;*Interestingly, the new order for the top 3 days is 9/3, 9/24, 9/21.;

proc freq data = hw4.store;
	tables date / out = hw4.stodatefreq;
	title "Store Only Date Frequency Table";
run;

proc sort data=hw4.stodatefreq;
	by descending count;
run;*The order of the top 3 days is 9/3, 9/24, 9/17 as before.;


/*
10.	Bonus question: Examine the total amount of profit per day. Are there specific days 
that make more money? Find a function to turn this into the days of the week and summarize 
the volumes and profits by day of the week. 
*/

*Need to reexamine by day of week, then figure out how many of each day are present, so that
if there are 5 saturdays and 4 fridays, for example, we can account for those differences 
and they won't skew the analysis.;

proc freq data = hw4.soldbooks;
	tables date / out = hw4.datefreq2;
	title "Date Frequency Table";
run;

*9/1/2011 was a Thursday. 18871 is the 'smallest' date
We want
0:sunday
1:monday
2:tuesday
3:wednesday
4:thursday
5:friday
6:saturday
;

data hw4.datefreq3;
	set hw4.datefreq2;
	format date 10.;*make date int;
	date2 = date-18867;*Subtract (18870-3) because we want 9/1 to be 5 or thursday;
	dow = mod(date2, 7);
run;

/*This worked, but it would be easier to perform this operation on the original dataset,
then perform a proc freq to get the freq totals that way.*/

data hw4.soldbooks;*This operation will create a variable dow in the soldbooks dataset;
	set hw4.soldbooks;
	format date 10.;*make date int;
	date2 = date-18867;*Subtract (18870-3) because we want 9/1 to be 5 or thursday;
	dow = mod(date2, 7);
run;

proc freq data = hw4.soldbooks;
	tables dow / out = hw4.datefreq4;
	title "Totals by day of Week";
run;

*setting 1-6 to actual day words;
proc format;
	value myday
	1 = "Monday"
	2 = "Tuesday"
	3 = "Wednesday"
	4 = "Thursday"
	5 = "Friday"
	6 = "Saturday";
run;

*There are no sunday sales, ie no 0's in this dataset. The structure of the month is as follows:

0	1	2	3	4	5	6
SUN	MON	TUE	WED	THU	FRI	SAT
				1	2	3
4	5	6	7	8	9	10
11	12	13	14	15	16	17
18	19	20	21	22	23	24
25	26	27	28	29	30	
						
4	4	4	4	5	5	4

Where the bottom numbers are the total number of days of each week. The frequency values will be
adjusted accordingly.;

data hw4.datefreq5;
	set hw4.datefreq4;
	if dow = 4 then
		count = count*0.8;
	if dow = 5 then
		count = count*0.8;
	drop percent;*these values are meaningless now.;
run;

data hw4.datefreq5;*Changing date to words;
	set hw4.datefreq5;
	format dow myday.;
run;

proc sort data = hw4.datefreq5;
	by descending count;
run;

proc print data = hw4.datefreq5;
	title  "Sorted Day of Week Totals Adjusted for Number of Days";
run;	

