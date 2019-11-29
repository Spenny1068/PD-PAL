#!/usr/bin/env bash
declare -a files=("UserInfo.sqlite3" "StepCount.sqlite3" "exercises.sqlite3", "Routines.sqlite3", "UserExerciseData.sqlite3")

clear
for file in "${files[@]}"; do
    path=$(find /Users/spenc/Library/Developer/CoreSimulator/Devices/ -name $file)
    printf "$path"
done
