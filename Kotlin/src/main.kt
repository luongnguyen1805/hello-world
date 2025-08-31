
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import org.jline.terminal.TerminalBuilder
import org.jline.terminal.Terminal
import java.io.Closeable

fun showActions() {
    println("1. Action 1")
    println("2. Action 2")
    println("0. Exit")
}

fun main() = runBlocking {

    val terminal: Terminal = TerminalBuilder.builder()
        .system(true)
        .build()
    terminal.enterRawMode() // Enable raw mode for immediate keypresses

    var running = 1
    var commandBuffer = ""
    var lastTimestamp = System.currentTimeMillis() / 1000
    val inputChannel = Channel<Char>(Channel.UNLIMITED)
    
    showActions()

    // Input coroutine (runs on a separate thread)
    val inputJob = Job()
    val inputCoroutine = launch(Dispatchers.IO + inputJob) {
        try {
            val reader = terminal.reader()
            while (isActive) {
                val ch = reader.read().toChar() // Read raw keypress immediately
                inputChannel.send(ch)
            }
        } catch (e: Exception) {
            println("Input error: ${e.message}")
        } finally {
            (terminal as Closeable).close() // Close terminal
            inputChannel.close()
        }
    }

    // Main loop on the main thread
    try {
    while (running > 0) {

        // Process input from the channel
        val result = inputChannel.tryReceive() // Non-blocking tryReceive
        val ch = result.getOrNull() // Get the character or null if no data/closed
        if (ch != null) {
            val chCode = ch.code

            when (chCode) {
                10, 13 -> { // Enter
                    if (commandBuffer == "0") {
                        println("\nExited.")
                        running=-1

                        inputJob.cancel() // Cancel input
                        
                        return@runBlocking // Exit the runBlocking
                    }
                }
                8, 127 -> { // Backspace
                    if (commandBuffer.isNotEmpty()) {
                        commandBuffer = commandBuffer.dropLast(1)
                    }
                }
                else -> if (chCode in 32..126) { // Printable characters with null safety
                    commandBuffer += ch
                }
            }
            print("\r\u001B[KRun loop: $running | Type command: $commandBuffer")
        }

        val currentTimestamp = System.currentTimeMillis() / 1000
        if (currentTimestamp > lastTimestamp) {
            print("\r\u001B[KRun loop: $running | Type command: $commandBuffer")
            running++
            lastTimestamp = currentTimestamp
        }        
    }
    } finally {
        inputJob.cancel()
        (terminal as Closeable).close()
    }

}