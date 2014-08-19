#!/bin/bash
push() {
	local sp=$(sed -n 1p regSP)
	sp=$(($sp - 1))
	echo -n $sp > regSP
	sed -i "${sp}c\\$1" memory
}

pop() {
	local sp=$(sed -n 1p regSP)
	local data=$(sed -n "${sp}p" memory)
	echo -n $(($sp + 1)) > regSP
	echo -n $data
}
