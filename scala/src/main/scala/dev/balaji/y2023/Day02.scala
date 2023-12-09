package dev.balaji.y2023

import dev.balaji.AdventOfCode
import dev.balaji.Util.inputFor

object Day02 extends AdventOfCode {
  override def part1(lines: Seq[String]): Int = {
    val cubesLimit = Seq(("red", 12), ("green", 13), ("blue", 14))
    lines
      .map { case s"Game $game: $roll" => (game.toInt, cubeConundrum(roll)) }
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

  override def part2(lines: Seq[String]): Int = {
    lines
      .map { case s"$_: $roll" => cubeConundrum(roll) }
      .map(_.values.product)
      .sum
  }

  /** Given a semi-colon separated string of colored cube rolls, returns a map with highest roll for
    * each of the cube
    *
    * @param roll
    *   e.g. 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    * @return
    *   e.g. {blue -> 6, red -> 4, green -> 2}
    */
  private def cubeConundrum(roll: String): collection.mutable.Map[String, Int] = {
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

  def main(args: Array[String]): Unit = {
    val lines = inputFor(2023, 2).toSeq
    println(part1(lines))
    println(part2(lines))
  }
}
