package dev.balaji.y2023

import dev.balaji.Util.inputFor
import scala.collection.immutable.SortedMap
import scala.collection.MapView

@main
def day07(): Unit = {
    val lines = inputFor(2023, 7).toList
    println(calculateRank(groupByKind(lines, "part1"), "part1"))
    println(calculateRank(groupByKind(lines, "part2"), "part2"))
}

def calculateRank(grouped:  MapView[Int, List[String]], part: String): Long = {
    var rank = 1
    var total: Long = 0
    (SortedMap[Int, List[String]]() ++ grouped).keys.foreach(key => {
        grouped.get(key).get
            .sortWith((t1, t2) => {
                val s1 = t1.replaceAll("A", "Z").replaceAll("K", "Y").replaceAll("Q", "X").replaceAll("J", if (part.equals("part2")) then "1" else "W").replaceAll("T", "V")
                val s2 = t2.replaceAll("A", "Z").replaceAll("K", "Y").replaceAll("Q", "X").replaceAll("J", if (part.equals("part2")) then "1" else "W").replaceAll("T", "V")
                s1 < s2
            }).foreach(line => {
                total = total + (line.split(" ")(1).toLong * rank)
                rank += 1
            })
    })
    total
}

def groupByKind(lines: List[String], part: String): MapView[Int, List[String]] = {
    lines.map(line => {
        val map = line.split(" ")(0).toCharArray.groupBy(identity).mapValues(_.size)
        val (jCount, matchMap) = if(part.equals("part2")) then (map.getOrElse('J', 0), (scala.collection.mutable.Map() ++ map) - 'J') else (1, map) 
        (
            matchMap.keys.size match {
                case 5 => 1 // high card, no Js
                case 4 => 2 // (1,1,1,1), j = 1 (2,1,1,1), j = 0
                case 3 => // (3,1,1) ->3k, j = 0, (1,1,1) -> 3k, j =2, (2,2,1) -> 2p, j = 0, (2,1,1) -> 3k, j = 1
                    if(matchMap.valuesIterator.contains(3) || (part.equals("part2") && jCount > 0)) then 4 else 3
                case 2 =>  // (3,2) -> fh, j = 0, (4,1) -> 4k, j = 0, (3,1) -> 4k, j = 1, (2,2) -> fh, j = 1, (2, 1) -> 4k, j = 2
                    if (matchMap.valuesIterator.contains(2) && jCount < 2) then 5 else 6
                case 1 => 7 // (5), (4), (1), (2), (3)
                case 0 => 7 //only Js 5 in a row
            },
            line
        )
    })
    .groupBy(_._1).mapValues(_.map(_._2))
}
