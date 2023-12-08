package dev.balaji

import scala.annotation.tailrec
import scala.io.Source.fromFile

private object Util {
  def inputFor(year: Int, day: Int): Iterator[String] = {
    val source = fromFile("../inputs/%d/day%02d.txt".format(year, day))
    source.getLines
  }

  @tailrec
  def gcd(a: Long, b: Long): Long = if b == 0 then a else gcd(b, a % b)

  def lcm(a: Long, b: Long): Long = a * b / gcd(a, b)
}
