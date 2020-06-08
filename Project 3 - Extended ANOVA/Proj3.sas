DATA gastro ; 
	infile '/home/u45153057/gastro.dat' expandtabs; 
	input num treat $ hist resp ;
run ; 

PROC print data = gastro ; 
run ;

PROC sort data = gastro out = sort_gastro ; 
	by treat ;
run ; 

PROC print data = sort_gastro ; 
run ; 

PROC sort data = gastro out = sort_gastro2 ; 
	by hist ; 
run ; 

PROC print data = sort_gastro2 ; 
run; 

PROC means data = sort_gastro ; 
	var resp ;
	by treat ; 
run ;

PROC means data = sort_gastro2 ; 
	var resp ;
	by hist ; 
run ;

PROC sort data = gastro out = sort_gastro3 ; 
	by treat hist ; 
run ; 

PROC print data = sort_gastro3 ; 
run; 
	

PROC univariate data = sort_gastro3 normal plot ; 
	var resp hist ;
run ;

PROC freq data = sort_gastro ; 
	by treat ; 
run ;

PROC sort data = gastro out = sort_gastro4 ; 
	by treat hist ; 
run ; 

PROC print data = sort_gastro4 ; 
run ; 


PROC means data = sort_gastro4 ; 
	var resp ; 
	by treat hist ; 
	output out = gastro_m mean = r_mean ; 
run ; 

PROC print data = gastro_m ; 
run ; 


/* Combine the treatment and history columns to
find the mean by the treatment and history combination */

DATA gastro_m2 ; 
	set gastro_m ; 
	treat_hist = catt(treat, hist) ; 
run ; 

PROC print data = gastro_m2 ; 
run ; 

PROC sgplot data = gastro_m2 ; 
	title 'Response Mean by Treatment-Histroy Combination' ;
	series x = treat_hist y = r_mean ; 
	scatter x = treat_hist y = r_mean ; 
run ; 

PROC glm data = sort_gastro ; 
	class treat ;
	model resp = treat hist treat*hist ; 
	means treat / duncan ; 
	contrast 'hist 0 vs hist 2' hist 1 0 -1 ; 
	contrast 'A0 vs B0' treat 0 0 hist 0 0 0 treat*hist 1 0 0 -1 0 0 ;
	contrast 'A1 vs B1' treat 0 0 hist 0 0 0 treat*hist 0 1 0 0 -1 0 ; 
run ; 
	










