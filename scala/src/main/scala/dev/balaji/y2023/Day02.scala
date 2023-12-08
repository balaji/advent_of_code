package dev.balaji.y2023

import dev.balaji.Util.inputFor

object Day01 {
  def main(args: Array[String]): Unit = {
    val lines = inputFor(2023, 2).toSeq
    println(part1(lines))
    println(part2(lines))
  }

  def part1(lines: Seq[String]): Int = {
    val cubesLimit = Seq(("red", 12), ("green", 13), ("blue", 14))
    lines
      .map { case s"Game $game: $roll" => (game.toInt, makeRollsMap(roll)) }
      .map { case (game, rolls) =>
        cubesLimit
          .map((game, cube) => {
            rolls.get(game) match {
              // using 0 & 1 as a way to eliminate invalids by multiplying
              case Some(v) if v > cube => 0
              case _                   => 1
            }
          })
          .product * game
      }
      .sum
  }

  def part2(lines: Seq[String]): Int = {
    lines
      .map { case s"$_: $roll" => makeRollsMap(roll) }
      .map(_.values.product)
      .sum
  }

  private def makeRollsMap(roll: String): collection.mutable.Map[String, Int] = {
    val game = collection.mutable.Map[String, Int]()
    roll.split("; ").map {
      _.split(", ").map { case s"$count $key" =>
        game += game
          .get(key)
          .map(v => key -> (if (count.toInt > v) count.toInt else v))
          .getOrElse(key -> count.toInt)
      }
    }
    game
  }
}
