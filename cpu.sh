#!/bin/bash

hardware_init() {
	echo -n 100 > regPC
	echo -n 0 > regA
	echo -n 0 > regTMR
	. timer.sh &
}

fetch() {
	echo 'fetch' > state

	local pc=$(sed -n 1p regPC)
	sed -n "${pc}p" memory > instruction
}
decode() {
	echo 'decode' > state

	awk '
	BEGIN {
		FS=" "
	}
	$1 == "jmp" {
		printf "echo -n %d > regPC", $2
	}
	$1 == "mov" {
		printf "echo -n %s > %s", $2, $3
	}
	$1 == "ech" {
		print "cat regA"
	}
	$1 == "nop" {
		print ""
	}
	' instruction > command
}
execution() {
	echo 'execution' > state

	local pc=$(sed -n 1p regPC)
	echo $(($pc + 1)) > regPC
	. command
}

sched_init() {
	echo -n 0 > is_sched

	# Task1
	echo -n 200 > regSP
	sed -i '1c\200' memory
	echo -n 1 > running_task_id

	# Task2
	sed -i '298c\0' memory
	sed -i '299c\200' memory
	sed -i '2c\298' memory
}

main() {
	hardware_init

	sched_init

	while :; do
		fetch
		if [ "$(sed -n 1p is_sched)" = "1" ]; then
			echo -n 0 > is_sched
			continue
		fi
		decode
		if [ "$(sed -n 1p is_sched)" = "1" ]; then
			echo -n 0 > is_sched
			continue
		fi
		execution
	done
}

echo -n $$ > cpu_pid
main $@
