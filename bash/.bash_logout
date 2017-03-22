if command -v etckeeper_check >/dev/null; then etckeeper_check; fi

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
