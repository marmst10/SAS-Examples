/*********************************************
STAT 7020 - HOMEWORK 5
DUE 10/28/19
*********************************************/

libname hw5 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 5";

/*
Checking variable names
*/
proc export data = hw5.sample
	outfile = 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 5\out.csv' 
	dbms = csv
	replace;
run;


/*
1. With as few formats as possible, format each variable included in the file as described above. Be sure to
indicate which values indicate the respondent refused to answer or the question was not asked or the 
respondent did not know.  Ensure each variable is formatted. */
proc format;
	value reg
		1 = "Northeast"
		2 = "Midwest"
		3 = "South"
		4 = "West";
	value gen
		1 = "Male"
		2 = "Female";
	value no /*Same for sodano frjuicno coffeeno redmetno*/
		000 = "Never"
		997 = "Refused"
		998 = "Not Ascertained"
		999 = "Don't Know";
	value tp /*Same for sodatp frjuictp coffeetp redmettp*/
		0 = "Never"
      	1 = "Per day"
      	2 = "Per week"
      	3 = "Per month"
      	7 = "Refused"
      	8 = "Not Ascertained"
      	9 = "Don't know";
	value gth
		1 = "Yes"
		2 = "No"
		7 = "Refused"
		8 = "Not Ascertained"
		9 = "Don't Know";
	value gtc
		1 = "More Likely"
		2 = "Less Likely"
		3 = "About as Likely"
		7 = "Refused";
	value qol
		1 = "Excellent"
		2 = "Very Good"
		3 = "Good"
		4 = "Fair"
		5 = "Poor"
		7 = "Refused"
		8 = "Not Ascertained"
		9 = "Don’t Know";
	value soda
		7777 = "Refused"
		8888 = "Not Ascertained"
		9999 = "Don't Know"
		0 = "Never";
run;

data hw5.sample;
	set hw5.sample;
	format region reg. sex gen. sodano no. sodatp tp. frjuicno no. frjuictp tp. coffeeno no. coffeetp tp.
	redmetno no. redmettp tp. gtheard gth. gtccom gtc. qol qol. qolph qol. qolmh qol. soda30 soda.;
run;

/* 
2. Create a new variable for Soda consumption that reports the total number of sodas consumed in a 30 day 
time period. For example, if they drink 1 soda per day then that would be 30 sodas in 30 days. Make an 
assumption so you can convert weeks into 30 day time periods.*/

/*
ASSUMING EVERY MONTH IS 30 DAYS
*/

data hw5.sample;
	set hw5.sample;
	if sodatp=0
		then soda30=0;
	else if sodatp=1
		then soda30=sodano*30;
	else if sodatp=2
		then soda30=sodano*30/7;
	else if sodatp=3
		then soda30=sodano;
	else /*else 7,8,9 keep it for formatting later*/
		soda30=sodatp*1111;/*7 becomes 7777, 8 becomes 8888, 9 becomes 9999 need to format^^ after*/
run;


/*
3. Examine the average number of sodas consumed in 30 days. */

/*
Need to disregard text observations of the soda30 variable
Set those to 0
*/


data hw5.sample;
	set hw5.sample;
	if soda30=0
		then soda2=0;
	else if soda30=7777
		then soda2=0;
	else if soda30=8888
		then soda2=0;
	else if soda30=9999
		then soda2=0;
	else
		soda2=soda30;
run;

proc means data=hw5.sample mean;

var soda2;

run;

/*
Result is 12.117 sodas per month on average, assuming refused, not ascertained and don't know are 0.
*/
	
/*
4. Examine the average number of sodas consumed in 30 days by gender. Are there any interesting results? 
This is a discrete quantitate variable. */
proc means data=hw5.sample mean;

var soda2;

class sex;

run;

/*
In this sample, men drink 4 sodas per month more than women on average.
*/

/*
5. Examine the average number of sodas consumed in 30 days by region. Are there any interesting results? 
This is a discrete quantitate variable.*/
proc means data=hw5.sample mean;

var soda2;

class region;

run;


/*
Here are the results:

Region		Mean
Northeast 	8.6215218 
Midwest 	13.5721200 
South 		14.4310209 
West 		9.6735412 

People in the Northeast in this sample drink the least amount of sodas per month on average at an average 
value of ~8.6 sodas per month while people in the south in this sample drink the most sodas per month of 
the four regions on average at an average value of ~14.4 sodas per month
*/


