package dev.balaji

import scala.annotation.tailrec
import scala.io.Source.fromResource
import scala.math.Integral.Implicits.infixIntegralOps

private object Util {
  def inputFor(year: Int, day: Int): Iterator[String] = {
    fromResource("inputs/%d/day%02d.txt".format(year, day)).getLines
  }

  @tailrec
  def gcd[T: Integral](a: T, b: T): T = if b == 0 then a else gcd(b, a % b)

  def lcm[T: Integral](a: T, b: T): T = a * (b / gcd(a, b))
}
