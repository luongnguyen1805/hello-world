class Global {
  action1() {
    console.log('\r...Action1...');
  }

  action2() {
    console.log('\r...Action2...');
  }
}

// Singleton instance (created once per process)
const instance = new Global();

module.exports = instance;