/*
6. Examine the average number of sodas consumed in 30 days by region and gender. Are there any interesting 
results? This is a discrete quantitate variable.*/
proc means data=hw5.sample mean;

var soda2;

class region sex;

run;

/*

Region		Sex		Mean
Northeast 	Male	9.8867642 
  			Female	7.6433210 
Midwest 	Male	16.3932242 
  			Female	11.3697304 
South 		Male	16.7251893 
  			Female	12.6373312 
West 		Male	12.5437668 
  			Female	7.3145146 

Men in this sample tend to drink more sodas on average than the women by region, in all 4 regions.
*/

/*
7. Examine the QOL variable. This is categorical, not continuous.  */
proc freq data = hw5.sample;
	table qol;
run;

/*
QOL 			Frequency	Percent
Excellent 		7295 		26.86 
Very Good 		8707 		32.06 
Good 			6459 		23.78
Fair 			2017 		7.43
Poor 			427 		1.57
Refused 		93 			0.34 
Not Ascertained 2115 		7.79
Don’t Know 		44 			0.16 

The highest response for any option for qol in this sample was "Very Good" at 32.06%.
The lowest (other than refused, not ascertained, or don't know) was "Poor" at 1.57% 
*/

/*
8. Examine the QOL variable by gender.*/
proc sort data = hw5.sample;
	by sex;
run;	

proc freq data = hw5.sample;
	table qol;
	by sex;
run;

/*
Sex=Male
QOL 			Frequency 	Percent 
Excellent 		3166 		26.41  
Very Good 		3860 		32.20 
Good 			2898 		24.18 
Fair 			915 		7.63 
Poor 			182 		1.52 
Refused 		46 			0.38 
Not Ascertained 899 		7.50 
Don’t Know 		20 			0.17

Sex=Female
QOL 			Frequency 	Percent
Excellent 		4129 		27.22 
Very Good 		4847 		31.95
Good 			3561 		23.47 
Fair 			1102 		7.26
Poor 			245 		1.61
Refused 		47 			0.31 
Not Ascertained 1216 		8.02 
Don’t Know 		24 			0.16

The percentages look very similar. It would seem that in this sample at least, that the 
qol for males and females are similar
*/

/*
9. Examine the QOL variable by gender and region.*/
proc sort data = hw5.sample;
	by sex region;
run;	

proc freq data = hw5.sample;
	table qol/nocum out = hw5.samplesrfreq;/*nocum suppresses cumulative frequency and percent for cleaner tables.*/
	by sex region;
run;
 
/*
Sex=Male Region=Northeast
QOL 			Frequency 	Percent 
Excellent 		501 		26.30 
Very Good 		618 		32.44 
Good 			430 		22.57 
Fair 			135 		7.09 
Poor 			35 			1.84 
Refused 		16 			0.84 
Not Ascertained 163 		8.56 
Don’t Know 		7 			0.37 

Sex=Male Region=Midwest
QOL 			Frequency 	Percent 
Excellent 		680 		25.89 
Very Good 		903 		34.37 
Good 			627 		23.87 
Fair 			171 		6.51 
Poor 			47 			1.79 
Refused 		21 			0.80 
Not Ascertained 171 		6.51 
Don’t Know 		7 			0.27 

Sex=Male Region=South
QOL 			Frequency 	Percent 
Excellent 		1179 		26.94 
Very Good 		1291 		29.50 
Good 			1119 		25.57 
Fair 			373 		8.52 
Poor 			63 			1.44 
Refused 		4 			0.09 
Not Ascertained 344 		7.86 
Don’t Know 		3 			0.07 

Sex=Male Region=West 
QOL Frequency Percent 
Excellent 806 26.19 
Very Good 1048 34.05 
Good 722 23.46 
Fair 236 7.67 
Poor 37 1.20 
Refused 5 0.16 
Not Ascertained 221 7.18 
Don’t Know 3 0.10 

Sex=Female Region=Northeast
QOL Frequency Percent 
Excellent 599 24.31 
Very Good 795 32.26 
Good 581 23.58 
Fair 185 7.51 
Poor 40 1.62 
Refused 10 0.41 
Not Ascertained 250 10.15 
Don’t Know 4 0.16 

Sex=Female Region=Midwest
QOL Frequency Percent 
Excellent 938 27.88 
Very Good 1124 33.40 
Good 769 22.85 
Fair 204 6.06 
Poor 42 1.25 
Refused 20 0.59 
Not Ascertained 261 7.76 
Don’t Know 7 0.21 

Sex=Female Region=South
QOL Frequency Percent 
Excellent 1576 28.16 
Very Good 1658 29.62 
Good 1352 24.16 
Fair 457 8.17 
Poor 102 1.82 
Refused 9 0.16 
Not Ascertained 434 7.75 
Don’t Know 9 0.16 

Sex=Female Region=West
QOL Frequency Percent 
Excellent 1016 27.13 
Very Good 1270 33.91 
Good 859 22.94 
Fair 256 6.84 
Poor 61 1.63 
Refused 8 0.21 
Not Ascertained 271 7.24 
Don’t Know 4 0.11 
*/

