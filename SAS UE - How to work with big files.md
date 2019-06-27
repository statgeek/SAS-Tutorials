# SAS UE - Working with Big Files

## Set up the VM
** No specific instructions on how to do this, because it changes between tools and versions **
1. Shut down the VM
2. Set the # of cores to 2 - this is the limit in SAS UE
3. Set the RAM to as much as you can - remember this is using your computer's RAM so everything else will be slower, especially if you leave the VM rumming
4. Set up another shared folder, either under myfolders or to a location you will remember
5. Start/Restart VM


## Set up a user library

One way to make things faster is to redirect the WORK library. You can do this by creating a user library. The downside to this approach, is you need to remember to remove the files. SAS will keep the files there between sessions until you explicitly delete them.

    libname user '/folders/myshortcuts/path to folder from step 4 above;
    
 
