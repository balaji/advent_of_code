package dev.balaji

object Day03 {
  def main(args: Array[String]): Unit = {
    def prep = {
      val source = scala.io.Source.fromFile("../inputs/2022/day03.txt")
      source.getLines
    }

    def priority(ch: Char) = 1 + (if (ch.isUpper) ch.toInt - 'A' + 26 else ch.toInt - 'a')

    println(prep
      .map(str => str.split("(?<=\\G.{%s})".format(str.length / 2))
        .map(_.toCharArray.toSet))
      .map(f => f(0).intersect(f(1)).head)
      .map(priority)
      .sum
    )

    println(prep
      .grouped(3)
      .map(_.map(_.toCharArray.toSet))
      .map(f => f(0).intersect(f(1).intersect(f(2))).head)
      .map(priority)
      .sum)
  }
}
