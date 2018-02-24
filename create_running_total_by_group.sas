*generate sample data;
data baseball;
set sashelp.baseball;
keep  team name salary;
run;

*sort on Grouping variable, for BY statement;
proc sort data=baseball;
by team name;
run;

*add totals;
data want;
set baseball;
by team name; *same as from PROC SORT;
retain total_salary; *keeps values across rows;

if first.team then total_salary = sum(0, salary); *reset for first record;
else total_salary = sum(total_salary, salary); *accumulate;
run;
