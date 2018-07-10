
#!/bin/bash

p_script="
infile = '/var/log/cluster/corosync.log'
import re
from datetime import datetime,timedelta
strptime = datetime.strptime
year=datetime.now().year
count=0
month=datetime.now().strftime('%b')
for line in reversed(open(infile).readlines()):
        if (line.startswith(str(month)) ):
                d1=' '.join((line[0:6],str(year)))
                d2=' '.join((d1,line[7:15]))
                sc_date = datetime.strptime(d2, '%b %d %Y %H:%M:%S')
                dif_date=datetime.now() - timedelta(minutes=5)
                if(sc_date >= dif_date ):
                        m = re.search(r'(crmd.*(warning|error))|(stonith.*(warning|error))|(pengine.*(warning|error))|(sbd.*(warning|error))|(cib.*(info|warning|error)) ',line,re.M|re.I)
                        if m:
                                print (line);
	
        else:
                continue
"
 p_out=$(python -c "$p_script")
    if [ $? -eq 0 ]
    then
        echo "$p_out"
    else
        echo "UNKNOWN: python returncode $?"
        exit ${STATE_UNKNOWN}
    fi
