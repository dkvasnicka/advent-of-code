package aoc

import org.apache.commons.codec.digest.DigestUtils

fun Sequence<Byte>.toByteArray(): ByteArray {
    val iter = iterator()
    return ByteArray(8) { iter.next() }
}

fun main(args: Array<String>) {
    val input = "cxdnnyjw"

    val result = (0..Int.MAX_VALUE).asSequence()
        .map { input + it.toString() }
        .map { DigestUtils.md5Hex(it) }
        .filter { it.startsWith("00000") }
        .map { it.toByteArray()[5] }
        .toByteArray()

        println(String(result))
}
