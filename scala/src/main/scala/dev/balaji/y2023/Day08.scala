package dev.balaji.y2023

import dev.balaji.Util.inputFor

import scala.annotation.tailrec
val loop = new scala.util.control.Breaks

@main
def day08(): Unit = {
  val lines = inputFor(2023, 8).toSeq
  val map = lines.drop(2).map { case s"$node = ($left, $right)" => (node -> (left, right)) }.toMap

  Seq(Seq("AAA"), map.keys.filter(_.charAt(2) == 'A'))
    .map(start => solve(start, lines.head, map))
    .foreach(println)
}

def solve(start: Iterable[String], instruction: String, map: Map[String, (String, String)]) = {
  start
    .map(key => calculateSteps(key, instruction, map))
    .reduce((a, b) => (a * b) / lcm(a, b))
}

def calculateSteps(start: String, instruction: String, map: Map[String, (String, String)]) = {
  var current = start
  var steps: Long = 0
  loop.breakable {
    while (true) {
      for (i <- instruction) {
        current = i match {
          case 'L' => map(current)._1
          case 'R' => map(current)._2
        }
        steps += 1
        if (current.charAt(2) == 'Z') loop.break
      }
    }
  }
  steps
}

@tailrec
def lcm(a: Long, b: Long): Long = if b == 0 then a else lcm(b, a % b)
