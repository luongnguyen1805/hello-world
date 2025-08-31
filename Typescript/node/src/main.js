"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var readline = require("readline");
function showActions() {
    console.log("1. Action 1");
    console.log("2. Action 2");
    console.log("0. Exit");
}
function main() {
    var running = 1;
    var commandBuffer = "";
    var lastTimestamp = Math.floor(Date.now() / 1000);
    // Create readline interface
    var rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
        terminal: true,
    });
    // Enable keypress events
    readline.emitKeypressEvents(process.stdin);
    if (process.stdin.isTTY) {
        process.stdin.setRawMode(true);
    }
    // Show initial actions
    showActions();
    // Handle keypress events
    process.stdin.on("keypress", function (str, key) {
        if (key.name === "return") {
            if (commandBuffer === "0") {
                console.log("Exited.");
                rl.close();
                process.exit(0);
            }
        }
        else if (key.name === "backspace") {
            if (commandBuffer.length > 0) {
                commandBuffer = commandBuffer.slice(0, -1);
            }
        }
        else if (str && /[ -~]/.test(str)) {
            // Matches printable ASCII
            commandBuffer += str;
        }
        // Clear line and update display
        process.stdout.write("\r\x1b[K");
        process.stdout.write("Run loop: ".concat(running, " | Type command: ").concat(commandBuffer));
    });
    // Periodic update every second
    setInterval(function () {
        var currentTimestamp = Math.floor(Date.now() / 1000);
        if (currentTimestamp > lastTimestamp) {
            process.stdout.write("\r\x1b[K");
            process.stdout.write("Run loop: ".concat(running, " | Type command: ").concat(commandBuffer));
            running++;
            lastTimestamp = currentTimestamp;
        }
    }, 100);
}
main();
