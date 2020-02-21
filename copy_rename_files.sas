
/*This is an example of how to copy and rename files in a data step*/

%list_files(&path, csv);

options msglevel=i;

data renameProcess;
set list;

*process to rename;
status_ref1 = filename('fr1', path);

*build filename with dates;
path2 = catt(dir, "/Sample/", name, "_", put(today(), yymmddn8.), ".csv");
status_ref2 = filename('fr2', path2);

*process to copy;
status_copy = fcopy('fr1', 'fr2');

   if status_copy=0 then
      put 'Copied SRC to DEST.';
   else do;
      msg=sysmsg();
      put status_copy= msg=;
   end;

run;
