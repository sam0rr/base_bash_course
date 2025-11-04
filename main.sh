#!/usr/bin/env bash

#####################################
# learning simple scripting without
# in bash to master the shell
#####################################
set -euo pipefail

readonly COMPONENTS_DIR="./components"
readonly UTILS="${COMPONENTS_DIR}/utils.sh"
readonly STORAGE_DIR="${COMPONENTS_DIR}/storage"
readonly EDITOR_FILE="${STORAGE_DIR}/editor.txt"
if [[ -f "${EDITOR_FILE}" ]]; then
	while IFS='=' read -r key value; do
		[[ "${key}" == "[EDITOR]" ]] && EDITOR="${value}"
	done <"${EDITOR_FILE}"
else
	if ! [[ -d "${STORAGE_DIR}" ]]; then
		mkdir "${STORAGE_DIR}" || true
	fi
	touch "${EDITOR_FILE}"
	EDITOR="nano"
fi

# source
. "${UTILS}"

menu() {
	echo ""
	echo "#################################"
	echo "Press 0 to exit"
	echo "Press 1 to edit"
	echo "2)  name"
	echo "3)  reference proof"
	echo "4)  calculator"
	echo "5)  guest the number"
	echo "#################################"
	echo ""
}

edit_menu() {
	echo ""
	echo "#################################"
	echo "Press 0 to exit"
	echo "Press 1 to choose editor"
	echo "2)  main (this file)"
	echo "3)  name"
	echo "4)  reference proof"
	echo "5)  calculator"
	echo "6)  guest the number"
	echo "#################################"
	echo ""
}

choose_editor() {
	local editor

	header "Current Editor: ${EDITOR}"
	read -rp "enter the command to open your editor of choice : " editor

	editor="${editor,,}"

	if ! command -v "${editor}" >/dev/null; then
		error "the editor ${editor} is not valid"
		debug "fallback to ${EDITOR} as the default"
	else
		echo "[EDITOR]=${editor}" >"${EDITOR_FILE}"
		EDITOR="${editor}"
		echo ""
		echo "new editor set : ${editor}"
	fi
}

edit_mode() {
	local option
	while true; do
		edit_menu
		read -rp "choose the script to run: " option

		case "${option}" in
		"0")
			break
			;;

		"1")
			choose_editor
			;;

		"2")
			"${EDITOR}" ./main.sh
			;;

		"3")
			"${EDITOR}" "${COMPONENTS_DIR}"/bob_dole.sh
			;;

		"4")
			"${EDITOR}" "${COMPONENTS_DIR}"/reference_proof.sh
			;;

		"5")
			"${EDITOR}" "${COMPONENTS_DIR}"/calculator.sh
			;;

		"6")
			"${EDITOR}" "${COMPONENTS_DIR}"/guest_number.sh
			;;

		*)
			error "choice is not in the list"
			;;
		esac
	done
}

main() {
	local option

	header "learning bash scripting for fun"

	while true; do
		menu

		read -rp "choose the script to run: " option

		case "${option}" in
		"0")
			header "thanks for learning bash with me"
			exit 0
			;;

		"1")
			edit_mode
			;;

		"2")
			"${COMPONENTS_DIR}"/bob_dole.sh
			;;

		"3")
			"${COMPONENTS_DIR}"/reference_proof.sh
			;;

		"4")
			"${COMPONENTS_DIR}"/calculator.sh
			;;

		"5")
			"${COMPONENTS_DIR}"/guest_number.sh
			;;

		*)
			error "choice is not in the list"
			;;
		esac
	done
}

main "${@}"
