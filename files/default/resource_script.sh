#!/bin/bash

while getopts “i:” OPTION; do
  case $OPTION in
    i)
      item=$OPTARG
      ;;
    ?)
      echo "UNKNOWN: Unknown argument: $1"
      exit $ST_UK
      ;;
  esac
done

# MANDATORY args
if [ -z "$item" ]; then
  echo "UNKNOWN: missing argument -i"
  exit $ST_UK
fi
# check for info and set $STATUS
out=$(crm_mon --one-shot --as-xml 2>/dev/null)
STATUS=$?

p_import="import xml.etree.cElementTree as et,sys,io;tree=et.ElementTree();"
p_tree="tree.parse(io.BytesIO(b'''$out'''));root=tree.getroot();"
if [ ${STATUS} -eq 0 ]
then
node_script="resource_list={};
node_list={};
pnode=dnode=unode='';
for value in root.findall('node_attributes/node'):
        node_list=dict([(j.get('name'), j.get('value')) for j in value]);
        resource_list[value.attrib['name']]=node_list;
        if ( node_list['hana_tha_clone_state'] == 'PROMOTED' ):
                pnode = value.attrib['name'];
        if (  node_list['hana_tha_clone_state'] == 'DEMOTED' ):
                dnode = value.attrib['name'];
        if (  node_list['hana_tha_clone_state'] == 'UNDEFINED' ):
                unode = value.attrib['name'];

"
case "$item" in
data_list)
p_script="
print reource_list
"
;;
nodes_online)
p_script="
print ' '.join([f.get('online') for f in root.findall('nodes/node')])"
;;
resources_running)
p_script="
list = ['Master','Slave','Started'];
count = 0;
for elem in tree.iter(tag='resource'):
        for i in list:
			 if ( elem.get('role') == i ):
                          count += 1
print count;
"
;;
p_node)p_script="
print pnode;"
;;
d_node)
p_script="
if ( len(resource_list) == 2 ):
        if dnode:
                print dnode;
        else:
                print unode;
else:
        print 'Node offline';
"
;;
p_role)
p_script="
if pnode:
        print resource_list[pnode]['hana_tha_roles'];
else:
        print resource_list[unode]['hana_tha_roles'];
"
;;
p_sync_state)
p_script="
if pnode:
        print resource_list[pnode]['hana_tha_sync_state'];
else:
        print resource_list[unode]['hana_tha_sync_state'];
"
;;
p_score)
p_script="
if pnode:
        print resource_list[pnode]['master-rsc_SAPHana_THA_HDB00'];
else:
        print resource_list[unode]['master-rsc_SAPHana_THA_HDB00'];
"
;;
d_role)
p_script="
if ( len(resource_list) == 2 ):
        if dnode:
                print resource_list[dnode]['hana_tha_roles'];
        else:
                print resource_list[unode]['hana_tha_roles'];

else:
        print 'Node offline';
"
;;
d_sync_state)
p_script="
if ( len(resource_list) == 2 ):
        if dnode:
                print resource_list[dnode]['hana_tha_sync_state'];
        else:
                print resource_list[unode]['hana_tha_sync_state'];
else:
        print 'Node offline';
"
;;
d_score)
p_script="
if ( len(resource_list) == 2 ):
        if dnode:
                print resource_list[dnode]['master-rsc_SAPHana_THA_HDB00'];
        else:
                print resource_list[unode]['master-rsc_SAPHana_THA_HDB00'];

else:
         print 'Node offline';
"
;;
*) echo "UNKNOWN: wrong item: $item"
 exit ${STATE_UNKNOWN}
;;
esac
p_out=$(python -c "$p_import $p_tree $node_script $p_script") # 2>/dev/null)
    if [ $? -eq 0 ]
    then
        echo "$p_out"
    else
        echo "UNKNOWN: python returncode $?"
        exit ${STATE_UNKNOWN}
    fi
elif [ ${STATUS} -eq 107 ]
then
    echo "Connection to cluster failed: returncode ${STATUS}"
else
    echo "UNKNOWN: returncode ${STATUS}"
 exit ${STATE_UNKNOWN}
fi