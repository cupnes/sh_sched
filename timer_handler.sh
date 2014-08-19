#!/bin/bash

. stack_func.sh

sched() {
	push $(sed -n 1p regA)

	# Save SP
	local sp=$(sed -n 1p regSP)
	local tid=$(sed -n 1p running_task_id)
	sed -i "${tid}c\\$sp" memory

	# Scheduler
	tid=$(($tid + 1))
	if [ $tid -eq 3 ]; then
		tid=1
	fi
	echo -n $tid > running_task_id

	# Load SP
	echo -n $(sed -n "${tid}p" memory) > regSP

	echo -n $(pop) > regA
}

sched
