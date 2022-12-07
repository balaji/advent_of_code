package dev.balaji

private object Util {
  def inputFor(year: Int, day: Int): Iterator[String] = {
    val source = scala.io.Source.fromFile("../inputs/%d/Day%02d.txt".format(year, day))
    source.getLines
  }
}
