#!/bin/bash

hardware_init() {
	echo -n 1 > regPC
	echo -n 0 > regA
	echo -n 0 > regSP
	echo -n 0 > regTMR
	. timer.sh &
}

fetch() {
	local pc=$(sed -n 1p regPC)
	sed -n "${pc}p" memory > instruction
	echo $(($pc + 1)) > regPC
}
decode() {
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
	' instruction > command
}
execution() {
	. command
}

main() {
	hardware_init

	while :; do
		fetch
		decode
		execution
	done
}

echo -n $$ > cpu_pid
main $@
