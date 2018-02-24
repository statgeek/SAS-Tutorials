/* A commonly asked question is how to get the top X by each group
or the bottom Y for each group. In general, one method is to create
a counter variable that increments and you can then filter based on the
counter. This method does not account for ties, however. If you need to get tied 
observations, you need a different approach. An example would be if there were
multiple records for each day for the stocks. 
To get the top X or bottom N, remember that you can reverse your sort 
(ascending/default to descending) to use the same methodology

Author: F.Khurshed
Date: 2018-02-24
*/

%*sort;
proc sort data=sashelp.stocks out=stocks;
    by stock descending date;
run;

data want;
    set stocks;
    %*set grouping by stock;
    by stock;
    %*
    if first of a group set counter to 1;

    if first.stock then
        counter=1;
    %*increment counter;
    else
        counter+1;
    %*keep only records that are less than 5, ie first 5 records;

    if counter <=5;
run;
