package dev.balaji.y2023

import dev.balaji.Util.inputFor

@main
def day04(): Unit = {
  val cards = collection.mutable.Map[Int, Int]()
  printf(
    "part1: %s, part2: %s",
    inputFor(2023, 4)
      .map {
        case s"Card $cardNo: $winningNumbers | $myNumbers" => {
          (
            cardNo.trim.toInt,
            """(\d+)""".r.findAllIn(winningNumbers).map(_.toInt).toList,
            """(\d+)""".r.findAllIn(myNumbers).map(_.toInt).toList
          )
        }
      }
      .map {
        case (cardNo, wins, mine) => {
          val matches = mine.intersect(wins).size
          for (i <- (cardNo + 1) to (cardNo + matches))
            cards += cards
              .get(i)
              .map(v => i -> (v + cards.getOrElse(cardNo, 1)))
              .getOrElse(i -> (1 + cards.getOrElse(cardNo, 1)))
          (if matches > 0 then Math.pow(2, matches - 1) else 0).toInt
        }
      }
      .sum,
    cards.values.sum
  )
}
