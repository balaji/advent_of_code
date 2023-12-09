package dev.balaji.y2023

import org.scalatest.funsuite.AnyFunSuite

class Day09Test extends AnyFunSuite {

  private val input =
    """0 3 6 9 12 15
      |1 3 6 10 15 21
      |10 13 16 21 30 45""".stripMargin
      .split("\n")
      .toSeq

  test("test Part1") {
    assert(Day09.part1(input) == 114)
  }

  test("test Part2") {
    assert(Day09.part2(input) == 2)
  }

}
