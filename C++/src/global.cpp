
#include <iostream>
#include <filesystem>
#include <system_error>
#include <mach-o/dyld.h>

#include "global.h"

using namespace std;

std::filesystem::path get_executable_dir() {
    char buf[PATH_MAX];
    uint32_t size = sizeof(buf);

    if (_NSGetExecutablePath(buf, &size) != 0) {
        throw std::runtime_error("Executable path buffer too small");
    }

    std::filesystem::path p(buf);

    // Try to canonicalize, but do not fail hard
    std::error_code ec;
    p = std::filesystem::weakly_canonical(p, ec);

    return p.parent_path();
}

Global& Global::shared() {
    static Global inst;   // lazy + thread-safe
    return inst;
}

void Global::action1() {
    cout << "\n...Action...";
}

void Global::action2() {
    auto exe_dir = get_executable_dir();
    cout << "\nExecutable directory: " << exe_dir;
}
    
Global::Global() {
}