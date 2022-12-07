package dev.balaji.y2015

import dev.balaji.Util.inputFor

import scala.annotation.tailrec
import scala.collection.mutable

@main
def day07(): Unit = {
  val machines = mutable.Map[String, String]()
  inputFor(2015, 7).map(_.split(" -> ")).foreach(arr => machines(arr(1)) = arr(0))

  def compute(str: String, acc: mutable.Map[String, Int]): Int = {
    if (str.forall(Character.isDigit)) {
      str.toInt
    } else {
      acc.getOrElseUpdate(str, {
        machines(str) match {
          case s"${x} AND ${y}" => compute(x, acc) & compute(y, acc)
          case s"${x} OR ${y}" => compute(x, acc) | compute(y, acc)
          case s"NOT ${x}" => ~compute(x, acc)
          case s"${x} RSHIFT ${num}" => compute(x, acc) >> num.toInt
          case s"${x} LSHIFT ${num}" => compute(x, acc) << num.toInt
          case x => compute(x, acc)
        }
      })
    }
  }

  val a = compute("a", mutable.Map[String, Int]())
  println(a)
  machines("b") = a.toString
  println(compute("a", mutable.Map[String, Int]()))
}
