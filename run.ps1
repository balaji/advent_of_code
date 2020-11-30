#!/usr/bin/env pwsh
$day=$args[0]
$year=$args[1] ?? "2020"
erlc src/util/utils.erl
erlc src/$year/day"$day".erl
erl -s "day$day" main "inputs/$year/day$day.txt" -s init stop -noshell
