use crossterm::event::{self, Event, KeyCode};
use crossterm::terminal::{enable_raw_mode, disable_raw_mode};
use std::io::{self, Write};
use std::time::{Duration, Instant};

fn show_actions() {

    println!("\r1. Action 1");
    println!("\r2. Action 2");
    println!("\r0. Exit");

}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    enable_raw_mode()?; // disable line buffering & echo

    show_actions();
    
    let mut running: u64 = 1;
    let mut command_buffer = String::new();
    let mut last_tick = Instant::now();

    print!("\rRun loop: {} | Type command: {}", running, command_buffer);
    io::stdout().flush().unwrap();

    while running > 0 {
        // Poll input without blocking (like select() with timeout=0)
        if event::poll(Duration::from_millis(0))? {
            if let Event::Key(key_event) = event::read()? {
                match key_event.code {
                    KeyCode::Enter => {
                        if command_buffer == "0" {
                            break;
                        }
                    }
                    KeyCode::Backspace => {
                        command_buffer.pop();
                    }
                    KeyCode::Char(c) if c.is_ascii_graphic() || c == ' ' => {
                        command_buffer.push(c);
                    }
                    _ => {}
                }

                print!("\x1B[2K\rRun loop: {} | Type command: {}", running, command_buffer);
                io::stdout().flush().unwrap();
            }
        }

        // Tick once per second
        if last_tick.elapsed() >= Duration::from_secs(1) {
            running += 1;
            print!("\x1B[2K\rRun loop: {} | Type command: {}", running, command_buffer);
            io::stdout().flush().unwrap();
            last_tick = Instant::now();
        }
    }

    disable_raw_mode()?;
    println!("\nExited.");
    Ok(())
}

#[cfg(test)]
mod tests {

    #[test]
    fn testSimple() {
        assert_eq!(1, 1);
    }
}