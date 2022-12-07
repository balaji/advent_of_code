package dev.balaji.y2022

import dev.balaji.Util.inputFor

sealed trait Entry

case class Directory(name: String, var contents: List[Entry]) extends Entry

case class File(name: String, size: Int) extends Entry

@main
def day07(): Unit = {
  def findEntry(name: String, dir: Directory): Option[Directory] = dir match {
    case Directory(n, contents) =>
      if (n == name) {
        Some(dir)
      } else {
        contents.collect { case e: Directory => e }.flatMap(e => findEntry(name, e)).headOption
      }
  }

  def calculateSize(files: Entry): Int = files match {
    case File(_, size) => size
    case Directory(_, contents) => contents.map(calculateSize).sum
  }

  val root: Directory = Directory(name = "/", contents = List())
  var currDir = root
  var dirs: List[String] = List("/")

  inputFor(2022, 7).drop(1).foreach {
    case "$ cd .." =>
      val parent = currDir.name.split("/").toList.dropRight(1).mkString("/") + "/"
      currDir = findEntry(parent, root).get

    case s"$$ cd ${x}" =>
      val dirName = s"${currDir.name}$x/"
      currDir = findEntry(dirName, root).get

    case s"dir ${x}" =>
      val dirName = s"${currDir.name}$x/"
      currDir.contents = currDir.contents :+ Directory(dirName, List())
      dirs = dirs :+ dirName

    case "$ ls" => None // ignore

    case e =>
      val arr = e.split(" ")
      currDir.contents = currDir.contents :+ File(arr(1), arr(0).toInt)
  }

  val sizesMap = dirs.map(elem => elem -> calculateSize(findEntry(elem, root).get)).toMap

  println(sizesMap.values.filter(i => i <= 100000).sum)
  println(sizesMap.values.filter(e => e >= sizesMap("/") - 40000000).min)
}
