plugins {
    application
    kotlin("jvm") version "1.3.61"
    id("org.jlleitschuh.gradle.ktlint") version "9.2.1"
}

application {
    mainClassName = "aoc.Day5Kt"
}

dependencies {
    compile("commons-codec:commons-codec:1.14")
    compile(kotlin("stdlib"))
}

repositories {
    jcenter()
}
