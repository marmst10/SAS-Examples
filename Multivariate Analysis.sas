/* 
STAT 8230 Applied Multivariate Data Analysis
Homework 2.1
Connor Armstrong

1. A number of patients with bronchus cancer were treated with ascorbate and
compared with matched control patients who received no ascorbate (Cameron &
Pauling, 1978). The data are given below. The variables measured were
y1 = patient: survival time (days) from date of first hospital admission.
x1 = matched control: survival time (days) from date of first hospital admission.
y2 = patient: survival time from date of untreatability.
x2 = matched control: survival time from date of untreatability.
(a) Compare y1 and y2 with x1 and x2, respectively, using a paired comparison
T^2{test with alpha = .05. (Be sure to state your null hypothesis).
*/
options nocenter;
data vitC;
 input type $ case gender $ age y1 x1 y2 x2 alive;
 d1 = y1-x1;
 d2 = y2-x2;
label type='Type of Cancer'
       y1='patient 1st hospitialization'
       x1='control 1st hospitialization'
	   y2='patient survival from untreatability'
	   x2='control survival from untreatability'
	   d1='difference 1st hosptialization'
	   d2='difference untreatability'
	   alive='Alive at end of study'
	   ;
 datalines;
bronchus 13 m 74  81  72  74  33 0
bronchus 14 m 74 461 134 423  18 0
bronchus 15 m 66  20  84  16  20 0
bronchus 16 m 52 450  98 450  58 0
bronchus 17 f 48 246  48  87  13 0
bronchus 18 f 64 166 142 115  49 0
bronchus 19 m 70  63 113  50  38 0
bronchus 20 m 77 64   90  50  24 0
bronchus 21 n 71 155  30 113  18 0
bronchus 22 m 70 859  56 857  18 1
bronchus 23 m 39 151 260  38  34 0
bronchus 24 m 70 166 116 156  20 0
bronchus 25 m 70  37  87  27  27 0
bronchus 91 m 55 223  69 218  32 0
bronchus 93 m 74 138 100 138  27 0
bronchus 97 m 69  72 315  39  39 0
bronchus 98 m 73 245 188 231  65 0
;



proc means mean var;
 var y1 x1 y2 x2;
 title 'Check whether mean=variance';
run;

proc iml;
start samplestats(X,Xbar,W,S,R,n);
  n = nrow(X);
  one = J(n,1);
  Xbar = X`*one/n;
  W =  (X - one*Xbar`)` * (X - one*Xbar`);
  S = W/(n-1);
  Dsqrt = sqrt(diag(S));
  R = inv(Dsqrt)*S*inv(Dsqrt);
Finish samplestats;
            
use vitC;
read all var{x1 x2} into X3;
read all var{y1 y2} into Y3;

/* Compute differences */

d = X3-Y3;
run samplestats(d,dbar,Wd,Sd,Rd,nd);

T2 = nd*dbar`*inv(Sd)*dbar;

p= ncol(X3);
dfden=nd-p;

Fcrit =  quantile('F',.95, p,dfden) ;       *Get 95% percentile of F-distribution;
Fcrit = (nd-1)*p/(nd-p) * Fcrit;            *This multiple of 95% percentile of F-distribution
                                             is what T2 should be compared to;

F = (nd-p)/((nd-1)*p)*T2;                   *This multiple of T2 has an F-distribution;

pvalue = 1- cdf('F',F,p,dfden);             *Get p-value from F-distribution;

print 'Results for the paired Comparison data on vitC', ,
      'Sample Size =                     ' nd, ,
      'Sample means =                    ' dbar, ,
      'Sample Covariance =               ' Sd, ,
      'Hotellings T^2 =                  ' T2, ,
      '(nd-1)*p/(nd-p) * F_p,n-p(.05) =  ' Fcrit, ,
      '(nd-p)/((nd-1)*p) T^2 =           ' F,  ,
      'p-value for (nd-p)/((nd-1)*p) T^2=' pvalue ,;
      
      discrim = inv(Sd)*dbar;
print discrim;
/**************** Confidence Region ***********************/
call eigen(lambda,U,Sd);
print lambda U;
major1 = dbar + sqrt(lambda[1,1])*sqrt(Fcrit/nd)*U[,1];
major2 = dbar - sqrt(lambda[1,1])*sqrt(Fcrit/nd)*U[,1];
minor1 = dbar + sqrt(lambda[2,1])*sqrt(Fcrit/nd)*U[,2];
minor2 = dbar - sqrt(lambda[2,1])*sqrt(Fcrit/nd)*U[,2];
print 'Points of Confidence Region:' major1 major2 minor1 minor2;

/************ This is for me *******************************
  I needed this extra information as input to bezierellipse.java, 
  which creates LaTex code for the ellipse that is in the lecture 
  notes.  
************************************************************/
half_Lmajor =sqrt( (major1-major2)`*(major1-major2))/2;
half_Lminor =sqrt( (minor1-minor2)`*(minor1-minor2))/2;

x={1, 0 };
y = major1-dbar;
costheta = y`*x/(sqrt(y`*y)*sqrt(x`*x));
radian = arcos(costheta);
pi = constant('pi');
degrees = (180/pi)*radian;
print half_Lmajor half_Lminor degrees;

/*************** Simultaneous component T2 intervals *********/
d_lower = dbar - sqrt( Fcrit*vecdiag(Sd/nd) );
d_upper = dbar + sqrt( Fcrit*vecdiag(Sd/nd) );
print 'Simultaneous T2 Intervals:        '    d_lower d_upper;

/*************** Bonferroni intervals*********************/
alpha_2m = 1-.05/(2*2);
df = nd -1;
tstat = quantile('t',alpha_2m,df);
db_lower = dbar - tstat* sqrt(vecdiag(Sd/nd));
db_upper = dbar + tstat* sqrt(vecdiag(Sd/nd));
print 'Bonferroni Intervals:        '    db_lower db_upper;

/*PLOT
proc sgscatter data=vitC;
  compare y= d1  x= d2 / ellipse=(type=mean)  ;
  title '95% Condifence Region for the mean Difference';
run;
*/

********** Input & basic computation ************;
* F (alpha=.05) with 2 and 15 (n-2) degrees of freedom;
Falpha=3.68;
* t (alha=.05/2) with 16 (n-1) degrees of freedom;
talpha=2.12;

* one at a time intervals;
Sii = vecdiag(S);
print Sii;
lower= xbar-talpha*sqrt(Sii/n);
upper= xbar+talpha*sqrt(Sii/n);
print lower upper;

* Simultaneous Tsq intervals;
Csq = (n-1)*p*Falpha/(n-p);
lower= xbar-sqrt(Csq*Sii/n);
upper= xbar+sqrt(Csq*Sii/n);
print lower upper;