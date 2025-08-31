const readline = require('readline');

// Create readline interface
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: true
});

// Enable keypress events
readline.emitKeypressEvents(process.stdin);

function showActions() {
    console.log('1. Action 1');
    console.log('2. Action 2');
    console.log('0. Exit');
}

function main() {
    let running = 1;
    let commandBuffer = '';
    let lastTimestamp = Math.floor(Date.now() / 1000);

    // Show initial actions
    showActions();

    // Handle keypress events
    process.stdin.on('keypress', (str, key) => {

        // Handle Enter
        if (key.name === 'return') {
            if (commandBuffer === '0') {
                console.log('Exited.');
                process.exit(0);
            }
        }
        // Handle Backspace
        else if (key.name === 'backspace') {
            if (commandBuffer.length > 0) {
                commandBuffer = commandBuffer.slice(0, -1);
            }
        }
        // Handle printable characters
        else if (str && str.match(/[ -~]/)) { // Matches printable ASCII characters
            commandBuffer += str;
        }

        // Clear line and update display
        process.stdout.write('\r\x1b[K');
        process.stdout.write(`Run loop: ${running} | Type command: ${commandBuffer}`);
    });

    // Periodic update every second
    const interval = setInterval(() => {
        const currentTimestamp = Math.floor(Date.now() / 1000);
        if (currentTimestamp > lastTimestamp) {
            process.stdout.write('\r\x1b[K');
            process.stdout.write(`Run loop: ${running} | Type command: ${commandBuffer}`);
            running++;
            lastTimestamp = currentTimestamp;
        }
    }, 100);
}

main();