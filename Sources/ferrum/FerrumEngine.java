package ferrum;

public class FerrumEngine {

    static {
        System.loadLibrary("ferrum");
    }

    public static String toString(float[] x) {
      String s = "[";
      for (int i = 0; i < x.length; i++) {
        s += x[i];
        if (i < x.length - 1) {
          s += ", ";
        }
      }
      return s + "]";
    }

    public native float[] add_vect(float[] a, float[] b);

}
