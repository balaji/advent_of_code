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
          1 to cards.getOrElseUpdate(cardNo, 1) foreach { _ =>
            for (i <- (cardNo + 1) to (cardNo + matches))
              cards += cards
                .get(i)
                .map(v => i -> (v + 1))
                .getOrElse(i -> 2) // one for self and one for copy
          }
          if matches > 0 then Math.pow(2, matches - 1) else 0
        }
      }
      .sum.toInt,
    cards.values.sum
  )
}
