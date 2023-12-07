package dev.balaji.y2023

import dev.balaji.Util.inputFor
import scala.collection.immutable.SortedMap

@main
def day07(): Unit = {
  val lines = inputFor(2023, 7).toList
  List("part1", "part2").map(p => calculateRank(groupByKind(lines, p))).foreach(println)
}

def groupByKind(lines: List[String], part: String): SortedMap[Int, List[String]] = {
  val subs = Map('A' -> 'Z', 'K' -> 'Y', 'Q' -> 'X', 'J' -> (if part.equals("part2") then '1' else 'W'))
  SortedMap[Int, List[String]]() ++ lines.map(line => {
      val groupByChars = line.split(" ")(0).toCharArray.groupBy(identity).view.mapValues(_.length)
      val (jCount, charsMap) = if part.equals("part1") then
        (1, groupByChars)
      else
        (groupByChars.getOrElse('J', 0), groupByChars.filterKeys(!_.equals('J')))

      val sortOrder = charsMap.keys.size match {
        case 5 => 1 // high cards, no j
        case 4 => 2 // (1,1,1,1) -> 1p; j = 1 (2,1,1,1) -> 1p, j = 0
        case 3 => // (3,1,1) -> 3k, j = 0; (1,1,1) -> 3k, j =2; (2,2,1) -> 2p, j = 0; (2,1,1) -> 3k, j = 1
          if charsMap.values.exists(_ == 3) || (part.equals("part2") && jCount > 0) then 4 else 3
        case 2 => // (3,2) -> fh, j = 0; (4,1) -> 4k, j = 0; (3,1) -> 4k, j = 1; (2,2) -> fh, j = 1; (2, 1) -> 4k, j = 2
          if charsMap.values.exists(_ == 2) && jCount < 2 then 5 else 6
        case 1 | 0 => 7 // (1), (2), (3), (4), (5) -> 5k, j respectively in (4, 3, 2, 1, 0); () -> 5k, only j
      }
      (sortOrder, line)
    })
    .groupBy(_._1).view.mapValues(_.map(_._2.map(c => subs.getOrElse(c, c))).sorted)
}

def calculateRank(grouped: SortedMap[Int, List[String]]): Int = {
  var rank = 0
  grouped.values.flatMap(_.map(line => {
    rank += 1
    line.split(" ")(1).toInt * rank
  })).sum
}
