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

    public float[] vect_bB(String fn, float[] a) {
        return vect_bB(fn, a, 0, 1);
    }

    public float[] vect_bfB(String fn, float[] a, float sa) {
        return vect_bfB(fn, a, 0, 1, sa);
    }

    public float[] vect_fbB(String fn, float sa, float[] a) {
        return vect_fbB(fn, sa, a, 0, 1);
    }

    public float[] vect_bbB(String fn, float[] a, float[] b) {
        return vect_bbB(fn, a, 0, 1, b, 0, 1);
    }

    public float[] vect_bBB(String fn, float[] a, float[] b) {
        return vect_bBB(fn, a, 0, 1, b, 0, 1);
    }

    public float[] vect_bffffB(String fn, float[] a, float sa, float sha, float sb, float shb) {
        return vect_bffffB(fn, a, 0, 1, sa, sha, sb, shb);
    }

    public float[] vect_bbffffB(String fn, float[] a, float[] b, float sa, float sha, float sb, float shb) {
        return vect_bbffffB(fn, a, 0, 1, b, 0, 1, sa, sha, sb, shb);
    }

    public native float[] vect_bB(String fn, float[] a, int offset_a, int stride_a);

    public native float[] vect_bfB(String fn, float[] a, int offset_a, int stride_a, float sa);

    public native float[] vect_fbB(String fn, float sa, float[] a, int offset_a, int stride_a);

    public native float[] vect_bbB(String fn,
                                   float[] a, int offset_a, int stride_a,
                                   float[] b, int offset_b, int stride_b);

    public native float[] vect_bBB(String fn,
                                   float[] a, int offset_a, int stride_a,
                                   float[] b, int offset_b, int stride_b);

    public native float[] vect_bffffB(String fn,
                                      float[] a, int offset_a, int stride_a,
                                      float sa, float sha,
                                      float sb, float shb);

    public native float[] vect_bbffffB(String fn,
                                       float[] a, int offset_a, int stride_a,
                                       float[] b, int offset_b, int stride_b,
                                       float sa, float sha,
                                       float sb, float shb);
}
