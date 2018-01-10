#!/bin/sh

cpuThrottlePid=`ps -A |grep -m1 cputhrottle |grep -v grep |awk '{print $1}'`
restartCount=0

while :
do
    # find the SymDaemon process on each loop
    symdPid=`ps -A |grep -m1 SymDaemon |grep -v grep |awk '{print $1}'`

    # Formulate the command to contain the processor power Symantec can monopolize
    # so that it doesn't run the CPU and fans at full blast for hours at a time,
    # making the machine sluggish and nearly unusable at times.  Virus checking is
    # important, but it shouldn't take a front seat to actually being able to use the
    # computer, especially when an actual virus is detected... um... barely ever.
    throttleCommand="/usr/local/Cellar/cputhrottle/1.0.0/bin/cputhrottle ${symdPid} 10"

    # Avoid causing a different problem by preventing a tight restart loop
    sleep 2s

    # Output to confirm that the launchagent is running this as root (since it won't work otherwise.)
    echo "Running as:"
    whoami

    restartCount=$(expr $restartCount + 1)
    echo "cputhrottle has been killed and restarted $restartCount times."
    # Run this in the foreground to block the script until it exits (if it does),
    # and only loop after that.
    eval ${throttleCommand}

    # Update the value of the cputhrottle process (that contains the SymDaemon process).
    cpuThrottlePid=$!

done