package dev.balaji.y2022

import dev.balaji.Util.lines

@main
def main(): Unit = {
  val input = lines(year = 2022, day = 5).mkString("\n").split("\n\n")
  val crates = input(0).split("\n")
    .dropRight(1)
    .map(_.split("(?<=\\G.{4})").map(_.trim))
    .transpose.map(_.filter(_.nonEmpty))

  input(1).lines
    .map { case s"move ${x} from ${y} to ${z}" => (x.toInt, y.toInt - 1, z.toInt - 1) }
    .forEach(tup => {
      val (i, f, t) = tup
      val toMove = crates(f).take(i).reverse //part B: remove .reverse
      crates(f) = crates(f).drop(i)
      crates(t) = toMove ++ crates(t)
    })

  crates.map(_.head).map { case s"[${elem}]" => elem }.foreach(print)
}
