#!/usr/bin/env bash

ulimit -n 1024

echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

if [ "$#" -ne 1 ] ; then
   echo "Missing argument: Name of cell"
   exit 1
fi

rm -rf extfiles
mkdir -p extfiles

magic -rcfile $PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc -dnull -noconsole << EOF
gds read $1.gds
load $1
select top cell
expand

extract path extfiles
extract all

extresist tolerance 10
extresist

ext2spice lvs
ext2spice cthresh 0
ext2spice extresist on
ext2spice -p extfiles
ext2spice $1

quit
EOF
