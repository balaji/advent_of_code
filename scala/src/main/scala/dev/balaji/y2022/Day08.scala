package dev.balaji.y2022

import dev.balaji.Util
import scala.collection.mutable

@main
def day08(): Unit = {
  val forest: Array[Array[Char]] = Util.inputFor(2022, 8)
    .map(_.toCharArray).toArray

  //check visibility
  val d = forest.length
  val b = forest(0).length
  var visible = mutable.Set[(Int, Int)]()

  for (i <- 0 until d)
    for (j <- 0 until b)
      if (i == 0 || j == 0 || i == d - 1 || j == b - 1)
        visible += (i, j)

  for (i <- 1 until d - 1) {
    for (j <- 1 until b - 1) {
      var a = i
      //left
      var tH = (forest(i)(j), (i, j))
      while (a > 0) {
        if (forest(a - 1)(j) >= tH._1) {
          tH = (forest(a - 1)(j), (a - 1, j))
        }
        a -= 1
      }
      visible += tH._2

      a = i
      //right
      tH = (forest(i)(j), (i, j))
      while (a < d - 1) {
        if (forest(a + 1)(j) >= tH._1) {
          tH = (forest(a + 1)(j), (a + 1, j))
        }
        a += 1
      }
      visible += tH._2

      a = j
      //top
      tH = (forest(i)(j), (i, j))
      while (a > 0) {
        if (forest(i)(a - 1) >= tH._1) {
          tH = (forest(i)(a - 1), (i, a - 1))
        }
        a -= 1
      }
      visible += tH._2

      a = j
      //top
      tH = (forest(i)(j), (i, j))
      while (a < b - 1) {
        if (forest(i)(a + 1) >= tH._1) {
          tH = (forest(i)(a + 1), (i, a + 1))
        }
        a += 1
      }
      visible += tH._2
    }
  }

  val f = visible.map((x: Int, y: Int) => {
    val v = forest(x)(y)
    var (c1, c2, c3, c4) = (0, 0, 0, 0)
    var a = x - 1
    while (a >= 0) {
      c1 += 1
      a -= (if (v <= forest(a)(y)) b else 1)
    }

    a = x + 1
    while (a <= d - 1) {
      c2 += 1
      a += (if (v <= forest(a)(y)) b else 1)
    }

    a = y - 1
    while (a >= 0) {
      c3 += 1
      a -= (if (v <= forest(x)(a)) d else 1)
    }

    a = y + 1
    while (a <= b - 1) {
      c4 += 1
      a += (if (v <= forest(x)(a)) d else 1)
    }
    c1 * c2 * c3 * c4
  }).max
  println(visible.size)
  println(f)
}
