package dev.balaji.y2022

object Day01 {
  def main(args: Array[String]): Unit = {
    val source = scala.io.Source.fromFile("../inputs/2022/day01.txt")
    val sorted = source.getLines.mkString("\n").split("\n\n")
      .map(_.split("\n").map(_.toInt))
      .map(_.sum)
      .toList.sorted
    println(sorted.last)
    println(sorted.takeRight(3).sum)
  }
}
