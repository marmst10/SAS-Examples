libname project "C:\Users\conno\OneDrive\Desktop\STAT 7100 - Statistical Methods\Project";
run;

data project.data;
	infile "C:\Users\conno\OneDrive\Desktop\STAT 7100 - Statistical Methods\Project\Meteorite_Landings_altered.csv" 
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=2;
	input name $ id nametype $ recclass $ mass_g fall $ year $ reclat reclong GeoLocation $;
run;	

proc univariate data = project.data;
	histogram id mass_g reclat reclong;
run;

proc freq data = project.data;
	tables Name Nametype recclass fall;
run;	

data project.data;/*format year as numeric date*/
	set project.data;
	date = input(year, mmddyy10.);
run;

data project.data;/*format year as year*/
	set project.data;
	format date year.;
run;

proc univariate data = project.data;
	histogram date;
run;


/*ordered frequency tables for all non-continuous variables*/
proc freq data = project.data ORDER=FREQ;
	tables Name / OUT = project.namefreq;
run;	

proc freq data = project.data ORDER=FREQ;
	tables Nametype / out = project.typefreq;
run;	

proc freq data = project.data ORDER=FREQ;
	tables recclass / out = project.classfreq;
run;	

proc freq data = project.data ORDER=FREQ;
	tables fall / out = project.fallfreq;
run;	

proc sort data = project.data;
	by date;
run;

data project.anova;
	set project.data;
	if recclass in ("L6" "H5" "L5" "H6");
run;

proc ANOVA data=project.anova;
	title One-way ANOVA Comparing the Masses of L6, H5, L5, and H6 Meteorites;
	class recclass;
	model mass_g = recclass;
	means recclass;
run;

proc freq data = project.data;* order=freq;
	tables date;
run;

ods graphics on; 
proc freq data=project.anova;  
	tables mass_g*recclass;* / plots=(freqplot(scale=percent));
run; 
ods graphics off;

proc reg data = project.data;
   model mass_g = date;
run;

proc univariate data = project.data;
	histogram mass_g / exponential (theta = est);
run;

proc sort data = project.data;
	by mass_g;
run;

proc print data = project.data;
	var mass_g;
run;

proc freq data = project.anova;
tables recclass*fall / chisq;
run;



