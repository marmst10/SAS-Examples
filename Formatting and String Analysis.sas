/*
Homework 7
1.	Download and the run the code homework_problem1.sas (see code below). It creates a dataset
with three observations and three variables (line1, line2, and line3). 
*/
DATA address;
    INPUT #1 @1 line1 $50.
	      #2 @1 line2 $50.
		  #3 @1 line3 $50.;
DATALINES;
Mr.  Jason    Simmons
123  Sesame  Street
Madison, WI
Dr.    Justin  Case
78    River  Road
Flemington, NJ
Ms. Marilyn  Crow
777 Jewell   Avenue
Pittsburgh,    PA
;
RUN;

libname hw7 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 7";
run;

*Dr Tasoobshirazi, please excuse my notes. #2 is a fair bit down.
*MODIFYING CHARACTER VARIABLES BEGINS ON SLIDE 100 OF LECTURE 9 SLIDES

SCAN	RETURNS A SPECIFIC WORD FROM A CHARACTER VALUE
	SCAN(ARGUMENT, n, "delimiters IE ,")
	EX:	data company;*
		set company;*
			Length Lastname Firstname Middlename $10.;*Be sure to set length to save space
			Lastname = scan(name, 1, ",");*
			Firstname = scan(name, 2);*Note that blank and comma are default delimiters, so you can write the function without listing delimiters.
			Middlename = scan(name, 3);*
		run;*

SUBSTR EXTRACTS A SUBSTRING OR REPLACES CHARACTER VALUES - STARTING AT A SPECIFIED LOCATION
	SUBSTR(ARGUMENT, POSITION, NUMBER OF CHARACTERS TO EXTRACT-> DEFAULT REST)
	EX:	data company;*
		set company;*
			Length MIDDLEINITIAL $10.;*Be sure to set length to save space
			MIDDLEINITIAL = SUBSTR(MIDDLENAME, 1);*
		run;*
	CAN ALSO BE USED TO REPLACE SECTIONS OF TEXT
	IE: NEED TO REPLACE ID #S THAT START WITH F WITH AN A
		data company;*
		set company;*
			substr(ID,1,1) = "A";*
		run;*

TRIM TRIMS TRAILING BLANKS FROM CHARACTER VALUES
	GENERAL FORM: TRIM(ARGUMENT)
	EX: CREATING A STREET ADDRESS STRING FROM STREET/CITY/ZIP

	W/O TRIM
	data address;*
		set sasuser.temp;*
		newaddress = address||","||city||","||zip;*
	run;*
	proc print data = address (keep=newaddress);*
	run;* this new variable has tons of blank spaces in it

	W/TRIM
	data address;*
		set sasuser.temp;*
		newaddress = trim(address)||","||trim(city)||","||trim(zip);*
	run;*
	proc print data = address (keep=newaddress);*


CATX CONCATENATES CHARACTER STRINGS, REMOVES LEADING & TRAILING BLANKS, & INSERTS SEPRATORS
	catx(seperator, string1, string2 etc);*
	EX:
	data address;*
		set sasuser.temp;*
		newaddress = CATX(",",address,city,,zip);*
	run;*
	proc print data = address(keep = newaddress);*
	run;*


INDEX SEARCHES A CHARACTER EXP FOR A STRNG OF CHARS, & RETURNS THE POSITION OF THE 1ST CHAR
	index(source, "exerpt") -> source spec the ch var or exp, exc spec the string
	EX: Return all people who can do word processing.
	data wordprocessors;*
		set sasuser.temp;*
		if index(job, "Word Processing") >0;*any case, not case sensitive
	run;*

	proc print data = wordprocessors (keep = job);*
	run;*


FIND SEARCHES FOR A SPECIFIC SUBSTRING OF CHARACTERS WITHIN A CHARACTER STRING
	optional form
	find(string, substring <,modifiers><,startpos>)
		startpos - default is 1.
		modifiers - i causes find to ignore character case.
					t removes trailing blanks from the string and substring.

	EX: 
	data wordprocessors;*
		set sasuser.temp;*
		if index(job, "Word Processing","i t") >0;*any case, not case sensitive
	run;*

	proc print data = wordprocessors (keep = job);*
	run;*	


