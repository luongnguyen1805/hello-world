import 'dart:io';
import 'dart:async';
import 'dart:convert';

void showActions() {
  print('\r1. Action 1');
  print('\r2. Action 2');
  print('\r0. Exit');
}

void main() {

  stdin.echoMode = false;
  stdin.lineMode = false;

  String commandBuffer = '';
  var running = 0;

  showActions();

  stdin.listen((List<int> data) {
    for (var ch in data) {
      if (ch == 10 || ch == 13) {
        if (commandBuffer == "0") {
          print("\n\rExited.");
          exit(0);
        }

      } else if (ch == 127 || ch == 8) {
        if (commandBuffer.isNotEmpty) {
          commandBuffer = commandBuffer.substring(0, commandBuffer.length - 1);
        }
      } else if (ch >= 32 && ch <= 126) {
        // Printable ASCII
        commandBuffer += String.fromCharCode(ch);
      }

      stdout.write('\x1B[2K\rRun loop: $running | Type command: $commandBuffer');

    }
  });

  //Change period
  Timer.periodic(Duration(seconds: 1), (timer) {
    running++;
    stdout.write('\x1B[2K\rRun loop: $running | Type command: $commandBuffer');
  });
}
