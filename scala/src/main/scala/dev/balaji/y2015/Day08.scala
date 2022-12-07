package dev.balaji.y2015

import dev.balaji.Util.inputFor

@main
def day08(): Unit = {
  val input = inputFor(2015, 8).toList

  val a = input.map(_.length).sum
  val b = input
    .map(_
      .replaceAll("\\\\\\\\", "_")
      .replaceAll("\\\\\"", "_")
      .replaceAll("(\\\\x[a-f0-9]{2})", "_"))
    .map(_.length - 2)
    .sum
  val c = input
    .map(_
      .replaceAll("\\\\\\\\", "____")
      .replaceAll("\\\\\"", "____")
      .replaceAll("\\\\x", "___"))
    .map(_.length + 4)
    .sum

  println(s"${a - b} ${(c - a)}")
}
