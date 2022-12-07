package dev.balaji.y2022

import dev.balaji.Util.inputFor

sealed trait Entry

case class Directory(name: String, var contents: List[Entry]) extends Entry

case class File(name: String, size: Int) extends Entry

@main
def day07(): Unit = {
  def findEntry(name: String, dir: Directory): Option[Directory] = {
    if (dir.name == name) {
      Some(dir)
    } else {
      dir.contents.collect { case e: Directory => e }.flatMap(e => findEntry(name, e)).headOption
    }
  }

  def calculateSize(entry: Entry): Int = entry match {
    case File(_, size) => size
    case Directory(_, contents) => contents.map(calculateSize).sum
  }

  val root: Directory = Directory(name = "", contents = List())
  var currDir = root
  var dirs: List[String] = List("")

  inputFor(2022, 7).drop(1).foreach {
    case s"$$ cd ${x}" =>
      val dirName = if (x == "..") currDir.name.split("/").dropRight(1).mkString("/") else s"${currDir.name}/$x"
      currDir = findEntry(dirName, root).get

    case s"dir ${x}" =>
      val dirName = s"${currDir.name}/$x"
      currDir.contents = currDir.contents :+ Directory(dirName, List())
      dirs = dirs :+ dirName

    case s"$size $name" =>
      if (name != "ls") currDir.contents = currDir.contents :+ File(name, size.toInt)
  }

  val sizesMap = dirs.map(elem => elem -> calculateSize(findEntry(elem, root).get)).toMap

  println(sizesMap.values.filter(i => i <= 100000).sum)
  println(sizesMap.values.filter(e => e >= sizesMap("") - 40000000).min)
}
