#!/bin/sh
### BEGIN INIT INFO
# Provides:          srcds
# Required-Start:    $remote_fs $syslog $network
# Required-Stop:     $remote_fs $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the Source dedicated server
# Description:       Script to simulate daemonizing srcds. It doesn't truly run
#                    as a daemon, instead this script runs it inside a tmux
#                    session.
### END INIT INFO

# Author: Steven Benner
# Author: Peter Rowlands <peter@pmrowla.com>

# replace <newuser> with the user you created above
SRCDS_USER="<newuser>"

# Do not change this path
PATH=/bin:/usr/bin:/sbin:/usr/sbin

SELF=$(cd $(dirname $0); pwd -P)/$(basename $0)

# The path to the game you want to host. example = /home/newuser/dod
DIR=/home/<newuser>/orangebox
DAEMON=$DIR/srcds_run

# Change all PARAMS to your needs.
PARAMS="-game tf +map pl_badwater"
NAME=SRCDS
DESC="srcds"

case "$1" in
	start)
		echo "Starting $DESC:"
		if [ -e $DIR ]; then
			cd $DIR
			su $SRCDS_USER -l -c "tmux new -d -s $NAME $DAEMON $PARAMS"
            echo " ... done."
		else
			echo "No such directory: $DIR!"
		fi
		;;

	stop)
		if su $SRCDS_USER -l -c "tmux ls" |grep $NAME; then
			echo -n "Stopping $DESC:"
			su $SRCDS_USER -l -c "tmux kill-session -t $NAME"
			echo " ... done."
		else
			echo "Couldn't find a running $DESC"
		fi
		;;

	restart)
        $SELF stop
        $SELF start
		;;

	status)
		# Check whether there's a "srcds" process
		ps aux | grep -v grep | grep srcds_r > /dev/null
		CHECK=$?
		[ $CHECK -eq 0 ] && echo "SRCDS is UP" || echo "SRCDS is DOWN"
		;;

	*)
		echo "Usage: $0 {start|stop|status|restart}"
		exit 1
		;;
esac

exit 0
