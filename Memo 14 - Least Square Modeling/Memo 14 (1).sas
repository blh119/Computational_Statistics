data huWi;
infile '/home/u45153057/hus_wif_all (1).dat' expandtabs;
input ha hh wa wh ham ;
run;
proc print data =huWi ;
run;
proc means data = huWi n mean std NMISS N;
var ha wa;
run;

proc corr data = huWi;
var ha wa;
run;

proc corr data = huWi;
var hh wh;
run;

proc reg data = huWi;
model wh = hh;
output out = lin p =plin;
run;

proc sgscatter data= huWi;
plot wh*hh;
run;

PROC reg data = huWi;

MODEL wh = hh; /* fit line, output predicted values yhat in data set lin */
output out = lin p = plin; /* name of column containing predicted yhat */
MODEL wh =  hh ha; /* fit quadratic , output predicted values yhat in data set quad */
output out = quad p = pquad; /* name of column containing predicted yhat */
MODEL wh = hh ha wa; /* fit cubic , output predicted values yhat in data set cub */
output out = cub p = pcub; /* name of column containing predicted yhat */
run;

