/********************************
STAT 7020 - HOMEWORK 6
DUE 11/5/2019
********************************/

libname hw6 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 6";
run;

/*
1.	How many times does the following ‘Do Loop’ iterate?
*/
data hw6.test;
		do i = 1 to 14;
			capital + 5000;
			capital + capital*0.10;
		end;
run;
*14 full times. When 'i' turns to 15 the process stops before the 15th iteration is 
complete.;


/*
2.	How many variables are in the dataset test created above?
*/
*2 variables: 'i' and 'capital'

/*
3.	How many observations?
*/
*1 observation, the result observation.;

/*
4.	Modify the code in question so it outputs results after each iteration. 
*/
data hw6.test2;
		do i = 1 to 14;
			capital + 5000;
			capital + capital*0.10;
			output;
		end;
run;

/*
5.	How many observations are in the dataset test now?
*/
*14 Observations, 1 for each valid value for 'i';

/*
6.	Modify the code in problem 1 so it calculates the interest earned monthly but only 
adds the new capital ($5,000) annually. Adjust your code so that you include a variable 
called year that starts in 2011. 
*/
data hw6.test3;
	do year = 2011 to 2024;*year - index;
		capital + 5000;*capital - accumulator adds 2000 every year;
			do month = 1 to 12;*month - index;
				interest = capital*(0.10/12);
				capital+interest;
			end;
	end;
run;

/*
Let’s say that you plan to take your salary and put it in a CD, stock market, or some 
other type of investment. Write a code that allows you to determine how much money you 
will have in five years depending on: (1) your initial investment, (2) your monthly or 
annual contribution, and (3) your interest rate.

(1) Initial investment: $1000.00
(2) Annual contribution: $1000.00
(3) Interest rate: 0.035% annually
*/
data hw6.test4;
	capital=1000;
	do year = 2020 to 2024;*years: 2020 2021 2022 2023 2024;
		capital + 1000;*accumulator adds 1000 every year including the first;
			do month = 1 to 12;*month - index;
				interest = capital*(0.035/12);
				capital+interest;
			end;
	end;
run;
