package dev.balaji.y2023

import dev.balaji.Util.inputFor

import scala.annotation.tailrec

@main
def day05(): Unit = {
  val numberRegex = """(\d+)""".r
  var seeds: List[Long] = null
  val map = collection.mutable.Map[String, List[(Long, Long, Long)]]()
  val keyMap = collection.mutable.Map[String, String]()
  inputFor(2023, 5)
    .mkString("\n")
    .split("\n\n")
    .foreach(lines => {
      val groups = lines.split("\n").toList
      groups.head match {
        case s"seeds: $seedNumbers" => {
          seeds = numberRegex.findAllIn(seedNumbers).map(_.toLong).toList
        }

        case s"$src-to-$dest map:" => {
          keyMap += (src -> dest)

          groups.tail.foreach(group => {
            val (ds :: ss :: len :: _) = numberRegex.findAllIn(group).map(_.toLong).toList
            val key = s"$src$dest"
            map += map
              .get(key)
              .map(v => key -> ((ss, ds, len) :: v))
              .getOrElse(key -> List((ss, ds, len)))
          })
        }
      }
    })
  println(
    toPairs(seeds, List())
      .map(pair => {
        var m = Long.MaxValue
        for (i <- 0L until pair._2) {
          val next = map.get("seedsoil").map(v => findDestination((i + pair._1), v)).get
          m = Math.min(m, findFn(keyMap, map, "soil", next))
        }
        m

      })
      .min
  )

}

@tailrec
def toPairs(l: List[Long], acc: List[(Long, Long)]): List[(Long, Long)] = {
  l match {
    case a :: b :: rest => toPairs(rest, (a, b) :: acc)
    case _              => acc
  }
}

def findDestination(seed: Long, locations: List[(Long, Long, Long)]): Long = {
  val dest = locations
    .map {
      case (src, dest, range) =>
        if (seed >= src && seed <= (src + range)) then (dest + (seed - src)) else -1
      case null => -1
    }
    .filter(t => t > -1)
  if dest.nonEmpty then dest.min else seed
}

@tailrec
def findFn(
    keyMap: collection.mutable.Map[String, String],
    map: collection.mutable.Map[String, List[(Long, Long, Long)]],
    key: String,
    location: Long
): Long = {
  key match {
    case "location" => location
    case "missing"  => -1
    case src => {
      val dest = keyMap.getOrElse(src, "missing")
      val acc = map.get(s"$src$dest").map(v => findDestination(location, v)).get
      findFn(keyMap, map, dest, acc)
    }
  }
}
