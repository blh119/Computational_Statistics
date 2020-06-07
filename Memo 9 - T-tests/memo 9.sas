DATA headache; 
	INPUT treat $ time @@; 
DATALINES; 
A 40 A 42 A 48 A 35 A 62 A 35 T 35 
T 37 T 42 T 22 T 38 T 29 
; 
run;

PROC ttest data=headache; 
	TITLE "Headache Study"; 
	CLASS treat; 
	VAR time; 
run;

PROC boxplot data=headache; 
	PLOT time*treat; 
run;

PROC npar1way data=headache WILCOXON; 
	TITLE "Nonparametric Comparison"; 
	CLASS treat; VAR time; 
	EXACT WILCOXON; /* use EXACT for exact p-value (not the asymptotic approx. usually computed) when 
		sample size is small */ 
run;

DATA headachepair; 
		INPUT subj Atime Btime; 
	DATALINES; 
	1 20 18 
	2 40 36 
	3 30 30 
	4 45 46 
	5 19 15 
	6 27 22 
	7 32 29 
	8 26 25; 
run;

PROC ttest data=headachepair; 
		TITLE "Paired T-Test on headache relief time"; 
		PAIRED Atime * Btime; 
run;

DATA headpairW; 
		SET headachepair; 
		diff= Atime - Btime; 
run;

PROC univariate data=headpairW; 
		var diff; 
run;
