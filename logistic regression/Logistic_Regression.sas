PROC import datafile  =  '/home/u45153057/risk.xlsx'
	out  =  risk
	dbms  =  xlsx
	replace ;
 	getnames = yes ; 
run;

PROC print data = risk ; 
run ;

title 'Comparing Proportions' ; 
PROC freq data = risk ; 
	tables Gender * Heart_Attack / chisq ;
run ; 

PROC format ;
	value $ gen 'M' = '1:Male'
				'F' = '2:Female' ; 
	value attack 1 = '1:Yes'
				 0 = '2:No' ; 
run ; 

title 'Reordering the Rows and Columns in 2X2 Table' ; 

PROC freq data = risk order = formatted ; 
	tables Gender * Heart_Attack / chisq relrisk ;
	format Gender $gen. Heart_Attack attack. ; 
run ; 

PROC logistic data = risk ; 
	title 'Logistic Regression with One Categorical Predictor Variable' ; 
	class Gender (param = ref ref = 'F') ; /* causing females to be the reference level */
	model Heart_Attack (event = '1') = Gender / clodds = pl ; 
run ; 

PROC logistic data = risk plots(only) = effect ; 
	model Heart_Attack (event = '1') = Chol / clodds = pl ; 
	units Chol = 10 ; /* odds ratios are calculated per 10 unit increases of Chol */
run ; 

PROC format ; 
	value cholgrp low-200 = 'Low to Medium'
				  201-high = 'High' ; 
run ; 

PROC logistic data = risk ;
	title 'Using a Format to Create a Categorical Variable' ; 
	class Chol (param = ref ref = 'Low to Medium') ; 
	model Heart_Attack (event = '1') = Chol / clodds = pl ; 
	format Chol cholgrp. ; 
run ;

ods graphics on ; 

PROC logistic data = risk ; 
	title 'Using a Combination of Categorical and Continuous Variables' ; 
	class Age_Group (ref = '1:< 60')
			Gender (ref = 'F') / param = ref ; 
	model Heart_Attack (event =  '1') = Gender Age_Group Chol / clodds = pl ; 
	units Chol = 10 ; 
run ; 

ods graphics off ; 

ods graphics on ;

TITLE "Running a Logistic Model with Interactions" ;

PROC logistic data=risk plots(only)=(roc oddsratio);
class Gender (param = ref ref = 'F')
Age_Group (param=ref ref='1:< 60') ;
model Heart_Attack (event= '1') = Gender|Age_Group|Chol @2/selection=backward slstay=.10
clodds=pl ;
units Chol = 10 ;
oddsratio Chol ;
oddsratio Gender ;
oddsratio Age_Group ;
run ;

ods graphics off ;
	















