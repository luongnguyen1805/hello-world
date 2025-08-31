import * as readline from "readline";

function showActions(): void {
  console.log("1. Action 1");
  console.log("2. Action 2");
  console.log("0. Exit");
}

function main(): void {
  let running = 1;
  let commandBuffer = "";
  let lastTimestamp = Math.floor(Date.now() / 1000);

  // Create readline interface
  const rl = readline.createInterface({
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
  process.stdin.on(
    "keypress",
    (str: string, key: readline.Key) => {
      if (key.name === "return") {
        if (commandBuffer === "0") {
          console.log("Exited.");
          rl.close();
          process.exit(0);
        }
      } else if (key.name === "backspace") {
        if (commandBuffer.length > 0) {
          commandBuffer = commandBuffer.slice(0, -1);
        }
      } else if (str && /[ -~]/.test(str)) {
        // Matches printable ASCII
        commandBuffer += str;
      }

      // Clear line and update display
      process.stdout.write("\r\x1b[K");
      process.stdout.write(
        `Run loop: ${running} | Type command: ${commandBuffer}`
      );
    }
  );

  // Periodic update every second
  setInterval(() => {
    const currentTimestamp = Math.floor(Date.now() / 1000);
    if (currentTimestamp > lastTimestamp) {
      process.stdout.write("\r\x1b[K");
      process.stdout.write(
        `Run loop: ${running} | Type command: ${commandBuffer}`
      );
      running++;
      lastTimestamp = currentTimestamp;
    }
  }, 100);
}

main();
