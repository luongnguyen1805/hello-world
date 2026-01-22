public final class Global {

    // Private constructor prevents external instantiation
    private Global() {}

    // Singleton holder
    private static class Holder {
        private static final Global INSTANCE = new Global();
    }

    // Global access point
    public static Global shared() {
        return Holder.INSTANCE;
    }

    public void action1() {
        System.out.printf("\n\r...Action1...");
    }

    public void action2() {
        System.out.printf("\n\r...Action2...");
    }
}
