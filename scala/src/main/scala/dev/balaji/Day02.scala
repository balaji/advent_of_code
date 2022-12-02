package dev.balaji

object Day02 {
  def main(args: Array[String]): Unit = {
    def prep = {
      val source = scala.io.Source.fromFile("../inputs/2022/day02.txt")
      source.getLines
        .map(_.split(' ').map(_.charAt(0)))
        .map(f => (f(0) - 65, f(1) - 88))
    }

    println(prep.map((a, b) => {
      (if (a == b) {
        3
      } else if (b == (a + 1) % 3) {
        6
      } else {
        0
      }) + b  + 1
    }).sum)

    println(prep.map((a, b) => {
      (if (b == 1) {
        a + 3
      } else if (b == 0) {
        (a + 2) % 3
      } else {
        ((a + 1) % 3) + 6
      }) + 1
    }).sum)
  }
}
