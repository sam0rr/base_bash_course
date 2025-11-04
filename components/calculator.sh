#!/usr/bin/env bash

. ./components/utils.sh

IS_VALID="true"

print_array() {
  local -n array_ref="$1"

  for op in "${array_ref[@]}"; do
    echo "${op}"
  done
}

validate_number() {
  local number_ref="${1}"
  if [[ "${number_ref}" =~ ^[+-]?[0-9]+$ ]]; then
    echo "${number_ref} is a number"
  else
    IS_VALID="false"
    error "${number_ref} is not a number"
  fi
}

validate_operator() {
  local operator_ref="${1}"
  local -r operators=("+" "-" "*" "/")
  local valid=false
  
  for str in "${operators[@]}"; do
    if [[ "${operator_ref}" == "${str}" ]]; then
      valid=true
      break
    fi
  done

  if [[ "${valid}" == false ]]; then
    echo "valid operators are : "
    print_array operators
    IS_VALID="false"
    error "${operator_ref} is not a valid operator"
  fi
}

calculator() {
  local number1
  local number2
  local operator
  local result

  header "calculator"
  
  read -p "choose number 1 : " number1
  validate_number "${number1}"

  read -p "choose number 2 : " number2
  validate_number "${number2}"

  read -p "chose your operator : " operator
  validate_operator "${operator}"

  if [[ "${IS_VALID}" == true ]]; then
    result=$((number1 "${operator}" number2))
    echo ""
    echo "${result}"
    echo ""
  else
    echo ""
    header "not a valid operation"
    echo ""
  fi
}

calculator "${a}"
