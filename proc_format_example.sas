/*this is an example of creating a custom format and then applying it to a data set*/

*create the format;
proc format;
value age_group
low - 13 = 'Pre-Teen'
13 - 15 = 'Teen'
16 - high = 'Adult';
run;

title 'Example of an applied format';
proc print data=sashelp.class;
format age age_group.; *applies the format;
run;


data class;
set sashelp.class;
age_category = put(age, age_group.); *creates a character variable with the age category;
label age_category = 'Age Category'; *adds a nice label for the printed output;
run;

title 'Example of creating a new variable with the format';
proc print data=class label;
run;
