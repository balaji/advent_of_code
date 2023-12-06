package dev.balaji.y2023

import dev.balaji.Util.inputFor

@main
def day06(): Unit = {
  val numberRegex = """(\d+)""".r
  var (times1, times2, distances1, distances2) =
    (List[Long](), List[Long](), List[Long](), List[Long]())
  inputFor(2023, 6).foreach {
    case s"Time: $str" =>
      times1 = numberRegex.findAllIn(str).map(_.toLong).toList
      times2 = numberRegex.findAllIn(str.replaceAll(" ", "")).map(_.toLong).toList
    case s"Distance: $str" =>
      distances1 = numberRegex.findAllIn(str).map(_.toLong).toList
      distances2 = numberRegex.findAllIn(str.replaceAll(" ", "")).map(_.toLong).toList
  }

  for (g <- List(times1.zip(distances1), times2.zip(distances2)))
    println(
      g.map(t => {
        val (time, distance) = t
        var res: Long = 0
        for (i <- (distance / time) to ((distance / time) + time))
          if (i * (time - i) > distance) res += 1
        res
      }).product
    )
}
