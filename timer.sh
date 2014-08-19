#!/bin/bash

while :; do
	if [ "$(sed -n 1p regTMR)" = "1" ]; then
		sleep 1
		kill -STOP $(cat cpu_pid)

		local sp=$(sed -n 1p regSP)
		sp=$(($sp - 1))
		echo -n $sp > regSP
		local pc=$(sed -n 1p regPC)
		sed -i "${sp}c\\$pc" memory

		. timer_handler.sh

		sp=$(sed -n 1p regSP)
		pc=$(sed -n "${sp}p" memory)
		echo -n $pc > regPC
		echo -n $(($sp + 1)) > regSP

		kill -CONT $(cat cpu_pid)
	fi
done
