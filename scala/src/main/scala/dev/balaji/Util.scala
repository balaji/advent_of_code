package dev.balaji

import scala.io.Source.fromFile

private object Util {
  def inputFor(year: Int, day: Int): Iterator[String] = {
    val source = fromFile("../inputs/%d/day%02d.txt".format(year, day))
    source.getLines
  }
}
