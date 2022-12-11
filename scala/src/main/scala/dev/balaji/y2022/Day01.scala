package dev.balaji.y2022

import dev.balaji.Util.inputFor

@main
def day01(): Unit = {
  val r = inputFor(year = 2022, day = 1)
    .foldLeft(List[List[Int]](List())) { (acc, line) =>
      line match {
        case "" => List() :: acc
        case l => (l.toInt :: acc.head) :: acc.tail
      }
    }
    .map(_.sum)

  println(r.max)
  println(r.sorted.takeRight(3).sum)
}
