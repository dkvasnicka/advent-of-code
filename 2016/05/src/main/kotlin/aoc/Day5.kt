package aoc

import org.apache.commons.codec.digest.DigestUtils

fun Sequence<Byte>.toPassword(): ByteArray {
    val iter = iterator()
    return ByteArray(8) { iter.next() }
}

data class PwdChar(val position: Int, val value: Char)

fun main(args: Array<String>) {
    val input = "cxdnnyjw"

    val relevantHashes = (0..Int.MAX_VALUE).asSequence()
        .map { input + it.toString() }
        .map { DigestUtils.md5Hex(it) }
        .filter { it.startsWith("00000") }

    // Part 1
    val result = relevantHashes
        .map { it.toByteArray()[5] }
        .toPassword()

    println(String(result))

    // Part 2
    val result2 = relevantHashes
        .map(String::toCharArray)
        .filter { it[5] in ('0'..'7') }
        .distinctBy { it[5] }
        .take(8)
        .fold(CharArray(8), {
            acc, hash ->
                acc.set(Character.getNumericValue(hash[5]), hash[6])
                acc
            }
        )

    println(result2)
}