/*
10. Create a new format that groups ages into different categories. An example would be 18 – 24, 25 to 34, 
35 to 44, 45 to 54, 55 to 64, and 65 plus.  Play around with different groups (i.e. should have at least 2 
different formats). */
proc format;
	value ageA
	18 -< 24 = "Yng Ad 1"
	25 -< 34 = "Yng Ad 2"
	35 -< 44 = "Adult"
	45 -< 54 = "Mid Aged"
	55 -< 64 = "Older"
	65 - high = "Ret. Age";
run;
data hw5.sample;
	set hw5.sample;
	format age_p ageA.;
run;

proc format;
	value ageB
	18 -< 24 = "Yng Ad 1"
	24 -< 34 = "Yng Ad 2"
	34 -< 44 = "Adult"
	44 -< 54 = "Mid Aged"
	54 -< 64 = "Older"
	64 - high = "Ret. Age";
run;
data hw5.sample;
	set hw5.sample;
	format age_p ageB.;
run;

/*
11. Examine the relationship between QOL and the age groupings. */
proc sort data = hw5.sample;
	by age_p;
run;	

proc freq data = hw5.sample;
	table qol/nocum;/*nocum suppresses cumulative frequency and percent for cleaner tables.*/
	by age_p;
run;

/*
Age=Yng Ad 1
QOL Frequency Percent 
Excellent 808 34.62 
Very Good 761 32.60 
Good 504 21.59 
Fair 118 5.06 
Poor 10 0.43 
Refused 4 0.17 
Not Ascertained 127 5.44 
Don’t Know 2 0.09 

Age=Yng Ad 2
QOL Frequency Percent 
Excellent 1455 29.34 
Very Good 1688 34.04 
Good 1144 23.07 
Fair 275 5.55 
Poor 30 0.60 
Refused 10 0.20 
Not Ascertained 354 7.14 
Don’t Know 3 0.06 

Age=Adult
QOL Frequency Percent 
Excellent 1355 28.11 
Very Good 1579 32.75 
Good 1102 22.86 
Fair 317 6.58 
Poor 51 1.06 
Refused 14 0.29 
Not Ascertained 398 8.26 
Don’t Know 5 0.10 

Age=Mid Aged
QOL Frequency Percent 
Excellent 1254 25.86 
Very Good 1507 31.08 
Good 1131 23.32 
Fair 411 8.48 
Poor 99 2.04 
Refused 27 0.56 
Not Ascertained 412 8.50 
Don’t Know 8 0.16 

Age=Older
QOL Frequency Percent 
Excellent 1079 24.56 
Very Good 1329 30.25 
Good 1089 24.79 
Fair 406 9.24 
Poor 127 2.89 
Refused 15 0.34 
Not Ascertained 343 7.81 
Don’t Know 5 0.11 

Age=Ret. Age
QOL Frequency Percent 
Excellent 1344 23.17 
Very Good 1843 31.77 
Good 1489 25.67 
Fair 490 8.45 
Poor 110 1.90 
Refused 23 0.40 
Not Ascertained 481 8.29 
Don’t Know 21 0.36 

*/
/*
12. Examine the relationship between the QOL and QOMH.  Is there an obvious relationship?*/
proc sort data = hw5.sample;
	by qol qolmh;
run;	

proc freq data = hw5.sample;
	table qol*qolmh/nocum;/*The * symbol shows a table where the observations for the two vars overlap*/
run;

/*
Yes, there is. It seems that there is a strong positive correlation between the two variables. 
*/

/*
13. Examine the relationship between QOL and QOMCH for each gender. */
proc sort data = hw5.sample;
	by sex qol qolmh;/*When breaking down by another variable, it needs to go first.*/
run;	

proc freq data = hw5.sample;
	table qol*qolmh;/*nocum suppresses cumulative frequency and percent for cleaner tables.*/
	by sex;
run;

/*
These frequency tables look very similar. 
*/



