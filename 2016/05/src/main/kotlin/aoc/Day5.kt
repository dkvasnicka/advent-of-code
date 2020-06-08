package aoc

import org.apache.commons.codec.digest.DigestUtils

const val PWD_SIZE = 8

data class PwdChar(val pos: Char, val chr: Char)

fun main(args: Array<String>) {
    val input = "cxdnnyjw"

    val relevantHashes = (0..Int.MAX_VALUE).asSequence()
        .map { input + it.toString() }
        .map { DigestUtils.md5Hex(it) }
        .filter { it.startsWith("00000") }

    // Part 1
    val result = relevantHashes
        .map { it.toCharArray()[5] }
        .take(PWD_SIZE)
        .joinToString(separator = "")

    println(result)

    // Part 2
    val result2 = relevantHashes
        .map { val ary = it.toCharArray(); PwdChar(ary[5], ary[6]) }
        .filter { it.pos in ('0'..'7') }
        .distinctBy { it.pos }
        .take(PWD_SIZE)
        .sortedBy { it.pos }
        .map { it.chr }
        .joinToString(separator = "")

    println(result2)
}
