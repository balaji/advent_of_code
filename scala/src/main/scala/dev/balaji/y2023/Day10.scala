package dev.balaji.y2023

import dev.balaji.AdventOfCode
import dev.balaji.Util.inputFor

import scala.annotation.tailrec
import scala.util.matching.Regex

object Move extends Enumeration {
  val U, D, L, R, N = Value

  implicit class ImplicitMove(move: Value) {
    def nextPoint(t: (Int, Int)): (Int, Int) = move match {
      case U => (t._1 - 1, t._2)
      case D => (t._1 + 1, t._2)
      case R => (t._1, t._2 + 1)
      case L => (t._1, t._2 - 1)
    }
  }
}

class Inst(val inst: Char) {
  def loopMoves(): (Move.Value, Move.Value) = inst match {
    case '|' => (Move.U, Move.D)
    case '-' => (Move.L, Move.R)
    case 'F' => (Move.D, Move.R)
    case 'L' => (Move.U, Move.R)
    case 'J' => (Move.U, Move.L)
    case '7' => (Move.D, Move.L)
  }
  def nextMove(move: Move.Value): Option[Move.Value] = (inst, move) match {
    case ('|', Move.U) => Some(Move.U)
    case ('|', Move.D) => Some(Move.D)
    case ('-', Move.L) => Some(Move.L)
    case ('-', Move.R) => Some(Move.R)
    case ('7', Move.U) => Some(Move.L)
    case ('7', Move.R) => Some(Move.D)
    case ('L', Move.D) => Some(Move.R)
    case ('L', Move.L) => Some(Move.U)
    case ('J', Move.R) => Some(Move.U)
    case ('J', Move.D) => Some(Move.L)
    case ('F', Move.L) => Some(Move.D)
    case ('F', Move.U) => Some(Move.R)
    case (_, _)        => None
  }
}
object Day10 extends AdventOfCode {

  override def part1(lines: Seq[String]) = part(lines, solve1).sum
  override def part2(lines: Seq[String]): Int = part(lines, solve2).sum

  private def part(
      lines: Seq[String],
      fn: (Array[Array[(Move.Value, Int)]], Array[Array[(Move.Value, Int)]]) => Seq[Int]
  ): Seq[Int] = {
    val array = toInstructions(lines)
    val start = findStart(array)

    Seq('|', '-', 'F', 'J', 'L', '7')
      .map(Inst(_))
      .flatMap(inst => {
        val (a, b) = inst.loopMoves()
        (
          loop(a, a.nextPoint(start), array, defaultArray(array, start, a), 0),
          loop(b, b.nextPoint(start), array, defaultArray(array, start, b), 0)
        ) match {
          case (Some(a1), Some(a2)) => fn(a1, a2)
          case _                    => None
        }
      })
  }

  def solve1(a1: Array[Array[(Move.Value, Int)]], a2: Array[Array[(Move.Value, Int)]]): Seq[Int] = {
    for {
      i <- a1.indices
      j <- a1(i).indices
      if a1(i)(j)._2 == a2(i)(j)._2 && a1(i)(j)._2 != 'a'
    } yield a1(i)(j)._2
  }

  def solve2(a1: Array[Array[(Move.Value, Int)]], a2: Array[Array[(Move.Value, Int)]]): Seq[Int] = {
    val strings = a1.map(_.map(y => if y._2 == 'a' then "." else y._1.toString))
    println(strings.map(_.mkString("", "", "")).mkString("", "\n", ""))
    Seq(0)
  }

  private def defaultArray(array: Array[Array[Inst]], start: (Int, Int), move: Move.Value) = {
    val arr: Array[Array[(Move.Value, Int)]] = Array.fill(array.length) {
      Array.fill(array(0).length) { (Move.N, 'a') }
    }
    arr(start._1)(start._2) = (move, 0)
    arr
  }

  @tailrec
  def loop(
      move: Move.Value,
      point: (Int, Int),
      arr: Array[Array[Inst]],
      acc: Array[Array[(Move.Value, Int)]],
      steps: Int
  ): Option[Array[Array[(Move.Value, Int)]]] = {
    val (y, x) = point
    if (x < 0 || y < 0 || y >= arr.length || x >= arr(0).length) return None
    val inst = arr(y)(x)
    if inst.inst == 'S' then Some(acc)
    else {
      inst.nextMove(move) match {
        case Some(v) =>
          acc(y)(x) = (v, steps + 1)
          loop(v, v.nextPoint(point), arr, acc, steps + 1)
        case _ => None
      }
    }
  }

  private def findStart(array: Array[Array[Inst]]): (Int, Int) = {
    (for {
      i <- array.indices
      j <- array(i).indices
      if array(i)(j).inst == 'S'
    } yield (i, j)).head
  }

  private def toInstructions(lines: Seq[String]) = lines.map(_.map(Inst(_)).toArray).toArray

  def main(args: Array[String]): Unit = {
    println(part1(inputFor(2023, 10).toSeq))
//    println(part2(inputFor(2023, 10).toSeq))
  }
}
