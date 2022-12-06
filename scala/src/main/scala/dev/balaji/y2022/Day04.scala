package dev.balaji.y2022

import dev.balaji.Util.inputFor

object Day04 {
  def main(args: Array[String]): Unit = {
    inputFor(2022, 4)
      .map(_.split(',').map(_.split('-').map(_.toInt)))
      .map(arr => {
        val a1 = arr(0)(0)
        val a2 = arr(1)(0)
        val b1 = arr(0)(1)
        val b2 = arr(1)(1)
        (if ((a1 >= a2 && b2 >= b1) || (b1 >= b2 && a2 >= a1)) 1 else 0,
          if ((a1 >= a2 && b2 >= a1) || (b1 >= a2 && a2 >= a1)) 1 else 0)
      })
      .foldLeft((0, 0))((acc1, acc2) => (acc1._1 + acc2._1, acc1._2 + acc2._2))
      .productIterator.foreach(println)
  }
}
