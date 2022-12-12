package dev.balaji.y2022

import dev.balaji.Util.inputFor

case class Monkey(
    id: Int,
    var items: List[BigInt],
    operation: BigInt => BigInt,
    toMonkey: BigInt => Int
)

@main
def day11(): Unit = {
  var allDivs = List[Int]()
  val monkeys = inputFor(year = 2022, day = 11)
    .mkString("\n")
    .split("\n\n")
    .map(arr => {
      var id = 0
      var items: List[BigInt] = List()
      var operation: BigInt => BigInt = i => i
      var test: BigInt => Boolean = i => false
      var yesMonkeyIndex: Int = 0
      var noMonkeyIndex: Int = 0
      arr
        .split("\n")
        .foreach(str => {
          str.trim match {
            case s"Starting items: $i" =>
              items = i.split(", ").map(s => BigInt(s)).toList
            case s"Operation: new = old $op" =>
              op match {
                case "* old" => operation = (old: BigInt) => old * old
                case "+ old" => operation = (old: BigInt) => old + old
                case s"+ $operand" =>
                  operation = (old: BigInt) => old + operand.toInt
                case s"* $operand" =>
                  operation = (old: BigInt) => old * operand.toInt
              }
            case s"Test: divisible by $prime" =>
              allDivs :+= prime.toInt
              test = (t: BigInt) => t % prime.toInt == 0
            case s"If $bool: throw to monkey $num" => {
              if (bool == "true") yesMonkeyIndex = num.toInt
              else noMonkeyIndex = num.toInt
            }
            case s"Monkey $i:" => id = i.toInt
          }
        })
      (
        id,
        items,
        operation,
        (i: BigInt) => if (test(i)) yesMonkeyIndex else noMonkeyIndex
      )
    })
    .map((id, items, operation, indexFn) => Monkey(id, items, operation, indexFn))

  val inspected = Array.fill[BigInt](monkeys.length)(BigInt("0"))
  val superMod = allDivs.product

  (1 to 10000).foreach(_ =>
    monkeys.foreach(monkey => {
      inspected(monkey.id) += monkey.items.length
      monkey.items.foreach(worry => {
        val newWorry = monkey.operation(worry)
        monkeys(monkey.toMonkey(newWorry)).items :+= newWorry % superMod
      })
      monkey.items = List()
    })
  )
  println(inspected.sorted.takeRight(2).product)
}
