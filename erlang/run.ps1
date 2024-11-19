#!/usr/bin/env pwsh
$year=$args[0] ?? "2020"
$day=$args[1]
erlc src/util/utils.erl
erlc src/$year/day"$day".erl
erl -s "day$day" main "../inputs/$year/day$day.txt" -s init stop -noshell
