// java file android-sources/src/com/interface/usb/UsbJavaInterface.java
package src.com.interface.usb;

public class UsbJavaInterface
{
    // this method will be called from C/C++
    public static int fibonacci(int n)
    {
        if (n < 2)
            return n;
        return fibonacci(n-1) + fibonacci(n-2);
    }
}
