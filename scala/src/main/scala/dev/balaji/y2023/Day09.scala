package dev.balaji.y2023

import dev.balaji.AdventOfCode
import dev.balaji.Util.inputFor

object Day09 extends AdventOfCode {
  override def part1(lines: Seq[String]) = (toIntSeq(lines) map solve1).sum

  override def part2(lines: Seq[String]) = (toIntSeq(lines)  map solve2).sum

  private def toIntSeq(lines: Seq[String]) = {
    lines.map(_.split(" ").map(_.toInt))
  }

  /** returns the next item in an arithmetic progression such that the repeated difference between
    * the two adjacent elements will return 0
    *
    * This could've been tail recursive, but kept it this way for mirroring solve2
    *
    * @param report
    *   e.g. Array(10,13,16,21,30,45)
    * @return
    *   next item in the progression, e.g. 68
    */
  private def solve1(report: Array[Int]): Long =
    report.last + (if report.forall(_ == 0) then 0 else solve1(diff(report)))

  /** returns the previous item in an arithmetic progression such that the repeated difference
    * between the two adjacent elements will return 0
    *
    * @param report
    *   e.g. Array(10,13,16,21,30,45)
    * @return
    *   next item in the progression, e.g. 5
    */
  private def solve2(report: Array[Int]): Long =
    report.head - (if report.forall(_ == 0) then 0 else solve2(diff(report)))

  private def diff(report: Array[Int]): Array[Int] = (report.tail lazyZip report).map(_ - _)

  /* iteration version, which seems to be idiomatic scala */
  private def solveIter(report: Array[Int]): Long =
    LazyList.iterate(report)(diff).takeWhile(!_.forall(_ == 0)).map(_.last).sum

  def main(args: Array[String]): Unit = {
    val lines = inputFor(2023, 9).toSeq
    println(part1(lines))
    println(part2(lines))
  }
}
