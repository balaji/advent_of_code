package dev.balaji.y2022

import dev.balaji.Util.inputFor

@main
def day10(): Unit = {
  var cycles = List[Int](1)
  inputFor(2022, 10).foreach {
    case "noop" => {
      cycles :+= cycles.last
    }
    case s"addx $num" => {
      cycles :+= cycles.last
      cycles :+= (cycles.last + num.toInt)
    }
  }

  println(Array(20, 60, 100, 140, 180, 220).map(i => i * cycles(i - 1)).sum)

  cycles
    .grouped(40)
    .map(_.zipWithIndex.map((index, i) => if ((i - (index % 40)).abs < 2) "#" else "."))
    .map(_.mkString)
    .foreach(println)
}
