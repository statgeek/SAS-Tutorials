*Create summary statistics for a dataset by a 'grouping' variable and store it in a dataset;

*Generate sample fake data;
data have;
	input ID          feature1         feature2         feature3;
	cards;
1               7.72               5.43              4.35
1               5.54               2.25              8.22 
1               4.43               6.75              2.22
1               3.22               3.21              7.31
2               6.72               2.86              6.11
2               5.89               4.25              5.25 
2               3.43               7.30              8.21
2               1.22               3.55              6.55

;
run;

*Create summary data;
proc means data=have noprint;
	by id;
	var feature1-feature3;
	output out=want median= var= mean= /autoname;
run;

*Show for display;
proc print data=want;
run;

*First done here:https://communities.sas.com/t5/General-SAS-Programming/Getting-creating-new-summary-variables-longitudinal-data/m-p/347940/highlight/false#M44842;
*Another way to present data is as follows;

proc means data=have stackods nway;
    by id;
    var feature1-feature3;
    ods output summary=want2;
run;

*Show for display;
proc print data=want2;
run;
