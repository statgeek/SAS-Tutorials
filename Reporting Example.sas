*Example of generating automated reports via Macro Loop with names mapped for unique file name mapping;
*create example data;

data cars;
	set sashelp.cars;
run;

proc sort data=sashelp.cars out=cars;
	by make;
run;

*add sequence numbers to mimic your structure;

data cars;
	set cars;
	by make;
	retain SeqNo;

	if first.make then
		seqNo + 1;
run;

*get max of seq for loop;

proc sql noprint;
	select max(seqNo) into :NumObs from cars;
quit;

*create format to map numbers to make;

proc sql;
	create table mapSeq2Make as select distinct seqNo as Start, trim(Make) as 
		Label, 'make_fmt' as fmtName, 'N' as type from cars;
quit;

*create format;

proc format cntlin=mapSeq2Make;
run;

*test mapping;
%put %sysfunc(putn(1, make_fmt));
*macro to create reports;

%macro report_make();
	%do i=1 %to &numObs;
		ods html file="/home/fkhurshed/Demo1/MileageReport_%sysfunc(putn(&i, make_fmt)).html"  /*1*/
		gpath='/home/fkhurshed/Demo1/' style=meadow;
		ods graphics / imagemap=on;
		title "Report on Mileage for %sysfunc(putn(&i, make_fmt))";

		/*2*/
		title2 'Summary Statistics';

		proc means data=sashelp.cars (where=(make="%sysfunc(putn(&i, make_fmt))")) 
				/*3*/
				N Mean Median P5 P95 MAXDEC=2;
			class type;
			ways 0 1;
			var mpg_city mpg_highway;
		run;

		title 'City vs Highway Mileage';

		proc sgplot data=sashelp.cars (where=(make="%sysfunc(putn(&i, make_fmt))")) 
				/*4*/;
			scatter x=mpg_city y=mpg_highway / group=type;
		run;

		ods html close;
	%end;
%mend report_make;

*execute macro;
%report_make();
