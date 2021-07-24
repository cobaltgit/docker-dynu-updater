#!/bin/bash -e

trap "exit" TERM

DELAY_REGEX="^[0-9]+([.][0-9]+)?$"
if ! [[ $DELAY =~ $DELAY_REGEX ]] ; then
   echo "[WARN] \$DELAY must be set as a number. Defaulting to 15 seconds..." >&2
   DELAY=15
fi

check_vars() {
    var_names=("$@")
    for var_name in "${var_names[@]}"; do
        [ -z "${!var_name}" ] && echo "[ERR] $var_name is unset." >&2 && var_unset=true
    done
    if [ -n "$var_unset" ]; then
        echo "[ERR] One or more required variables are unset."
        exit 1
    fi
    return 0
}

check_vars USERNAME PASSWORD DOMAIN

on_error_in_loop() {
    echo "[ERR] Exiting due to error..." >&2
    exit 1
}

while true; do
    IP4="$(curl -fsSL api.ipify.org)"
    IP6="$(curl -fsSL api6.ipify.org)"
    case $(curl -w "\n" -fsSLu "$USERNAME:$PASSWORD" "https://api.dynu.com/nic/update?hostname=$DOMAIN&myip=$IP4&myipv6=$IP6" 2>/dev/null) in
    "badauth")
        echo "[ERR] Your username, password and/or domain may be incorrect." >&2
        break
        ;;
    "nochg")
        echo "[OK] Nothing has changed"
        ;;
    "unknown")
        echo "[ERR] Unknown error." >&2
        break
        ;;
    "good $IP4")
        cat<<EOMSG
    [OK] Update success
        -> IPv4 is $IP4
        -> IPv6 is $IP6
EOMSG
        ;;
    esac
    sleep $DELAY
done || on_error_in_loop
