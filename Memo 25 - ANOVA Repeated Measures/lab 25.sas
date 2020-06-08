DATA glucose ; 
	infile '/home/u45153057/GLUCOSE.DAT' expandtabs; 
	input id t0 t1 t2 t3 t4 t5 t6 t7 t8 t9; 
	tm=int((_n_ - 1)/6 + 1) ; 
run; 

PROC print data = glucose ; 
run ;

DATA misglu ; 
	set glucose ; 
	if t8 = -1 then t8 = . ;
	if t9 = -1 then t9 = . ; 
run; 

PROC print data = misglu ; 
run ; 

PROC sort data = misglu ; 
	by tm ; 
run ;

PROC means data = misglu ;
	var t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 ; 
	by tm ;
	output out = misglumeans mean = glumean ;
run ;

PROC print data = misglumeans; 
run;

DATA misglu10am ; 
	set misglu (firstobs = 1 obs = 6) ; 
run;

DATA misglu2pm;
	set misglu (firstobs = 7 obs = 12) ; 
run ; 

PROC print data = misglu2pm ;
run ; 

PROC transpose data = misglu2pm out = misglu2pmT(rename =(_Name_ = Time Col1-Col6 = g1-g6)) ; 
run;

PROC print data = misglu2pmT ; 
run ; 

DATA misglu2pmT1 ;
	set misglu2pmT(firstobs= 2 obs = 11);
run;

PROC print data = misglu2pmT1 ;
run ; 

PROC sgplot data = misglu2pmT1 ; 
	title 'Glucose Level After 2pm Meal' ; 
	series x = time y = g1 ; 
	series x = time y = g2 ; 
	series x = time y = g3 ;
	series x = time y = g4 ; 
	series x = time y = g5 ;
	series x = time y = g6 ;
	xaxis label = 'time';
	yaxis label = 'glucose level' ;
run;
	

PROC transpose data = misglu10am out = misglu10amT(rename =(_Name_ = Time Col1-Col6 = g1-g6)) ; 

run;

PROC print data = misglu10amT ; 
run ; 

DATA misglu10amT1 ;
	set misglu10amT(firstobs= 2 obs = 11);
run;

PROC print data = misglu10amt1 ; 
run ; 
 
PROC sgplot data = misglu10amT1 ; 
	title 'Glucose Level After 10am Meal' ; 
	series x = time y = g1 ; 
	series x = time y = g2 ; 
	series x = time y = g3 ;
	series x = time y = g4 ; 
	series x = time y = g5 ;
	series x = time y = g6 ;
	xaxis label = 'time';
	yaxis label = 'glucose level' ;
run;
	
DATA misglumeans ;
	infile '/home/u45153057/glucose means.csv' 
	DELIMITER = ","
    MISSOVER DSD 
    FIRSTOBS=2 ;
    input tm $ t1-t6 ; 
run ; 

PROC print data = misglumeans ;
run ; 
	

PROC glm data = misglu ; 
	class tm ; 
	model t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 = tm; 
run;

PROC glm data = misglu ;
	class tm ; 
	contrast 'gr1 vs gr3' tm 1 0 -1 0 0 0 ;
	estimate 'gr1 and gr3' intercept 50 tm 25 0 25 0 0 0 ;
run ;

	
	
	
	
	
	
	
	
