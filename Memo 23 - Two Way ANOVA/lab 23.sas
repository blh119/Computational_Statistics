DATA grass1 ;
	infile '/home/u45153057/grass.dat';
	input m $ v y1 - y6;
run;

PROC print data = grass1;
run;

DATA grass;
	set grass1; 
	drop y1-y6;
	y = y1 / 10; output ;
	y = y2 / 10; output ;
	y = y3 / 10; output ;
	y = y4 / 10; output ;
	y = y5 / 10; output ;
	y = y6 / 10; output ;
run;

PROC print data = grass ; 
run;	

PROC means data = grass noprint ; 
	by m v ;
	output out = cellmn mean = ymean ; 
run;

PROC plot data = cellmn ; 
	plot ymean*v = m;
run; 

PROC print data = cellmn;
run;

PROC glm data = grass ; 
	class m v ;
	model y = m m*v ; 
run; 

PROC sort data = grass out = grass2 ; 
	by v ; 
run ; 

PROC glm data = grass2 ; 
	by v ; 
	class m ; 
	model y = m ;
	means m / duncan ; 
run ; 

PROC glm data = grass ; 
	class m v ; 
	model y = m v m*v ; 
	
PROC means data = cellmn mean;
	by m;
run;
	
PROC glm data = grass ; 
	class m v ; 
	model y = m v  m*v; 
	means v / duncan;
	estimate 'B5' intercept 1 m 0 1 0 v 0 0 0 0 1 m*v 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;
	estimate '.5B5 + .5A5' intercept 1 m .5 .5 0 v 0 0 0 0 1 m*v 0 0 0 0 .5 0 0 0 0 .5 0 0 0 0 0;
	estimate '.5B5 + .5A5 - C5' m .5 .5 - 1 m*v 0 0 0 0 .5 0 0 0 0 .5 0 0 0 0 -1/ e;
run;	















