package dev.balaji

object Util {
  def lines(year: Int, day: Int): Iterator[String] = {
    val source = scala.io.Source.fromFile("../inputs/%d/Day%02d.txt".format(year, day))
    source.getLines
  }
}
