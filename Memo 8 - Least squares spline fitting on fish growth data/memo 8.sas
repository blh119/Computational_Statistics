DATA fish;
		infile 'E:\Memos\fish29.dat' ;
		input age length;
run;

PROC plot data = fish;
		plot length * age = 'o';
run;

DATA fishx; set fish;
		a2 = age*age;
		a3 = age*a2;
		aspl = max( age - 80, 0 ); /* this allows a linear change after 80 */
		aspl2 = aspl**2; /* this allows quadratic change after 80 */
run;

PROC reg data = fishx;
		model length = age; /* linear */
		output out=l p=pl;
		model length = age a2; /* quadratic */
		output out=q p=pq;
		model length = age a2 a3; /* cubic */
		output out=c p=pc;
		model length = age aspl; /* one spline */
		output out=s1 p=ps1;
		model length = age aspl aspl2; /* two spline */
		output out=s2 p=ps2;
run;

DATA all;
		merge l q c s1 s2;
run;

goptions reset = global 
gunit = pct border

	ftext = swissb 
	htitle = 4 
	htext = 3

	hsize = 8 in 
	vsize = 5 in
	cback = white;

	symbol1 v = dot h=2 c = orange;
	symbol2 v = circle h=2 i= join c=red;
	symbol3 v = square h=2 i = spline c = green;
	symbol4 v = triangle h=2 i = spline c = blue;

run;


PROC gplot data = all;

title1 'LINEAR VS QUADRATIC';
footnote 	j=1 'curve'
			j=r 'MAT 4672 Lab 08';

plot 	length*age = 1 
		pl*age= 2 
		pq*age=3 / overlay frame;

run;
quit;


goptions reset = global 
gunit = pct border

	ftext = swissb 
	htitle = 4 
	htext = 3

	hsize = 8 in 
	vsize = 5 in
	cback = white;

	symbol1 v = dot h=2 c = orange;
	symbol2 v = circle h=2 i= join c=red;
	symbol3 v = square h=2 i = spline c = green;
	symbol4 v = triangle h=2 i = spline c = blue;
	symbol5 v = rectangle h=2 i = spline c = yellow;

run;

PROC gplot data = all;

title1 'CUBIC VS SPLINE 1 VS SPLINE2';
footnote 	j=1 'curve'
			j=r 'MAT 4672 Lab 08';

plot 	length*age = 1 
		pc*age= 2 
		ps1*age=3 
		ps2*age = 4/ overlay frame;

run;
quit;
