package dev.balaji.y2023

import dev.balaji.Util.{inputFor, lcm}

val loop = new scala.util.control.Breaks

@main
def day08(): Unit = {
  val lines = inputFor(2023, 8).toSeq
  val instruction = lines.head
  val map = lines.drop(2).map { case s"$node = ($left, $right)" => (node -> (left, right)) }.toMap

  def solve(start: Iterable[String]) = {
    def calculateSteps(start: String) = {
      var current = start
      var steps: Long = 0
      loop.breakable {
        while (true) {
          for (i <- instruction) {
            current = i match {
              case 'L' => map(current)._1
              case 'R' => map(current)._2
            }
            steps += 1
            if (current.charAt(2) == 'Z') loop.break
          }
        }
      }
      steps
    }

    start.map(calculateSteps).reduce(lcm)
  }

  Seq(Seq("AAA"), map.keys.filter(_.charAt(2) == 'A')).map(solve).foreach(println)
}
