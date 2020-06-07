/* LAB 20.1st */
/* ANOVA 1 :  SMOKING */

%let seed = 123455;
%let nns = 4;
%let nps = 4;
%let nni = 4;
%let nls = 4;
%let nms = 4;
%let nhs = 4;

data smoke1;

do k = 1 to &nns;
  FEF = 3.78 + .79 * rannor(&seed);
  AMT = "NS";
  output;
end;

do k = 1 to &nps;
  FEF = 3.30 + .77 * rannor(&seed);
  AMT = "PS";
  output;
end;

do k = 1 to &nni;
  FEF = 3.32 + .86 * rannor(&seed);
  AMT = "NI";
  output;
end;

do k = 1 to &nls;
  FEF = 3.23 + .78 * rannor(&seed);
  AMT = "LS";
  output;
end;

do k = 1 to &nms;
  FEF = 2.73 + .81 * rannor(&seed);
  AMT = "MS";
  output;
end;

do k = 1 to &nhs;
  FEF = 2.59 + .82 * rannor(&seed);
  AMT = "HS";
  output;
end;

keep fef amt;
run;

PROC means data = smoke1;
class amt;
var fef;
run;

PROC means data = smoke2 order = data;
class amt;
var fef;
run;

PROC means data = smoke3;
class amt;
var fef;
run;

PROC means data = smoke3 order = data;
class amt;
var fef;
run;

PROC print data = smoke3;
run;

PROC plot data = smoke3;
plot fef*amt;
run;

PROC sort data = smoke1 out = ssmo1;
by amt;
run;

PROC print data = ssmo1;
run;

PROC sort data = smoke2 out = ssmo2;
by amt;
run;

PROC print data = ssmo2;
run;

PROC sort data = smoke3 out = ssmo3;
by amt;
run;

PROC univariate data = ssmo1 plot;
var fef;
by amt;
run;

PROC univariate data = ssmo2 plot;
var fef;
by amt;
run;

PROC univariate data = ssmo3 plot;
var fef;
by amt;
run;

PROC glm data = smoke1;
class amt;
model fef = amt;
means amt/lsd; /*lsd performs pirwise t-test or Fishers Least Significant Difference test */
run;

PROC glm data = smoke2;
class amt;
model fef = amt;
means amt/lsd;
run;

PROC glm data = smoke3;
class amt;
model fef = amt;
means amt/lsd;
run;

PROC glm data = smoke3 order = data;
class amt;
model fef = amt;
contrast 'ns vs ps' amt 1 -1 0 0 0 0;
contrast 'ns vs ave inhale' amt 1 0 0 -.1 -.7 -.2;
contrast '# of smo' 0 0 0 -14 -4 18;
estimate 'ns vs ave inh' amt 1 0 0 -.1 -.7 -.2;
estimate 'smo mn' intercept 70 amt 0 0 0 10 20 40/divisor = 70;
estimate 'nonsmo_mn_vs_smo_mn' amt 35 35 0 -10 -20 -40/divisor = 70;
run;
quit;