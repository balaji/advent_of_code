package dev.balaji.y2022

import dev.balaji.Util.inputFor

import java.lang.constant.DirectMethodHandleDesc
import scala.annotation.tailrec
import scala.collection.mutable

sealed trait Entry

case class Directory(name: String, var contents: List[Entry]) extends Entry

case class File(name: String, size: Int) extends Entry

@main
def day07(): Unit = {
  def findEntry(name: String, fs: Directory): Option[Directory] = fs match {
    case Directory(n, contents) => {
      if (n == name) {
        Some(fs)
      } else {
        contents.collect { case e: Directory => e }.flatMap(e => findEntry(name, e)).headOption
      }
    }
  }

  val root: Directory = new Directory(name = "/", contents = List())
  var currDir = root
  var sizes: List[String] = List("/")

  inputFor(2022, 7).drop(1).foreach {
    case "$ cd .." => {
      val parent = currDir.name.split("/").toList.dropRight(1).mkString("/") + "/"
      currDir = findEntry(parent, root).get
    }
    case s"$$ cd ${x}" => {
      val dirName = s"${currDir.name}${x}/"
      currDir = findEntry(dirName, root).get
    }
    case s"dir ${x}" => {
      val dirName = s"${currDir.name}${x}/"
      currDir.contents = currDir.contents :+ new Directory(dirName, List())
      sizes = sizes :+ dirName
    }
    case "$ ls" => None // ignore
    case e => {
      val arr = e.split(" ")
      currDir.contents = currDir.contents :+ new File(arr(1), arr(0).toInt)
    }
  }

  def calculateSize(files: Entry): Int = files match {
    case File(_, size) => size
    case Directory(_, contents) => contents.map(calculateSize).sum
  }

  var sizesMap = mutable.Map[String, Int]()
  for (elem <- sizes) {
    sizesMap(elem) = calculateSize(findEntry(elem, root).get)
  }
  println(sizesMap.values.filter(i => i <= 100000).sum)
  println(sizesMap.values.filter(e => e >= sizesMap("/") - 40000000).min)
}
