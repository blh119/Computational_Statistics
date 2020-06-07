title "The Date is &sysdate9 and the Time is &systime";
%let n = 3;
DATA generate;
		do Subj = 1 to &n;
			x = int(100*ranuni(0) + 1);
			output;
	end;
run;

title "Data Set with &n Random Numbers on &sysdate9 at &systime";
PROC print data=generate noobs;
run;

%macro gen(n,Start,End);
		data generate;
			do Subj = 1 to &n;
				x = int((&End - &Start + 1)*ranuni(0) + &Start);
				output;
	end;
run;
PROC print data=generate noobs;
		title "Randomly Generated Data Set with &n Obs";
		title2 "Values are integers from &Start to &End";
	run;
%mend gen;
%gen(4,1,100)
