# Overview
Symantec's SymDaemon will consume 100% of a MacBook's CPU, run the cooling fan at full blast, drain the battery in a very short time, etc. etc..  If you
don't have any choice about running the Symantec tool, this repo has resources/instructions, assuming you have sudo/root access, to apply some 
reasonable restraints on just how intrusive the Symantec virus scanning tool is allowed to be.

# Instructions
 
Commands in **bold**.

To setting this up:
1. install the cputhrottle command
  * **brew install cputhrottle**
2. enable a script to grab the SymDaemon process-id / pid and run cputhrottle
  * From a clone of this repository...
    * **mkdir -p /Applications/throttlesym.app/Contents/Resources/throttlesym/bin**
    * **cp Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/**
      * Set the owner/group: 
        * **sudo chown -R root:wheel /Applications/throttlesym.app**
      * Set SUID (sticky bit) permissions: 
        * **sudo chmod 4755 /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh**
3. create a "plist" descriptor for the launchd agent
  * From a clone of this git repository...
    * **cp Library/LaunchAgents/org.example.throttlesym.plist ~/Library/LaunchAgents/**
  * *Note: This could be in ~/Library or /Library, depending on whether the agent should be active for one or all users.*
4. modify /etc/sudoers
  * Add this line to the sudoers configuration
    * Run the **sudo visudo** command:
    * Insert the line:
    * **youruserid ALL=(ALL) NOPASSWD: /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh**
      * *...where youruserid is... um... your user id.*
    * *Note: This modifies the /etc/sudoers file, but that should **not** be edited directly.*
5. load the launchd agent
  * **launchctl load -w ~/Library/LaunchAgents/org.example.throttlesym.plist**

# Checking on How It's Working
  * **sudo cat /tmp/throttlesym.out**
  * **sudo cat /tmp/throttlesym.err**
  * **ps -Ax |grep cputhrottle**
  * **ps -Ax |grep throttlesym**

# Stopping the LaunchdAgent
  * **launchctl unload -w ~/Library/LaunchAgents/org.example.throttlesym.plist**

# Modify the Script
  * **sudo vi /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh**

# More Info
* launchd info - https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
* cputhrottle info - http://www.willnolan.com/cputhrottle/cputhrottle.html
* File permissions with SUID bit - http://www.filepermissions.com/file-permission/4755