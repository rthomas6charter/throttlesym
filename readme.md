Symantec's SymDaemon will consume 100% of a MacBook's CPU, run the cooling fan at full blast, drain the battery in a very short time, etc. etc..  If you
don't have any choice about running the Symantec tool, this repo has resources/instructions, assuming you have sudo/root access, to apply some 
reasonable restraints on just how intrusive the Symantec virus scanning tool is allowed to be.

Setting this up requires:
1. installing the cputhrottle command
  * brew install cputhrottle
1. entabling a script to grab the SymDaemon process-id / pid and run cputhrottle
  * See: Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh
    * Set its owner: sudo chown -R root:wheel /Applications/throttlesym.app
    * Set SUID (sticky bit) permissions: chmod 4755 /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh
1. creating a "plist" descriptor for the launchd agent
  * Library/LaunchAgents/org.example.throttlesym.plist
  * This could be in ~/Library or /Library, depending on whether the agent should be active for one or all users.
1. modifying /etc/sudoers
  * Add this line to /etc/sudoers using the sudo visudo command
    * youruserid ALL=(ALL) NOPASSWD: /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh
      * ...where youruserid is... um... your user id.
1. loading the agent using the launchctl command.
  * launchctl load -w ~/Library/LaunchAgents/org.example.throttlesym.plist

* To check on how it's working:
  * sudo cat /tmp/throttlesym.out
  * sudo cat /tmp/throttlesym.err
  * ps -Ax |grep cputhrottle
  * ps -Ax |grep throttlesym