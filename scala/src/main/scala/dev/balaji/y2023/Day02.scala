package dev.balaji.y2023

import dev.balaji.Util.inputFor

@main
def day02(): Unit = {
  println(
    inputFor(year = 2023, day = 2)
      .mkString("\n")
      .split("\n")
      .map { case s"Game $i: $roll" =>
        val game = collection.mutable.Map[String, Int]()
        roll.split("; ").map {
          _.split(", ").map { case s"$count $key" =>
            game += game
              .get(key)
              .map(v => key -> (if (count.toInt > v) count.toInt else v))
              .getOrElse(key -> count.toInt)
          }
        }
        (i.toInt, game)
      }
      .map { case (game: Int, rolls: collection.mutable.Map[String, Int]) =>
        val part1 = game * List(("red", 12), ("green", 13), ("blue", 14))
          .map((k, x) => {
            rolls.get(k) match {
              case Some(v) if v > x => 0
              case _                => 1
            }
          })
          .product

        val part2 = rolls.values.product
        (part1, part2)
      }
      .reduce((a, b) => (a._1 + b._1, a._2 + b._2))
  )
}
