#!/bin/bash

if [ ! -x bin/dmenu ]; then
	echo -e "ERROR: dmenu executable is not built yet"
	exit 1
fi

echo -e "LOG: running dmenu"
cd bin/
./dmenu_run_test
cd ..
