Ganglia Event Wrapper
========

Call this script when you need to create an event in [ganglia](http://ganglia.info/). Syntax is as follows:

`/opt/ganglia_event_begin.sh "Daily MySQL Backup"`   
`/opt/ganglia_event_begin.sh "Daily Tape Backup"`

and

`/opt/ganglia_event_end.sh "Daily MySQL Backup"`   
`/opt/ganglia_event_end.sh "Daily Tape Backup"`

Which will result in this fancy little graph on ganglia:

![Ganglia Event](http://i.imgur.com/S9bSc6k.png)