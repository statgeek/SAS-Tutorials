
# Tutorial - Turning a program into a macro

One of the most asked question on the forum is how to create or convert a piece of code into a macro. Usually the correct answer is not to use a macro and I avoid them as much as possible myself. BY group processing is incredibly powerful and you can usually manipulate the data to avoid mulitple processing. Why do I avoid macro's? Because every read of the data and creating output takes up processing power and takes more time. Macro's typically loop so you are doing a lot of processing. For small data sets usually used in classrooms or while learning, you won't see any significant difference, but as soon as your data starts getting bigger this is more important. Especially if you aren't working on a server. 

This tutorial is not for beginners, you should have some base programming knowledge already. In fact, this is based on the concept that you have a working piece of code first. 

## Problem

PHB has requested you create a report for each Make of car in the SASHELP.CARS data set. The report should include:

1. Average values for mileage, city and highway, by vehicle type (TYPE) via PROC MEANS
2. A scatter plot of MPG_Highway vs MPG_City with the type identified in the plot
3. A title indicating the model covered in the report
4. The files should be named CARS_MAKE, eg CARS_Toyota, CARS_Mercedes

Fortunately for you, you already have a report because PHB asked for this a week ago for Toyota's but now you need to change it to run for all models. 

The program is shown below:


```
ods html file = "/folders/myfolders/MileageReport_Toyota.html" 
         gpath= '/folders/myfolders/' 
         style = meadow;

ods graphics / imagemap=on ;
title 'Report on Mileage for Toyota';
title2 'Summary Statistics';
proc means data=sashelp.cars (where=(make='Toyota')) N Mean Median P5 P95 MAXDEC=2;
class type;
ways 0 1;
var mpg_city mpg_highway;
run;

title 'City vs Highway Mileage';
proc sgplot data=sashelp.cars (where=(make='Toyota'));
scatter x=mpg_city y=mpg_highway / group = type;
run;
```

# Step 1
The next step is to find identify all locations where we ues the MAKE and need to change it. Examining the code we can find 4 places where the Make is used. 
1. ODS HTML Statement - used to control file name
2. TITLE statement - used to display the title in the report
3. PROC MEANS WHERE data set option - filters the data for PROC MEANS
4. PROC SGPLOT WHERE data set option - filters the data for PROC SGPLOT


```sas
ods html file = "/folders/myfolders/MileageReport_Toyota.html"  /*1*/
         gpath= '/folders/myfolders/' 
         style = meadow;

ods graphics / imagemap=on ;
title 'Report on Mileage for Toyota'; /*2*/
title2 'Summary Statistics';
proc means data=sashelp.cars (where=(make='Toyota')) /*3*/ N Mean Median P5 P95 MAXDEC=2;
class type;
ways 0 1;
var mpg_city mpg_highway;
run;

title 'City vs Highway Mileage';
proc sgplot data=sashelp.cars (where=(make='Toyota')) /*4*/;
scatter x=mpg_city y=mpg_highway / group = type;
run;

ods html close;

```

# Step 2 - Macro Variables

We start by creating a macro variable and replacing all instances of make, with the macro variable. 
In addition, we need to switch all quotation marks from single to double quotes. Macro variables do not resolve in single quotes.


```sas
%let r_make=Toyota;

ods html file = "/folders/myfolders/MileageReport_&r_make..html"  /*1*/
         gpath= '/folders/myfolders/' 
         style = meadow;

ods graphics / imagemap=on ;
title "Report on Mileage for &r_make."; /*2*/
title2 'Summary Statistics';
proc means data=sashelp.cars (where=(make="&r_make.")) /*3*/ N Mean Median P5 P95 MAXDEC=2;
class type;
ways 0 1;
var mpg_city mpg_highway;
run;

title 'City vs Highway Mileage';
proc sgplot data=sashelp.cars (where=(make="&r_make.")) /*4*/;
scatter x=mpg_city y=mpg_highway / group = type;
run;

ods html close;
```

# Step 3 - Convert to a macro

The next step is to convert this to a macro by sandwiching the code between %macro and %mend. 

A key thing is to test it after each step. Note the macro call at the end of the program. 


```sas

%let r_make=Toyota;

%macro report_make;
ods html file = "/folders/myfolders/MileageReport_&r_make..html"  /*1*/
         gpath= '/folders/myfolders/' 
         style = meadow;

ods graphics / imagemap=on ;
title "Report on Mileage for &r_make."; /*2*/
title2 'Summary Statistics';
proc means data=sashelp.cars (where=(make="&r_make.")) /*3*/ N Mean Median P5 P95 MAXDEC=2;
class type;
ways 0 1;
var mpg_city mpg_highway;
run;

title 'City vs Highway Mileage';
proc sgplot data=sashelp.cars (where=(make="&r_make.")) /*4*/;
scatter x=mpg_city y=mpg_highway / group = type;
run;

ods html close;

%mend report_make;

%report_make;

```

# Step 4 - Add parameters

In this step, we remove the %LET statement that created the macro variables previously and we replace it with a parameter in the %MACRO statement. 


```sas
%macro report_make(r_make=);
ods html file = "/folders/myfolders/MileageReport_&r_make..html"  /*1*/
         gpath= '/folders/myfolders/' 
         style = meadow;

ods graphics / imagemap=on ;
title "Report on Mileage for &r_make."; /*2*/
title2 'Summary Statistics';
proc means data=sashelp.cars (where=(make="&r_make.")) /*3*/ N Mean Median P5 P95 MAXDEC=2;
class type;
ways 0 1;
var mpg_city mpg_highway;
run;

title 'City vs Highway Mileage';
proc sgplot data=sashelp.cars (where=(make="&r_make.")) /*4*/;
scatter x=mpg_city y=mpg_highway / group = type;
run;

ods html close;

%mend report_make;

*execute macro;
%report_make(r_make = Toyota);
```

# Step 5 - Get list of all makes

The macro is now available so the final step is to run all reports. Because this is a demo I limit it to 5 runs. The first step is to get a list of all makes.


```sas
*get list of all makes;
proc sql;
create table car_makes as 
select distinct make 
from sashelp.cars;
quit;

```

# Step 6 - Run macro for all makes in list

To do this, I prefer CALL EXECUTE. For CALL EXECUTE, it will run the command passed to it. So I create a string that looks like my macro call, pass it to CALL EXECUTE, which runs the program. 

1. Make a string that looks like:
     %report_make(r_make = [insert make variable]);
2. Pass the string to CALL EXECUTE. 

Other options:
* Macro list of makes and a macro loop
* DOSUBL
* Manual list of macros via copy/paste


```sas
data macro_call;
set car_makes (obs=5); *run only 5 for testing;

*build macro call string;
str = catt('%report_make(r_make =', make, ');'); 

*call macro;
call execute(str);

run;
```
