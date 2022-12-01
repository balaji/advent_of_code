package dev.balaji

object Day01 {
  def main(args: Array[String]): Unit = {
    val source = scala.io.Source.fromFile("../inputs/2022/day01.txt")
    try {
      val sorted = source.getLines.mkString("\n").split("\n\n")
        .map(_.split("\n").map(_.toInt))
        .map(_.sum)
        .toList.sorted
      println(s"part 1: ${sorted.last}, part 2: ${sorted.takeRight(3).sum}")
    } finally {
      source.close()
    }
  }
}