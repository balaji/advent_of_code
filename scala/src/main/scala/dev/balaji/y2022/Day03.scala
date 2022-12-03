package dev.balaji.y2022

object Day03 {
  def main(args: Array[String]): Unit = {
    def input = {
      val source = scala.io.Source.fromFile("../inputs/2022/day03.txt")
      source.getLines
    }

    def priority(ch: Char) = 1 + (if (ch.isUpper) ch.toInt - 'A' + 26 else ch.toInt - 'a')

    println(input
      .map(str => str.split("(?<=\\G.{%s})".format(str.length / 2))
        .map(_.toCharArray.toSet))
      .map(f => f(0).intersect(f(1)).head)
      .map(priority)
      .sum)

    println(input
      .grouped(3)
      .map(_.map(_.toCharArray.toSet))
      .map(f => f(0).intersect(f(1)).intersect(f(2)).head)
      .map(priority)
      .sum)
  }
}
