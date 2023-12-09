package dev.balaji.y2023

import dev.balaji.AdventOfCode
import dev.balaji.Util.inputFor

object Day09 extends AdventOfCode {
  override def part1(lines: Seq[String]): Long =
    lines.map(_.split(" ").map(_.toInt)).map(solve1).sum

  override def part2(lines: Seq[String]): Long =
    lines.map(_.split(" ").map(_.toInt)).map(solve2).sum

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
    report.last + (if report.forall(_ == 0) then 0
                   else solve1(report.zip(report.tail).map(x => x._2 - x._1)))

  /** returns the previous item in an arithmetic progression such that the repeated difference
    * between the two adjacent elements will return 0
    *
    * @param report
    *   e.g. Array(10,13,16,21,30,45)
    * @return
    *   next item in the progression, e.g. 5
    */
  private def solve2(report: Array[Int]): Long =
    report.head - (if report.forall(_ == 0) then 0
                   else solve2(report.zip(report.tail).map(x => x._2 - x._1)))

  def main(args: Array[String]): Unit = {
    val lines = inputFor(2023, 9).toSeq
    println(part1(lines))
    println(part2(lines))
  }
}
