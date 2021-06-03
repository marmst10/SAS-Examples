/*
STAT 8020 - Homework 2
Due 1/27/2020
*/

/*Declaring Library for Homework 2 Files*/
libname hw2 "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3";
run;

/*
1.	Using PROC IMPORT, upload all nine files into SAS.
*/

/* Importing "2014 MLB Injuries 1.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2014 MLB Injuries 1.xlsx"
	out = hw2.mlb141
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2014 MLB Injuries 2.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2014 MLB Injuries 2.xlsx"
	out = hw2.mlb142
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2014 MLB Injuries 3.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2014 MLB Injuries 3.xlsx"
	out = hw2.mlb143
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2015 MLB Injuries 1.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2015 MLB Injuries 1.xlsx"
	out = hw2.mlb151
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2015 MLB Injuries 2.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2015 MLB Injuries 2.xlsx"
	out = hw2.mlb152
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2015 MLB Injuries 3.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2015 MLB Injuries 3.xlsx"
	out = hw2.mlb153
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2016 MLB Injuries 1.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2016 MLB Injuries 1.xlsx"
	out = hw2.mlb161
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2016 MLB Injuries 2.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2016 MLB Injuries 2.xlsx"
	out = hw2.mlb162
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;

/* Importing "2016 MLB Injuries 3.xlsx" */
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 2 and 3\2016 MLB Injuries 3.xlsx"
	out = hw2.mlb163
	DBMS = xlsx
	Replace;
	sheet = "Sheet 1";
run;


/*Checking the contents of each table*/
proc contents data = hw2.mlb141;
proc freq data = hw2.mlb141;
	tables team player position dl_days;
run;
proc compare base=hw2.mlb141
             compare=hw2.mlb143 novalues;
run;
proc compare base=hw2.mlb151
             compare=hw2.mlb153 novalues;
run;
proc compare base=hw2.mlb161
             compare=hw2.mlb163 novalues;
run;


/*
2.	Using PROC SQL, create a new table joining those datasets ending in 1 with those ending in 3, 
but do not include the Weighted_WARP or SI_Pred_Wins columns. Note, the resulting table should 
have 1486 observations. 
*/

/*This code combines all datasets which end in 3 vertically merging all*/
proc sql;
create table hw2.mlb13 as
select Team, Player, Position, DL_Days, Actual_Wins
	from hw2.mlb143
union all
select Team, Player, Position, DL_Days, Actual_Wins
	from hw2.mlb153
union all
select Team, Player, Position, DL_Days, Actual_Wins
	from hw2.mlb163;
quit;

/*
3.	Using PROC SQL, join the table you just created with the datasets ending in 2.
*/

/*This code combines all tables ending in 2 vertically merging all*/
proc sql;
create table hw2.mlb12 as
select *
	from hw2.mlb142
union all
select *
	from hw2.mlb152
union all
select *
	from hw2.mlb162;
quit;

/*This code combines mlb.12 and mlb.13 horizontally, where player position days and 
team are equivalent*/
proc sql;
create table hw2.mlb1 as
select * from hw2.mlb13 as m13 left join hw2.mlb12 as m12
on m13.player=m12.player 
	and m13.position=m12.position
	and m13.dl_days=m12.dl_days
	and m13.team=m12.team;
quit;

/*There are some repeated observations with the same player in the same year,
I am not sure if this is desirable.*/

/*
4.	Using PROC SQL, remove those players for whom the WARP value is missing in a new 
table and calculate the number of games lost for each team (season is 162 games).
*/
proc sql;
create table hw2.mlb as
select * from hw2.mlb1
where warp is not null;
quit;

proc sql;
create table hw2.mlblost as
select distinct team, year, 162-actual_wins as lost from hw2.mlb;
quit;

/*
5.	Using PROC SQL, print a report which contains the average WARP for teams which lost
more than 80 games each year and order that average in descending order.
*/
proc sql;
select distinct team, year, lost from hw2.mlblost
where lost > 80
order by lost desc;
quit;
