ThisBuild / scalaVersion := "3.1.3"
ThisBuild / organization := "dev.balaji"

lazy val adventOfCode = (project in file("."))
  .settings(
    name := "AdventOfCode"
  )
