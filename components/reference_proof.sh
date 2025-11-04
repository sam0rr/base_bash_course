#!/usr/bin/env bash

. ./components/utils.sh

modify_name() {
	local -n bob_ref="${1}"
	local bobito_ref="${2}"
	local input

	echo "here is the second argument passed : ${bobito_ref}"

	read -rp "what is the new name : " input

	bob_ref="${input}"
}

main() {
	local bob="bobito"
	echo ""
	echo "content:"
	cat ./components/reference_proof.sh
	echo ""

	echo "before ref value: ${bob}"
	modify_name bob "bobito"
	echo "after ref value: ${bob}"
}

main "${@}"
