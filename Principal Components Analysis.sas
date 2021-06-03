/*
STAT 8230 - Applied Multivariate Analysis
Homework 3
Due 4/9/21
Connor Armstrong
*/

/*
1. PCA for pendigit data. The dataset is from UC Irvine Machine Learning 
Repository at http://archive.ics.uci.edu/ml/datasets/Pen-Based+Recognition+of+
Handwritten+Digits. Read the data set description at the webpage linked above. 
We take a subset of data contained in pendigit3.txt (download this file at the 
course webpage). The data set contains n = 1055 observations of p = 16 
variables, with last column of the dataset, containing '3's, represents that 
the observation is a writing of a digit 3. The 16 variables are equispaced 
locations of pen at 8 timepoints, and are arranged as (x1; y1);(x2; y2); 
: : : ; (x8; y8).
*/

*IMPORTING DATA;
data pendigit3;
	infile "/gpfs/user_home/os_home_dirs/marmst10/pendigit3.txt" 
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=1;
	input X1 Y1 X2 Y2 X3 Y3 X4 Y4 X5 Y5 X6 Y6 X7 Y7 X8 Y8 CLASS;
run;

*TESTING IT IMPORTED CORRECTLY;
proc print data = pendigit3 (obs=10);
run;

/*
(a) Visualize the first observation by plotting x against y.
*/

*Add row number;
data pendigit3;
	set pendigit3;
	obs = _n_;
run;

*add data in 8 times;
data pendigit3_mod;
	set pendigit3 pendigit3 pendigit3 pendigit3 pendigit3 pendigit3 pendigit3 pendigit3;
run;

*sort by obs;
proc sort data = pendigit3_mod;
	by obs;
run;

*add step number, 1-8;
data pendigit3_mod;
	set pendigit3_mod;
	step = mod(_n_-1, 8)+1;
run;

*this part assigns each step to the corresponding x and y;
data pendigit3_mod;
	set pendigit3_mod;
	if step = 1
		then do;
			X = X1;
			Y = Y1;
		end;
	else if step = 2
		then do;
			X = X2;
			Y = Y2;
		end;
	else if step = 3
		then do;
			X = X3;
			Y = Y3;
		end;
	else if step = 4
		then do;
			X = X4;
			Y = Y4;
		end;
	else if step = 5
		then do;
			X = X5;
			Y = Y5;
		end;
	else if step = 6
		then do;
			X = X6;
			Y = Y6;
		end;
	else if step = 7
		then do;
			X = X7;
			Y = Y7;
		end;

	else do;
			X = X8;
			Y = Y8;
		end;
run;

*drop unneeded columns;
data pendigit3_mod;
	set pendigit3_mod;
	drop X1 Y1 X2 Y2 X3 Y3 X4 Y4 X5 Y5 X6 Y6 X7 Y7 X8 Y8 CLASS;
run;

proc print data = pendigit3_mod (obs=10);
run;

proc sgscatter data=pendigit3_mod;
	where obs=1;
	PLOT y * x
	/ datalabel = step;
RUN;

ods graphics/reset attrpriority=none;
title "X and Y Positions for Observation 1";
proc sgplot data = pendigit3_mod noautolegend;
	where obs = 1;
	styleattrs datasymbols = (circlefilled) datacontrastcolors = (blue);
	scatter x = x y = y / group = step datalabel = step datalabelattrs=(size=12pt);
	series x = x y = y /
	markers  markerattrs = (size = 9)  lineattrs = (pattern = solid);
run;
title;

ods graphics/reset attrpriority=none;
title "X and Y Positions for Observation 1";
proc sgplot data = pendigit3_mod noautolegend;
		where obs < 11;
	styleattrs datasymbols = (circlefilled) datacontrastcolors = (blue);
	scatter x = x y = y / group = obs datalabel = step datalabelattrs=(size=12pt);
	series x = x y = y /
	markers  markerattrs = (size = 9)  lineattrs = (pattern = solid);
run;
title;

/*
(b) Perform PCA for this dataset and report the result by 1) scatterplot 
matrix of principal components and 2) scree plot.
*/
proc princomp data = pendigit3 out = pendigit3princomp outstat = pendigit3prinstat;
	var X1 Y1 X2 Y2 X3 Y3 X4 Y4 X5 Y5 X6 Y6 X7 Y7 X8 Y8;
title 'Pendigit3 Data:  Principal Components Analysis';
title;

proc sort data = pendigit3princomp;
	by prin1;
proc print data = pendigit3princomp (obs=10);
run;

proc means data = pendigit3princomp;
run;

*options from swiss bank note example;
goptions reset = (axis, legend, pattern, symbol, title, footnote) norotate
	hpos=0 vpos=0 ctext= target= gaccess= gsfmode=;
axis2 label=(angle=90 'Score on Component 1') order=-6 to 12 by 3;
axis1 label=('Score on Component 2') order=-9 to 9 by 3;
symbol1 value=dot i=none; 
  
proc gplot data=pendigit3princomp;
	plot prin1*prin2=1 / frame haxis=axis1 vaxis=axis2
	href=0 vref=0;
	title 'Pendigit3: Principal Components 1 and 2';
run;

/*
(c) Do the data look as if they are from a MVN distribution?
*/

/*
(d) How many components will you keep? Give a justication.
*/

/*
(e) Walk along each of the first four principal components. Explain the 
percentages of variation captured by each component.
*/
proc print data = pendigit3prinstat (obs=100);
run;

data pendigit3prinscore;
	set pendigit3prinstat;
	IF _NAME_ NOT IN ("Prin1" "Prin2" "Prin3" "Prin4")
		THEN DELETE;
	DROP _TYPE_;
run;

proc print data = pendigit3prinscore;
run;

proc transpose data=pendigit3prinscore
               out=pendigit3printrans;
run;

proc print data=pendigit3printrans noobs;
run;

/*
(f) Now open the data in pendigit8.txt. Combine two datasets into one, 
forming a data matrix with N = 2110 observations. Perform PCA on this 
dataset and report the result by scatterplot matrix of principal components. 
Do you see a nice separation of observations corresponding to the digit 3 
and digit 8?
*/
data pendigit8;
	infile "/gpfs/user_home/os_home_dirs/marmst10/pendigit8.txt" 
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767 
	firstobs=1;
	input X1 Y1 X2 Y2 X3 Y3 X4 Y4 X5 Y5 X6 Y6 X7 Y7 X8 Y8 CLASS;
run;

*TESTING IT IMPORTED CORRECTLY;
proc print data = pendigit3 (obs=10);
run;

data pendigit38;
	set pendigit3 pendigit8;
run;
