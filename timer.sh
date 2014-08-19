#!/bin/bash

. stack_func.sh

debug_counter=0

while :; do
	if [ "$(sed -n 1p regTMR)" = "1" ]; then
		sleep 2
		kill -STOP $(cat cpu_pid)

		push $(sed -n 1p regPC)



		. timer_handler.sh

		echo -n $(pop) > regPC

		# echo -n 'nop' > instruction
		# echo -n '' > command
		echo -n 1 > is_sched

# debug_counter=$(($debug_counter + 1))
# if [ $debug_counter -eq 1 ]; then
# 	exit 1
# fi
		kill -CONT $(cat cpu_pid)
	fi
done
