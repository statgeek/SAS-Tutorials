/*This program is designed to show how you can automate the creation of workbooks in Excel.
The criteria is to create a workbook for every Origin value in the CARS data set and 
in each workbook, create a separate sheet for each make. 
For example, it will create a workbook for Asia, with sheets for all the makes include Kia, Honda, Hyundai, etc. 

Author: F.Khurshed
Date: 2018-04-05
*/


%*Generate sample data to work with here;
proc sort data=sashelp.cars out=cars;
by origin make;
run;

*Close other destinations to improve speed;
ods listing close;
ods html close;

*macro that exports to file with Origin in file name and a 
sheet for each make. The number of origins or makes is not 
needed ahead of time;

%macro export_origin(origin=);

%*filename for export, set style for fun and add label for each sheet;
ods excel file="C:\_localdata\Cars_&origin..xlsx" 
    style = meadow 
    options(sheet_interval='bygroup' 
            sheet_label='Make');

*generate a sheet for each make (by make);
proc print data=cars noobs label;
where origin = "&Origin";
by make;
run;

%*close excel file;
ods excel close;

%mend;

*calls macro for each origin in file. 
number of origins doesn't need to be known ahead of time;

data _null_;
    set cars;
    by origin;

    if first.origin then do;
        *create macro call;
        str = catt('%export_origin(origin=', origin, ');');
        *call macro;
        call execute(str);

    end;

run;

%*reopens output destinations;
ods html;
ods listing;
