#!/usr/bin/env bash

! php -v | grep Xdebug >/dev/null && exit 0

xdebugIni="$(php --ini | jq -rR 'capture("(?<path>.+xdebug[^,]+),"; "g") | .path')"

[[ -z "${XDEBUG_CONFIG}" ]] &&
  cat >"${xdebugIni}" &&
  echo -e "\e[32mXdebug disabled\e[0m" &&
  exit 0

echo "${XDEBUG_CONFIG}" |
  jq -rR 'split("\\s"; null) | .[] | . = "xdebug." + .' |
  cat >>"${xdebugIni}"
echo -e "\e[38;41m Xdebug enabled !!! \e[0m"
exit 0
