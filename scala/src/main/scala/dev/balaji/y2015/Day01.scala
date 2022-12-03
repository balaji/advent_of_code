package dev.balaji.y2015

import dev.balaji.Util.*

import scala.annotation.tailrec

object Day01 {
  def main(args: Array[String]): Unit = {
    println(lines(2015, 1)
      .flatMap(_.toCharArray)
      .map(c => if (c == '(') 1 else -1)
      .sum)

    println(sum(lines(2015, 1)
      .flatMap(_.toCharArray).toList, 0, 0))

    @tailrec
    def sum(list: List[Char], acc: Int, index: Int): Int = (list, acc, index) match {
      case (Nil, a, _) => a
      case (_, -1, i) => i
      case (head :: tail, a, i) => sum(tail, a + (if (head == '(') 1 else -1), i + 1)
    }
  }
}
