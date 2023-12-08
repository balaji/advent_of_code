ThisBuild / scalaVersion := "3.1.3"
ThisBuild / organization := "dev.balaji"

lazy val adventOfCode = (project in file("."))
  .settings(
    name := "AdventOfCode"
  )
libraryDependencies +=
  "org.scala-lang.modules" %% "scala-parallel-collections" % "1.0.4"
libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.15" % "test"
