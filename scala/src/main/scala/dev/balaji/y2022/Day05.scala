package dev.balaji.y2022

import dev.balaji.Util.lines

object Day05 {
  def main(args: Array[String]): Unit = {
    val input = lines(2022, 5).mkString("\n").split("\n\n")
    val stack: Array[List[String]] = input(0).split("\n").dropRight(1)
      .map(_.split("(?<=\\G.{4})")
        .map(_.trim).toList).toList
      .transpose
      .map(_.filter(_.nonEmpty)).toArray

    input(1).lines
      .map {
        case s"move ${x} from ${y} to ${z}" => (x.toInt, y.toInt - 1, z.toInt - 1)
      }
      .forEach(t => {
        val from: List[String] = stack(t._2)
        val to: List[String] = stack(t._3)
        val toMove: List[String] = from.take(t._1).reverse //partB: remove .reverse
        stack(t._2) = from.drop(t._1)
        stack(t._3) = toMove ++ to
      })
    stack.map(_.head).map { case s"[${elem}]" => elem }.foreach(print)
  }
}
