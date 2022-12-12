package dev.balaji.y2022

import dev.balaji.Util.inputFor

@main
def day09(): Unit = {

  def touching(a: (Int, Int), b: (Int, Int)) =
    (a._1 - b._1).abs <= 1 && (a._2 - b._2).abs <= 1

  def delta(a: (Int, Int), b: (Int, Int)) =
    ((a._1 - b._1).sign, (a._2 - b._2).sign)

  def moveTo(a: (Int, Int), b: (Int, Int)) =
    (a.copy(_1 = a._1 + b._1, _2 = a._2 + b._2))

  def points = {
    val orthogonal =
      Map("R" -> (1, 0), "L" -> (-1, 0), "D" -> (0, 1), "U" -> (0, -1))
    inputFor(2022, 9)
      .flatMap { case s"$direction $distance" =>
        Seq.fill(distance.toInt)(orthogonal(direction))
      }
  }

  def keepUp(length: Int, points: Seq[(Int, Int)]) = {
    points
      .scanLeft(Seq.fill(length)((0, 0))) { (rope, point) =>
        {
          val head = moveTo(rope.head, point)
          rope.tail.scan(head) { (prev, curr) =>
            if (touching(prev, curr)) curr else moveTo(curr, delta(prev, curr))
          }
        }
      }
      .map(_.last)
      .distinct
      .size
  }

  val p = points.toSeq
  println(keepUp(2, p))
  println(keepUp(10, p))
}
