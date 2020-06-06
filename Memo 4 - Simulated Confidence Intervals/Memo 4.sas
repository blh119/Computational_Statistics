DATA samples;
	seed = 1234875;
	nr = 10; nc = 8;						/*WHEN WORKS, SET nr = 10000*/
	array x[20];							/*USE 20 TO ALLOW nc<= 20*/
	tstar = abs( tinv(.025, nc-1) );		/*95% CONF FACTOR FROM T TABLE*/
	mpop = 0 ;								/*= 1 if EXP’L, = 0 if NORM&CAUCHY*/
	do r = 1 to nr;
		do c = 1 to nc;x[c] = rancau(seed);	/*USE RANCAU, RANEXP&RANNOR*/
			mn = mean(of x[*]);				/*GET SAMPLE MEAN AND STD*/
			s2 = var(of x[*]);
			t = (mn - mpop)/ sqrt( s2 / nc );/*GET T-STT*/
			if abs(t)<= tstar then cv = 1;else cv = 0;
		end;
		output;
	end;
	keep x1-x8 mn s2 t cv tstar;
run;

PROC print data = samples;
run;

PROC means data = samples n mean stderr;
	var cv;
run;

PROC gchart data = samples;
	vbar t;
run;

DATA propns;
	seed = 123475;
	nr = 10; nc = 12;						/*WHEN WORKS, SET nr = 10000, nc = 12, 17, 18*/
	array x[20];							/*USE 20 TO ALLOW nc<= 20*/
	zstar = abs( probit(.025) );			/*95% CONF FACTOR FROM Z TABLE*/
	ppop = .5 ;								/*POPULATION PROPORTION*/
	do r = 1 to nr;
		do c = 1 to nc;
			x[c] = ranbin(seed, 1, ppop);
			nh = sum(of x[*]);				/*GET number of heads*/
			phat = nh / nc;					/*ordinary sample proportion and std error*/
			se_phat = sqrt( phat*(1-phat) / nc );
			pcurl = (nh + 2)/(nc + 4);		/*’add 2’ sample proportion and std error*/
			se_pcurl = sqrt( pcurl*(1-pcurl) / (nc + 4) );
			zhat = (phat - ppop)/se_phat;	/*z_stt’s*/
			zcurl = (pcurl - ppop)/se_pcurl;
			if abs(zhat)<= zstar then cv_hat = 1;
				else cv_hat = 0;
			if abs(zcurl)<= zstar then cv_curl = 1;
				else cv_curl = 0;
		end;
		output;
	end;
	keep phat se_phat pcurl se_pcurl zhat zcurl cv_hat cv_curl;
run;

PROC print data = propns;
run;

PROC means data = propns n mean stderr;
	var cv_hat cv_curl;
run;

PROC gchart data = propns;
	vbar zhat zcurl;
run;
