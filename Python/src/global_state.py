import sys

class GlobalState:
    def action1(self):
        sys.stdout.write("\n\r...Action1...")

    def action2(self):
        sys.stdout.write("\n\r...Action2...")

global_state = GlobalState()