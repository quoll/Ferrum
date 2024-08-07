package ferrum;

public class FerrumEngine implements AutoCloseable {

    static {
        System.loadLibrary("ferrum");
    }

    private long engineHandle;

    public FerrumEngine() {
      this(null);
    }

    public FerrumEngine(String path) {
      engineHandle = init(path);
    }

    private static native long init(String path);

    public void close() {
      close(engineHandle);
    }

    private static native void close(long engineHandle);

    // implement operations

    public native float[] add_vect(float[] a, float[] b);

}
