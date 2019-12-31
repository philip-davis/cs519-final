#!/bin/bash

ADIOS2_PATH=ADIOS2/build/bin
PRELOAD_PATH=ADIOS2.preload/build/bin

WXR=$1
WYR=1
while [ $WXR -gt $WYR ] ; do
    WYR=$((WYR * 2))
    WXR=$((WXR / 2))
done

RXR=1
RYR=$2
while [ $RYR -gt $RXR ] ; do
    RXR=$((RXR * 2))
    RYR=$((RYR / 2))
done

SIZE=$3
XDIM=1
YDIM=$((SIZE / 8))
while [ $YDIM -gt $XDIM ] ; do
    XDIM=$((XDIM * 2))
    YDIM=$((YDIM / 2))
done

STEPS=$4

export FABRIC_IFACE=$5

rm -f heat.sst

WR=$((WXR * WYR))
RR=$((RXR * RYR))

#set -x

LOGSFX=${WR}.${RR}.${SIZE}.log
WPULLOG=writer.pull.${LOGSFX}
RPULLOG=reader.pull.${LOGSFX}
WPUSHLOG=writer.push.${LOGSFX}
RPUSHLOG=reader.push.${LOGSFX}

mpirun -np $WR ${ADIOS2_PATH}/heatTransfer_write_adios2 heat_sst_rdma.xml heat $WXR $WYR $XDIM $YDIM $STEPS $STEPS &> ${WPULLOG} &
while [ ! -f heat.sst ] ; do
  sleep 1
done
mpirun -np $RR ${ADIOS2_PATH}/heatTransfer_read heat_sst_rdma.xml heat heat.sst.out $RXR $RYR &> ${RPULLOG}

wait

rm -f heat.sst

mpirun -np $WR ${ADIOS2_PATH}/heatTransfer_write_adios2 heat_sst_rdma.xml heat $WXR $WYR $XDIM $YDIM $STEPS $STEPS &> ${WPUSHLOG} &
while [ ! -f heat.sst ] ; do
  sleep 1
done
mpirun -np $RR ${ADIOS2_PATH}/heatTransfer_read heat_sst_rdma.xml heat heat.sst.out $RXR $RYR &> ${RPUSHLOG}

wait

echo -n pull,$WR,$RR,$SIZE,$((STEPS - 2)),
awk '/Total read time/ {print $5}' ${RPULLOG}

echo -n push,$WR,$RR,$SIZE,$((STEPS - 2)),
awk '/Total read time/ {print $5}' ${RPUSHLOG}
