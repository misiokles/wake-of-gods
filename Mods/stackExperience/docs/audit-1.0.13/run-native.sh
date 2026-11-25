#!/bin/bash
R=/mnt/data/VCMI_1.8_Headless_Test_Environment/restored; S=$R/source/vcmi-develop; T=/mnt/data/testwork; A=/mnt/data/audit13
source "$R/env.sh"; export XDG_DATA_HOME=$A/profile/data XDG_CONFIG_HOME=$A/profile/config XDG_CACHE_HOME=$A/profile/cache
cd "$R/build/bin"
for mode in summon wall rebirth aging; do
 g++ -std=c++20 -O0 -DNDEBUG -fno-access-control -I"$S" -I"$S/lib" -I"$S/server" -I"$S/include" -I"$R/prefix/usr/include" -c "$A/$mode.cpp" -o "$A/$mode.o" > "$A/$mode-compile.log" 2>&1 || { echo "$mode compile failed"; continue; }
 g++ -o "$A/$mode" "$A/$mode.o" "$T"/regen_{builder,legacy,mock,writer}.o -L"$R/build/bin" -L"$R/prefix/usr/lib/x86_64-linux-gnu" -Wl,-rpath-link,"$R/prefix/usr/lib/x86_64-linux-gnu" -lvcmiservercommon -lvcmi -lboost_filesystem -ltbb -lz -pthread > "$A/$mode-link.log" 2>&1 || { echo "$mode link failed"; continue; }
 timeout 45 "$A/$mode" > "$A/$mode-native.log" 2>&1 && echo "$mode PASS" || echo "$mode exit=$?"
done
