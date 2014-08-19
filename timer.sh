#!/bin/bash

. stack_func.sh

while :; do
	if [ "$(sed -n 1p regTMR)" = "1" ]; then
		sleep 1
		kill -STOP $(cat cpu_pid)

		push $(sed -n 1p regPC)

		. timer_handler.sh

		echo -n $(pop) > regPC

		kill -CONT $(cat cpu_pid)
	fi
done
