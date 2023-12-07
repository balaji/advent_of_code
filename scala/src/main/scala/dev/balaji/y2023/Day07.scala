package dev.balaji.y2023

import dev.balaji.Util.inputFor
import scala.collection.immutable.SortedMap

@main
def day07(): Unit = {
  val lines = inputFor(2023, 7).toList
  println(calculateRank(groupByKind(lines, "part1")))
  println(calculateRank(groupByKind(lines, "part2")))
}

def groupByKind(lines: List[String], part: String): SortedMap[Int, List[String]] = {
  val subs = Map('A' -> 'Z', 'K' -> 'Y', 'Q' -> 'X', 'J' -> (if (part.equals("part2")) then '1' else 'W'))
  SortedMap[Int, List[String]]() ++ lines.map(line => {
      val groupByChars = line.split(" ")(0).toCharArray.groupBy(identity).view.mapValues(_.length)

      val (jCount, charsMap) = if (part.equals("part2")) {
        (groupByChars.getOrElse('J', 0), groupByChars.filterKeys(!_.equals('J')))
      } else {
        (1, groupByChars)
      }

      val sortOrder = charsMap.keys.size match {
        case 5 => 1 // high card, no Js
        case 4 => 2 // (1,1,1,1) -> 1p, j = 1 (2,1,1,1) -> 1p j = 0
        case 3 => // (3,1,1) -> 3k, j = 0; (1,1,1) -> 3k, j =2; (2,2,1) -> 2p, j = 0; (2,1,1) -> 3k, j = 1
          if (charsMap.valuesIterator.contains(3) || (part.equals("part2") && jCount > 0)) then 4 else 3
        case 2 => // (3,2) -> fh, j = 0; (4,1) -> 4k, j = 0; (3,1) -> 4k, j = 1; (2,2) -> fh, j = 1; (2, 1) -> 4k, j = 2
          if (charsMap.valuesIterator.contains(2) && jCount < 2) then 5 else 6
        case 1 | 0 => 7 // (5), (4), (1), (2), (3) -> 5k; only Js
      }
      (sortOrder, line)
    })
    .groupBy(_._1).view.mapValues(_.map(_._2.map(c => subs.getOrElse(c, c))).sorted)
}

def calculateRank(grouped: SortedMap[Int, List[String]]): Long = {
  var rank = 1
  var total: Long = 0
  grouped.foreach((key, values) => {
    values.foreach(line => {
        total = total + (line.split(" ")(1).toLong * rank)
        rank += 1
      })
  })
  total
}
