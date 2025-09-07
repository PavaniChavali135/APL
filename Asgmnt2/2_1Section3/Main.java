// A simple class to represent an object
class Data {
    private int[] data = new int[1000]; // Allocates a block of memory

    public Data(int id) {

        if (data.length > 0) {
            data[0] = id;
        }
    }

    public int getFirstElement() {
        return data.length > 0 ? data[0] : -1;
    }
}

public class Main {
    public static void main(String[] args) {

        // Allocate many objects.
        for (int i = 0; i < 10000; i++) {
            new Data(i);
        }

        System.gc();

        System.out.println("Program finished. The JVM will handle memory cleanup as needed.");
    }
}
