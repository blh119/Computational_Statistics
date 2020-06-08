DATA rats;
infile '/home/u45153057/fosterall.dat' expandtabs;
input wt gl $ gm $;
run;

PROC print data = rats;
run;
quit;

PROC means data = rats;
by gl gm;
output out = wtmean mean = wtmean
run;
quit;

PROC print data = wtmean;
run;
quit;

PROC plot data = wtmean;
	plot wtmean*gl = gm / hpos = 60 vpos = 30 vaxis = 45 to 65 by 5;
run;
quit;

PROC plot data = wtmean;
	plot wtmean*gl = gm / hpos = 60 vpos = 30 vaxis = 45 to 65 by 5;
run;

symbol1 V = CIRCLE COLOR = BLACK I = JOIN; 
symbol2 V = SQUARE COLOR = RED I = JOIN;
symbol11 V = TRIANGLE COLOR = PURPLE I = JOIN;
symbol13 V = PLUS COLOR = GREEN I = JOIN;

PROC gplot data = wtmean;
	plot wtmean*gl = gm;
	title 'Genotype Litter vs Average Litter Weight by Genotype Mother';
run;

PROC glm data = rats ; 
	class gl gm ; 
	model wt = gl gm gl*gm;
	means gl gm / duncan;
	estimate 'gl = a' intercept 1 gl 1 0 0 0 gm .25 .25 .25 .25 gl*gm .25 .25 .25 .25 / e ; 
run;


PROC means data = rats;
by gl ;
output out = wtmeangl mean = wtmean
run;
quit;