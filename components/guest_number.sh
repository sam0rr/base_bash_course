#!/usr/bin/env bash

# Configuration
SCORE_DIR="./components/storage"
TOP_SCORE_FILE="${SCORE_DIR}/guest_number_top.txt"
if [[ -f "${TOP_SCORE_FILE}" ]]; then
  while IFS='=' read -r key value; do
    [[ "${key}" == "[TOP_SCORE]" ]] && TOP_SCORE="${value}"
  done < "${TOP_SCORE_FILE}"
else  
  if ! [[ -d "${SCORE_DIR}" ]]; then
  	mkdir "${SCORE_DIR}" || true
  fi
  touch "${TOP_SCORE_FILE}"
  TOP_SCORE=0
fi
HISTORY_SCORE_FILE="${SCORE_DIR}/guest_number_history.txt}"

# Sourcing
. ./components/utils.sh

validate_number() {
	local number_ref="${1}"

	if ! [[ "${number_ref}" =~ ^[+-]?[0-9]+$ ]]; then
		error "${number_ref} is not a number"
		return 1
	fi

	if (("${number_ref}" < 0 || "${number_ref}" > 100)); then
		error "The number must be between 0 and 100"
		return 1
	fi

	return 0
}

clues() {
	local random_ref="${1}"
	local number_ref="${2}"
	local message="you are the most lost ever"
	declare -A messages=(
		[5]="you are very very close"
		[10]="you are very close"
		[20]="you are close"
		[30]="you are off"
		[40]="you are very off"
		[50]="you are lost"
	)
	local dif=$(("${random_ref}" - "${number_ref}"))
	((dif < 0)) && dif=$((-dif))

	echo ""
	if ((dif <= 5)); then
		message="${messages[5]}"
		echo "${message}"
	elif ((dif <= 10)); then
		message="${messages[10]}"
		echo "${message}"
	elif ((dif <= 20)); then
		message="${messages[20]}"
		echo "${message}"
	elif ((dif <= 30)); then
		message="${messages[30]}"
		echo "${message}"
	elif ((dif <= 40)); then
		message="${messages[40]}"
		echo "${message}"
	elif ((dif <= 50)); then
		message="${messages[50]}"
		echo "${message}"
	else
		((dif <= 10))
		echo "${message}"
	fi
	echo ""
}

calculate_score() {
  local attempts_ref="${1}"
  local -n score_ref="${2}"
  local step

  if ((attempts_ref <= 10)); then
    step=$((10 - attempts_ref))
    score_ref=$((step * 15))
  elif ((attempts_ref <= 20)); then
    step=$((20 - attempts_ref))
    score_ref=$((step * 10))
  elif ((attempts_ref <= 30)); then
    step=$((30 - attempts_ref))
    score_ref=$((step * 5))
  elif ((attempts_ref <= 40)); then
    step=$((40 - attempts_ref))
    score_ref=$((step * 2))
  else
    score_ref=0
  fi

  echo ""
  echo "your score is : ${score_ref}"
  echo
}

history_score_util() {
  local attempts_ref="${1}"
  local score_ref="${2}"
  when="$(date '+%Y-%m-%d %H:%M:%S')"
  
  if ! [[ -d "${SCORE_DIR}" ]]; then
  	mkdir "${SCORE_DIR}" || true
  fi

  if ! [[ -f "${HISTORY_SCORE_FILE}" ]]; then
  	touch "${HISTORY_SCORE_FILE}" || true
  fi

  echo "${when} ; attempts : ${attempts_ref} ; score : ${score_ref}" >> "${HISTORY_SCORE_FILE}"
}

top_score_util() {
  local -n score_ref="${1}"

  if ((score_ref > TOP_SCORE)); then
    echo "[TOP_SCORE]=${score_ref}" >"${TOP_SCORE_FILE}"
    TOP_SCORE="${score_ref}"
    echo ""
    echo "new top score ${score_ref}"
  fi
}

game_loop() {
	local random=$((RANDOM % 101))
	local input
	local attempts=0

	while true; do
	  echo ""
	  echo "##################################"
		echo "number of attempts : ${attempts}"
		echo "Current Top Score : ${TOP_SCORE}"
	  echo "##################################"
	  echo ""

		if ((attempts >= 41)); then
		  error "too much attempts, you loose"
		  break
		fi

		read -rp "guest a number between 0 and 100: " input

		if ! validate_number "${input}"; then
			((attempts++))
			continue
		fi

		if (("${input}" == "${random}")); then
		  local score
		  echo ""
			echo "you won"
			echo ""
			((attempts++))

      calculate_score "${attempts}" score
      history_score_util "${attempts}" "${score}"
			top_score_util score
			break
		fi

		clues "${random}" "${input}"
		((attempts++))
	done
}

menu() {
	echo ""
	echo "0 - quit"
	echo "1 - play"
	echo "2 - see scores"
	echo ""
}

guest_number() {
	local option
	header "GUEST GAME 1-100"

	while true; do
		menu
		read -rp "choose option : " option
		case "${option}" in
		"0")
			break
			;;
		"1")
			game_loop
			;;
		"2")
			cat "${HISTORY_SCORE_FILE}"
			;;
		*)
			echo ""
			error "not a valid choice"
			echo ""
			;;
		esac
	done
}

guest_number "${@}"
