
#ifndef GLOBAL_H
#define GLOBAL_H

class Global {
public:
    static Global& shared();

    void action1();
    void action2();

private:
    Global();
    Global(const Global&) = delete;
    Global& operator=(const Global&) = delete;
};

#endif // GLOBAL_H