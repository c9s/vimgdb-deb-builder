#
# Regular cron jobs for the vimgdb package
#
0 4	* * *	root	[ -x /usr/bin/vimgdb_maintenance ] && /usr/bin/vimgdb_maintenance
