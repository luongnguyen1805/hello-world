
use std::sync::OnceLock;

pub struct Global;

impl Global {
    pub fn action1(&self) {
        print!("\n\r...Action1...");
    }

    pub fn action2(&self) {
        print!("\n\r...Action2...");
    }
}

static GLOBAL: OnceLock<Global> = OnceLock::new();

pub fn global_shared() -> &'static Global {
    GLOBAL.get_or_init(|| Global)
}