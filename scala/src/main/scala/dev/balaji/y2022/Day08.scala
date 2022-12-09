package dev.balaji.y2022

import dev.balaji.Util

@main
def day08(): Unit = {
  val forest = Util.inputFor(2022, 8).map(_.toCharArray).toArray

  val d = forest.length
  var visible = Set[(Int, Int)]()

  for (i <- 0 until d) {
    var (c1, c2, c3, c4) = (-1, -1, -1, -1)
    for (j <- 0 until d) {
      if (forest(j)(i) > c1) {
        c1 = forest(j)(i)
        visible += (j, i)
      }

      if (forest(i)(d - j - 1) > c2) {
        c2 = forest(i)(d - j - 1)
        visible += (i, d - j - 1)
      }

      if (forest(i)(j) > c3) {
        c3 = forest(i)(j)
        visible += (i, j)
      }

      if (forest(d - j - 1)(i) > c4) {
        c4 = forest(d - j - 1)(i)
        visible += (d - j - 1, i)
      }
    }
  }
  println(visible.size)

  val scenicScore = visible.map((i, j) => {
    val v = forest(i)(j)
    var (c1, c2, c3, c4) = (0, 0, 0, 0)

    var a = i - 1
    while (a >= 0) {
      c1 += 1
      a -= (if (v <= forest(a)(j)) d else 1)
    }

    a = j - 1
    while (a >= 0) {
      c3 += 1
      a -= (if (v <= forest(i)(a)) d else 1)
    }

    a = i + 1
    while (a <= d - 1) {
      c2 += 1
      a += (if (v <= forest(a)(j)) d else 1)
    }

    a = j + 1
    while (a <= d - 1) {
      c4 += 1
      a += (if (v <= forest(i)(a)) d else 1)
    }

    c1 * c2 * c3 * c4
  }).max

  println(scenicScore)
}
