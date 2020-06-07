package aoc

import org.apache.commons.codec.digest.DigestUtils

fun main(args: Array<String>) {
    val input = "cxdnnyjw"

    val result = (0..Int.MAX_VALUE).asSequence()
        .map { input + it.toString() }
        .map { it.toByteArray() }
        .map { DigestUtils.md5Hex(it) }
        .filter { it.startsWith("00000") }
        .map { it.toByteArray()[5] }
        .take(8)
        .toList()

        println(String(result.toByteArray()))
}
