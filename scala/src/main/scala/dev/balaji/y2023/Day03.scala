package dev.balaji.y2023

import dev.balaji.Util.inputFor

@main
def day03(): Unit = {
  val array: Array[Array[Char]] = inputFor(2023, 3).map(_.toCharArray).toArray
  println(part1(scan(array, i => !i.isDigit && i != '.'), array))
  println(part2(scan(array, i => i == '*'), array))
}

def check[T](i: Int, j: Int, arr: Array[Array[T]], fn: (T) => Boolean): Boolean = {
  i >= 0 && j >= 0 && i < arr.length && j < arr(0).length && fn(arr(i)(j))
}

def scan(arr: Array[Array[Char]], fn: (Char) => Boolean): List[List[(Int, Int)]] = {
  arr.indices
    .flatMap(j =>
      arr(j).indices
        .map(i => (i, j))
        .filter((i, j) => fn(arr(i)(j)))
        .map((i, j) => {
          val points = List(
            (i, j + 1),
            (i, j - 1),
            (i - 1, j),
            (i + 1, j),
            (i + 1, j + 1),
            (i - 1, j - 1),
            (i + 1, j - 1),
            (i - 1, j + 1)
          ).filter((i, j) => check(i, j, arr, _.isDigit))
          // removes adjacent duplicates
          points.filter((a, b) => {
            !points.contains((a, b - 1))
          })
        })
    )
    .toList
}

def part1(pointPairs: List[List[(Int, Int)]], arr: Array[Array[Char]]): Int = {
  pointPairs.flatten.map(t => number(t, arr)).sum
}

def part2(pointPairs: List[List[(Int, Int)]], arr: Array[Array[Char]]): Int = {
  pointPairs
    .filter(_.size == 2)
    .map(_.map(t => number(t, arr)).product)
    .sum
}

def number(t: (Int, Int), arr: Array[Array[Char]]) = {
  val (a, b) = t
  var strNumber = arr(a)(b).toString
  var pos = b
  while (pos > 0 && arr(a)(pos - 1).isDigit) {
    pos -= 1
    strNumber = strNumber.prepended(arr(a)(pos))
  }
  pos = b
  while (pos < arr(0).length - 1 && arr(a)(pos + 1).isDigit) {
    pos += 1
    strNumber = strNumber.appended(arr(a)(pos))
  }
  strNumber.toInt
}
