package dev.balaji.y2023

import dev.balaji.Util.inputFor

@main
def day06(): Unit = {
  var ((times1, times2) :: (distances1, distances2) :: _) = inputFor(2023, 6).map {
    case s"$_: $str" => {
      val regex = """(\d+)""".r
      (regex.findAllIn(str).map(_.toLong).toList,
        regex.findAllIn(str.replaceAll(" ", "")).map(_.toLong).toList)
    }
  }.toList

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
