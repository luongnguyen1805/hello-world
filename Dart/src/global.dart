class Global {
  Global._();

  static final Global _instance = Global._();

  factory Global() {
    return _instance;
  }

  void action1() {
    print('\n\r...Action1...');
  }

  void action2() {
    print('\n\r...Action2...');
  }
}