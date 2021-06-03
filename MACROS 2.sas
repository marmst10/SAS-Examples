/*
STAT 8020
Quiz 4
Connor Armstrong
*/

/*
Question 1
*/
data table1;
input LOCATION $ SUM;
datalines;
USA 30
EUR 40
;
run;

%let loc=Usa;
proc sql;
select * from table1
where location="&loc"; 
quit;

/*
Question 2
*/
%macro reports;
   %daily
   %if &sysday=Friday %then %weekly;
%mend reports;

/*
Question 5
*/
%macro loop;
%let i=1;
%do %until(&i ge 3);
%put I is &I;
%let i=%eval(&i+1);
%end;
%mend loop;
%loop;

/*
Question 6
*/
%macro one;
%let proc=means;
proc &proc data=sashelp.class;
run;
%mend one;
%one;

%let proc1="mean";
%put _ALL_;

/*
Question 8
*/
options mautosource sasautos="C:\Users\mysasmacros";
%let a=" test";
%put The value of a is %left(&a); 

options mautosource sasautos=”C:/Users/mysasmacros”
%let a=” test”;
%put The value of a is %left(&a); 

/*
Question 9
*/
%macro let(name);
proc print data=&name;
run;
%mend let;
%let(sashelp.class);

/*
Question 10
*/
%let report_title = "Store's BMW Report";
title "&report_title";
proc print data = sashelp.cars;
run;

/*
Question 11
*/
%let idcode=Prod567;

%let code = %substr(&idcode, 5, 3);
%put &code;

/*
Question 13
*/
%macro test;
%if &a=5 %then %do;
proc print data=sashelp.prdsale;
run;
%end;
%else %put a is not 5;
%mend; 

%let a=5;
%test

options symbolgen;

/*
Question 14
*/
proc univariate data=sashelp.cars noprint;
   var MPG_Highway MPG_City;
   output out=percentile1 pctlpts=70 pctlpre=PH PC;
run;

proc print data=percentile1;*70th percentile for highway = 29, city = 21;
run;

%macro q14;
	title "Make and Model of Cars Whose City and Highway MPG are Greater than the 70th Percentile";
	proc print data = sashelp.cars;
	var Make Model;
	where MPG_Highway > 29 and MPG_City > 21;
	run;
	
	data temp;
	set sashelp.cars;
	keep Make Model n;
	retain n Make Model;
	n = _N_;
	if _N_=1 then put "Make and Model of Cars Whose City and Highway MPG are Greater than the 70th Percentile";
	if MPG_Highway > 29 and MPG_City > 21 then put n= make= model=;
	run;
%mend;
%q14;

/*
Question 15
*/
%macro q15;
*Generate list of unique makes;
proc sql;
create table temp1 as
select distinct make, cv(weight) as cv
from sashelp.cars
group by make
having cv(weight) > 1.25;
quit;


%do i=1 %to 37;
data temp2;
set temp1;
if _N_ = &i then
call symput('make', Make);
call symput('cv', cv);
%put &make &cv;
run;
%end;
%mend;
%q15;

