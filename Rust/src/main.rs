use std::{io::{self, Write}, time::Duration};

use crossterm::{
    event::{self, Event, KeyCode},
    terminal::{disable_raw_mode, enable_raw_mode},
};

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

fn show_actions() {

    println!("\r1. Action 1");
    println!("\r2. Action 2");
    println!("\r0. Exit");

}

fn main() -> Result<()> {
    enable_raw_mode()?; // disable line buffering and echo

    show_actions();

    let mut running = 0;

    loop {

        if event::poll(Duration::from_millis(0))? {

            if let Event::Key(key_event) = event::read()? {
                if key_event.code == KeyCode::Char('0') {
                    print!("\n\r\x1B[2KExit.\n\r");
                    io::stdout().flush().unwrap();
                    break;
                }
            }
        }

        running += 1;
        print!("\r\x1B[2KEvent loop {} | Type command: ", running);    
        io::stdout().flush().unwrap();

        std::thread::sleep(Duration::from_millis(1000));
    }

    disable_raw_mode()?;
    Ok(())
}

#[cfg(test)]
mod tests {

    #[test]
    fn testSimple() {
        assert_eq!(1, 1);
    }
}