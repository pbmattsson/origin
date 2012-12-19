
$colComputers = get-content C:\servers.txt

foreach ($strComputer in $colComputers)

{

START-JOB SERVER-FUNCTION($StrComputer)

}



$Int=1



$JOBLIST=GET-JOB

DO {

$DONE=$TRUE

FOREACH ($JOBTODO in $JOBLIST)

{

IF (($JOBTODO.STATE -eq 'Completed' ) -and ($JOBTODO.HASMOREDATA -eq $TRUE))

{ $X=RECEIVE-JOB $JOBTODO

$INT++

$DONE=$FALSE

#

# Here is where your Excel Code might fit in

#

#

}

} UNTIL ($DONE -eq $TRUE



