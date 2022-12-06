package dev.balaji.y2022

import dev.balaji.Util.inputFor

import scala.annotation.tailrec
import scala.util.control.Breaks._

@main
def day06(): Unit = {
  val input = inputFor(year = 2022, day = 6).mkString

  // recursion
  @tailrec
  def findIndex(str: String, step: Int, start: Int): Int = {
    if (str.substring(start, start + step).toSet.size == step) {
      start + step
    } else {
      findIndex(str, step, start + 1)
    }
  }
  Array(4, 14).map(m => findIndex(input, m, 0)).foreach(println)

  // streams
  Array(4, 14).foreach(m => {
    var index = 0
    breakable {
      for (elem <- input.sliding(m)) {
        if (elem.toSet.size == m) {
          println(index + m)
          break
        }
        index += 1
      }
    }
  })
}