UPCASE CONVERTS ALL VALUES TO UPPERCASE
lowcase converts all values to lowercase
Propcase Converts All Letters To Proper Case

TRANWRD REPLACES OR REMOVES ALL OCCURENCES OF A PATTERN OF CHARACTERS WITHIN A CHARACTER STR
	tranwrd(source,target,replacement)
	ex:
	data after;*
		set before;*
		length name1 name2 $40.;*
		name1=tranwrd(name, "Miss", "Ms.");*
		name2=tranwrd(name, "Mrs.", "Ms.");*
	run;*

;
/*
2.	Create a new variable called name that contains the last and first name only. The names 
should be separated by a comma.
*/
data hw7.address1;
	set address;
	Length name $20.;*Be sure to set length to save space;
	name = scan(line1, 3)||", "||scan(line1, 2);*Put last before first, as is convention with comma;
run;

/*
3.	Create a new variable called street which contains the street name in upper case. Replace
Road, Street, or Avenue with Rd., St., and Ave. 

I FOUND THIS CODE ON THE SAS WEBSITE FOR REPLACING MULTIPLE THINGS IN ONE VARIABLE
data want;
   set have;
   n_name = o_name;
   length word $27 ;
   do word='JR', 'SR', 'III', 'IV', 'DECD' ;
      n_name = tranwrd(' '||n_name, ' '||strip(word)||' ', ' ');
  end;
   n_name = compbl(n_name);
   drop word ;
run;
*/
data hw7.address2;
	set hw7.address1;
	length street streettemp $40;
	streettemp = tranwrd(line2, "Street", "ST.");
	streettemp = tranwrd(streettemp, "Road", "RD.");
	streettemp = tranwrd(streettemp, "Avenue","AVE.");
	street = upcase(scan(streettemp, 2)||" "||scan(streettemp, 3)||".");*LOST THE PERIOD FOR SOME REASON;
	drop streettemp;
run;

/*
4.	Create a new variable called city that contains only the city name.
*/
data hw7.address3;
	set hw7.address2;
	length city $20.;
	city = scan(line3, 1);
run;

/*
5.	Create a new variable called state that contains only the state abbreviation.  
*/
data hw7.address4;
	set hw7.address3;
	length state $2.;
	state = scan(line3, 2);
run;


/*
6.	Run the SAS code called homework_problem2.sas (see code below). 
*/
DATA string;
    input string $10.;
DATALINES;
123nj76543
892NY10203
876pA83745
;
RUN;

/*
7.	Create the following variables.
•	x: a numeric variable containing the first two digits of the string
•	y: a numeric variable containing the third digit of the string
•	state: a character variable containing the fourth and fifth characters as uppercase 
	letters
•	n1: a numeric variable containing the sixth digit of the string
•	n2: a numeric variable containing the seventh digit of the string
•	n3: a numeric variable containing the eighth digit of the string
•	n4: a numeric variable containing the ninth digit of the string
•	n5: a numeric variable containing the tenth digit of the string
*/
data hw7.string1;
	set string;
	*length x $2. y $3. state $2. n1 n2 n3 n4 n5 $1.;
	charx = substr(string, 1, 2);
	chary = substr(string, 3, 1);
	state = upcase(substr(string, 4, 2));
	charn1 = substr(string, 6, 1);
	charn2 = substr(string, 7, 1);
	charn3 = substr(string, 8, 1);
	charn4 = substr(string, 9, 1);
	charn5 = substr(string, 10, 1);
	*need to convert x, y, n1, n2, n3, n4, and n5 to numeric;
	x = input(charx, 10.);
	y = input(chary, 10.);
	n1 = input(charn1, 10.);
	n2 = input(charn2, 10.);
	n3 = input(charn3, 10.);
	n4 = input(charn4, 10.);
	n5 = input(charn5, 10.);
	drop charx chary charn1 charn2 charn3 charn4 charn5;
run;

/*
ENSURE THAT X Y N1 N2 N3 N4 N5 ARE NUMERIC
*/
proc contents data = hw7.string1;
run;

/*
8.	Print out the results.
*/
proc print data = hw7.string1;
run;




