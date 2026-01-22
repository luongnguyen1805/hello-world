
#include <iostream>

#include "global.h"

using namespace std;

Global& Global::shared() {
    static Global inst;   // lazy + thread-safe
    return inst;
}

void Global::action1() {
    cout << "\n...Action1...";
}

void Global::action2() {
    cout << "\n...Action2...";
}
    
Global::Global() {
}