/*This demonstrates how to count the number of unique occurences of a variable
across groups. It uses the SASHELP.CARS dataset which is available with any SAS installation.
The objective is to determine the number of unique car makers by origin/

Note: The SQL solution can be off if you have a large data set and these are not the only two ways to calculate distinct counts.
If you're dealing with a large data set other methods may be appropriate.*/

*Count distinct IDs;
proc sql;
create table distinct_sql as
select origin, count(distinct make) as n_make
from sashelp.cars
group by origin;
quit;

*Double PROC FREQ;
proc freq data=sashelp.cars noprint;
table origin * make / out=origin_make;
run;

proc freq data=origin_make noprint;
table origin / out= distinct_freq;
run;

title 'PROC FREQ';
proc print data=distinct_freq;
run;
title 'PROC SQL';
proc print data=distinct_sql;
run;
