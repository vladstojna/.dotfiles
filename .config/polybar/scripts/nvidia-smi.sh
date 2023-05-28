#!/bin/sh

IFS=', ' read -ra values < <(nvidia-smi \
	--query-gpu=utilization.gpu,clocks.gr \
	--format=csv,noheader,nounits) 
printf '%2s%% %4sMHz\n' ${values[@]}

