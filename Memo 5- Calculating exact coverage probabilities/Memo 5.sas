DATA covprob; 
	p = .5; 
	q = 1-p;

	z = abs(probit(.025)); /* z_star for 95\% */ 
	zz = z*z;
	do n = 10 to 50; 
		w = zz / (2 * n) ; 
		rad = sqrt( 2*w*p*q + w*w); 
		rt = (p + w + rad)/(1+2*w); 
		lt = (p + w - rad)/(1+2*w);

		nhat_rt = floor(n * rt); 
		nhat_lt = ceil(n * lt - 1);

		ncurl_rt = floor((n+4)*rt - 2); 
		ncurl_lt = ceil((n+4)*lt - 3);
		/* Calculate left cumulative binomial probs */ 
		p1 = probbnml(p, n, nhat_lt); /* P[S <= lt] */ 
		p2 = probbnml(p, n, nhat_rt); 
		cv_hat = p2 - p1;

		p3 = probbnml(p, n, ncurl_lt); 
		p4 = probbnml(p, n, ncurl_rt); 
		cv_curl = p4 - p3;
			output;
	end;
	keep n cv_hat cv_curl;
run;

PROC plt data = covprob;
		plot cv_hat*n = '^';
		plot cv_curl*n = '~';
run;

proc sgplot data=covprob;
title h=2 ’Figure 2: COVERAGE PROBABILITY’; 
		series X=n Y=cv_hat; 
		refline .95 / 
	axis = y label = "95% confidence line" lineattrs = ( color = red ) ; 
run; 
quit;

proc sgplot data=covprob; 
title h=2 ’Figure 2: COVERAGE PROBABILITY’; 
		series X=n Y=cv_curl; 
		refline .95 / 
	axis = y label = "95% confidence line" lineattrs = ( color = red ) ; 
run;
quit;
