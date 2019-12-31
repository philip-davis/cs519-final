#!/bin/bash

INFILE=$1
TRIALS=$2
IFACE=$3

echo "method, writer_ranks, reader_ranks, step_size, measured_steps, read_time"

while read PARAM ; do
    ./run.sh $PARAM $TRIALS $IFACE < /dev/null
    #echo "./run.sh $PARAM $TRIALS $IFACE"
done < "${INFILE}"
