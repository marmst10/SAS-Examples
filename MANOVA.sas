/* 
STAT 8230 Applied Multivariate Data Analysis
Homework 2.3
Connor Armstrong

3. Baten, Tack, and Baeder (1958) compared judge's scores on  fish prepared by three methods. 
Twelve  fish were cooked by each method, and several judges tasted the  fish samples and rated 
each on four variables: y1 = aroma, y2 = flavor, y3 = texture, and y4 = moisture. The raw data 
is in the separate file. Each entry is an average score for the judges on that  fish. You can 
use PROC GLM and/or IML for this problem.

(a) Compare the three methods using MANOVA.
*/
data fish;
 input method y1 y2 y3 y4;
 label method ='Cooking Method'
       y1 ='Aroma'
       y2 ='Flavor'
       y3 ='Texture'
       y4 ='Flavor';
datalines;
1 5.4 6 6.3 6.7
1 5.2 6.5 6 5.8
1 6.1 5.9 6 7
1 4.8 5 4.9 5
1 5 5.7 5 6.5
1 5.7 6.1 6 6.6
1 6 6 5.8 6
1 4 5 4 5
1 5.7 5.4 4.9 5
1 5.6 5.2 5.4 5.8
1 5.8 6.1 5.2 6.4
1 5.3 5.9 5.8 6
2 5 5.3 5.3 6.5
2 4.8 4.9 4.2 5.6
2 3.9 4 4.4 5
2 4 5.1 4.8 5.8
2 5.6 5.4 5.1 6.2
2 6 5.5 5.7 6
2 5.2 4.8 5.4 6
2 5.3 5.1 5.8 6.4
2 5.9 6.1 5.7 6
2 6.1 6 6.1 6.2
2 6.2 5.7 5.9 6
2 5.1 4.9 5.3 4.8
3 4.8 5 6.5 7
3 5.4 5 6 6.4
3 4.9 5.1 5.9 6.5
3 5.7 5.2 6.4 6.4
3 4.2 4.6 5.3 6.3
3 6 5.3 5.8 6.4
3 5.1 5.2 6.2 6.5
3 4.8 4.6 5.7 5.7
3 5.3 5.4 6.8 6.6
3 4.6 4.4 5.7 5.6
3 4.5 4 5 5.9
3 4.4 4.2 5.6 5.5
;
proc sort; by method; 
proc means n mean;
 class method;
 var y1 y2 y3 y4;
run;


*shorthand example code;
proc glm;
 class method ;
 model y1 y2 y3 y4 = method ;
 contrast '1 vs 2' method 1 -1 0;
 contrast '2 vs 3' method 0 1 -1;
 contrast '1 vs 3' method 1 0 -1;
 manova h=method / printe printh;
 lsmeans method;
 title '1-way MANOVA Fish data';
run;

*anova f tests for each yi;
proc anova data = fish;
class method;
model y1 = method;
means method / tukey;
run;

proc anova data = fish;
class method;
model y2 = method;
means method / tukey;
run;

proc anova data = fish;
class method;
model y3 = method;
means method / tukey;
run;

proc anova data = fish;
class method;
model y4 = method;
means method / tukey;
run;

