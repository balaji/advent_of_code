from sys import stdout

for line in ["1100011011010100111110001",
             "0101000010111011110110111",
             "1010011010111100101111110",
             "1110001010100011010101000",
             "1000010110000111000001010",
             "1001001010001101000011110"]:
    for digit in line:
        if digit == '0':
            stdout.write("  ")
        else:
            stdout.write("\u2591\u2591")
    stdout.write("\n")
