package ferrum;

public class ComputeTest {

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

    public static void main(String[] args) {
        float[] a = new float[] {1.0f, 2.0f, 3.0f, 4.0f};
        float[] b = new float[] {5.0f, 6.0f, 7.0f, 8.0f};
        ComputeTest op = new ComputeTest();
        float[] c = op.add(a, b);
        System.out.println("Sum of a and b is: " + toString(c));
    }

    public native float[] add(float[] a, float[] b);

}
