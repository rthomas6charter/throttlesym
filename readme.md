Symantec's SymDaemon will consume 100% of a MacBook's CPU.  This uses the cputhrottle command to limit that.

Setting this up requires:
* (one time only) brew install cputhrottle
* A script to grab the SymDaemon process-id / pid and run cputhrottle
  * See: Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh
    * Set its owner: sudo chown -R root:wheel /Applications/throttlesym.app
    * Set SUID (sticky bit) permissions: chmod 4755 /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh
* A "plist" descriptor for the launchd agent
  * Library/LaunchAgents/org.example.throttlesym.plist
  * This could be in ~/Library or /Library, depending on whether the agent should be active for one or all users.
* An entry in /etc/sudoers
  * Add this line to /etc/sudoers using the sudo visudo command
    * youruserid ALL=(ALL) NOPASSWD: /Applications/throttlesym.app/Contents/Resources/throttlesym/bin/throttlesym.sh
      * Where youruserid is... um... your user id.
* Loading the agent using the launchctl command.
  * launchctl load -w ~/Library/LaunchAgents/org.example.throttlesym.plist

* To check on how it's working:
  * sudo cat /tmp/throttlesym.out
  * sudo cat /tmp/throttlesym.err
  * ps -Ax |grep cputhrottle
  * ps -Ax |grep throttlesym