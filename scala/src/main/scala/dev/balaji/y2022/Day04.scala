package dev.balaji.y2022

import dev.balaji.Util.lines

object Day04 {
  def main(args: Array[String]): Unit = {
    println(lines(2022, 4)
      .map(_.split(',').map(_.split('-').map(_.toInt)))
      .map(arr => (overlap1(arr), overlap2(arr)))
      .foldLeft((0, 0))((acc1, acc2) => {
        (acc1._1 + acc2._1, acc1._2 + acc2._2)
      }))
  }

  private def overlap1(a: Array[Array[Int]]): Int = {
    if (a(1)(0) <= a(0)(0) && a(1)(1) >= a(0)(1) ||
      (a(0)(0) <= a(1)(0) && a(0)(1) >= a(1)(1))) 1 else 0
  }

  private def overlap2(a: Array[Array[Int]]) = {
    if ((a(0)(0) >= a(1)(0) && a(0)(0) <= a(1)(1)) ||
      (a(1)(0) >= a(0)(0) && a(1)(0) <= a(0)(1))) 1 else 0
  }
}
