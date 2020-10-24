from turtle import *
contents = open("inputs/day3.txt").read()

# begin_fill()
color = {
    0: "red",
    1: "green"
}
for i, content in enumerate(contents.split("\n")):
    if content == "":
        continue
    setpos(0,0)
    pendown()
    pencolor(color[i])
    for token in content.split(","):
        direction, value = token[0], token[1:]
        if direction == 'R':
            seth(0)
        elif direction == 'L':
            seth(180)
        elif direction == 'U':
            seth(90)
        else:
            seth(270)
        fd(0.05 * float(value))
    penup()
# end_fill()
done()
