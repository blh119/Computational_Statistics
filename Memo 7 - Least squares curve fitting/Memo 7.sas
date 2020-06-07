DATA step1;
	do x = 0 to 3 by 0.10;
		y = 5 + 3*x-4*x*x + x*x*x;
		z = rannor(0);
		output;
end;



PROC print data = step1;
run;

DATA step2;
set step1;
a=2;
x1=x;
x2 = x*x;
x3 = x*x*x;
w = y + a*z;
keep x1 x2 x3 w;
run;

PROC print data = step2;
run;

PROC plot data = step2;
plot w*x1;
run;

PROC reg data = step2;
	model w = x1;
	output out = lin p =plin;

	model w = x1 x2;
	output out = quad p = pquad;

	model w = x1 x2 x3;
	output out = cub p = pcub;
run;





PROC gplot data = all;
title1 ’CUBIC CURVE FITTING’;
footnote j=1 ’curve’
j=r ’MAT 4672 Lab 07’;
plot w*x1=1 plin*x1=2
pquad*x1=3 pcub*x1=4 / overlay
frame
haxis = 0 to 3 by 1
vaxis = 2 to 7 by 1
hminor = 3
vminor = 3;
run;
quit;
