package dev.balaji

object Day02 {
  def main(args: Array[String]): Unit = {
    val win = Map(1 -> 2, 2 -> 3, 3 -> 1)
    val lose = Map(2 -> 1, 3 -> 2, 1 -> 3)
    println(prep.map((a, b) => {
      (if (a == b) {
        3
      } else if (win(a) == b) {
        6
      } else {
        0
      }) + b
    }).sum)

    println(prep.map((a, b) => {
      val res = if (b == 2) {
        (a, 3)
      } else if (b == 1) {
        (lose(a), 0)
      } else {
        (win(a), 6)
      }
      res._1 + res._2
    }).sum)
  }

  private def prep = {
    val source = scala.io.Source.fromFile("../inputs/2022/day02.txt")
    source.getLines.map(line => {
      val Array(x, y, _*) = line.split(' ')
      (x.charAt(0) - 64, y.charAt(0) - 87)
    })
  }
}
