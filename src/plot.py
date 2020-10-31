from turtle import *

contents = open("points.txt").read()
lines = contents.split("\n")
list.reverse(lines)
setpos(0, 0)
for i, content in enumerate(lines):
    if content == "":
        continue
    print(content.split(","))
    [direction, color, x, y] = content.split(",")
    setpos(10 * int(x), 10 * int(y))
    if color == '1':
        pendown()
        dot(10, 'blue')
        penup()
done()
