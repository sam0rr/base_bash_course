#!/usr/bin/env bash

. ./components/utils.sh

bob_dole() {
	local -r target="bob dole"
	local input
	local random=$(($RANDOM % 100 + 1))

	header "bob dole validation"

	read -p "what is your name : " input

	if [[ "${input}" != "${target}" ]]; then
		error "you're out ${input}, you need to be called bob dole"
	else
		echo ""
		echo "your name is : ${input} and you're ${random}x random !"
		echo ""
	fi
}

bob_dole "${@}"
