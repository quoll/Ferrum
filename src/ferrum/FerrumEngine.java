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

    public float[] vect_bbB(String fn, float[] a, float[] b) {
        return vect_bbB(fn, a, 0, 1, b, 0, 1);
    }

    public native float[] vect_bbB(String fn,
                                   float[] a, int offset_a, int stride_a,
                                   float[] b, int offset_b, int stride_b);

}
