import sys

with open('../inputs/2023/day01.txt', 'r') as input:
    total = 0
    numbers = {'one':1, 'two':2, 'three':3, 'four':4, 'five':5, 'six':6, 'seven':7, 'eight':8, 'nine':9}
    for line in input:
        first_number, last_number = None, None
        first_number2, last_number2 = None, None
        first_index2, last_index2 = len(line), -1
        first_index, last_index = len(line), -1
        
        for number in list(numbers.keys()):
            if line.find(number) != -1 and line.find(number) < first_index2:
                first_number2 = numbers[number]
                first_index2 = line.find(number)
            
            if line.rfind(number) > last_index2:
                last_number2 = numbers[number]
                last_index2 = line.rfind(number)

        for num in range(len(line) - 1):
            if line[num].isnumeric():
                first_number = line[num]
                first_index = num
                break
        
        for num in reversed(range(len(line) - 1)):
            if line[num].isnumeric():
                last_number = line[num]
                last_index = num
                break

        f = first_number2 if first_index > first_index2 else first_number
        s = last_number2 if last_index == -1 or last_index < last_index2 else last_number

        total += int(f"{f}{s}")
    
    print(total)