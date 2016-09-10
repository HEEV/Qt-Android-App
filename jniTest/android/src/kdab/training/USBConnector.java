package com.kdab.training;

import android.hardware.usb.*;
import android.util.Log;
import java.util.*;

public class USBConnector
{
    private static UsbManager manager;

    public static int printDeviceList(int i)
    {
        /*manager = (UsbManager) getSystemService(USB_SERVICE);
        HashMap<String, UsbDevice> deviceList = manager.getDeviceList();
        Iterator<UsbDevice> deviceIterator = deviceList.values().iterator();

        while(deviceIterator.hasNext())
        {
            UsbDevice device = deviceIterator.next();

            Log.d("QTApp", "Found a device: " + device);

            //manager.requestPermission(device, mPermissionIntent);
        }*/
        return 1;
    }


    public static int fibonacciJava(int n)
    {
        if(n < 2)
        {
            return n;
        }
        else
        {
            return 12+55;
        }

        //return fibonacciJava(n-1) + fibonacciJava(n-2);
    }

}




/*
public class MyActivity extends QtActivity
{
    private static MyActivity m_instance;
    private UsbAccessory accessory;
    private String TAG = "TAG";
    private static final String ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION";
    private PendingIntent mPermissionIntent;
    private UsbManager manager;
    private UsbDeviceConnection connection;
    private HashMap<Integer, Integer> connectedDevices;

    public MyActivity()
    {
        m_instance = this;

        connectedDevices = new HashMap<Integer, Integer>();
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        manager = (UsbManager) getSystemService(Context.USB_SERVICE);

        registerReceiver(usbManagerBroadcastReceiver, new IntentFilter(UsbManager.ACTION_USB_DEVICE_ATTACHED));
        registerReceiver(usbManagerBroadcastReceiver, new IntentFilter(UsbManager.ACTION_USB_DEVICE_DETACHED));
        registerReceiver(usbManagerBroadcastReceiver, new IntentFilter(ACTION_USB_PERMISSION));

        mPermissionIntent = PendingIntent.getBroadcast(this, 0, new Intent(ACTION_USB_PERMISSION), 0);

        final Handler handler = new Handler();

        handler.postDelayed(new Runnable()
        {
            @Override
            public void run()
            {
                checkForDevices();
            }
        }, 1000);
    }

    @Override
    public void onDestroy()
    {
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);
    }

    private static native void notifyDeviceAttached(int fd);
    private static native void notifyDeviceDetached(int fd);

    private final BroadcastReceiver usbManagerBroadcastReceiver = new BroadcastReceiver()
    {
        public void onReceive(Context context, Intent intent)
        {
            try
            {
                String action = intent.getAction();

                Log.d(TAG, "INTENT ACTION: " + action);

                if (ACTION_USB_PERMISSION.equals(action))
                {
                    Log.d(TAG, "onUsbPermission");

                    synchronized (this)
                    {
                        UsbDevice device = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);

                        if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false))
                        {
                            if(device != null)
                            {
                                int fd = connectToDevice(device);
                                Log.d(TAG,"device file descriptor: " + fd);
                                notifyDeviceAttached(fd);
                            }
                        }
                        else
                        {
                            Log.d(TAG, "permission denied for device " + device);
                        }
                    }
                }

                if (UsbManager.ACTION_USB_DEVICE_ATTACHED.equals(action))
                {
                    Log.d(TAG, "onDeviceConnected");

                    synchronized(this)
                    {
                        UsbDevice device = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);

                        if (device != null)
                        {
                            manager.requestPermission(device, mPermissionIntent);
                        }
                    }
                }

                if (UsbManager.ACTION_USB_DEVICE_DETACHED.equals(action))
                {
                    Log.d(TAG, "onDeviceDisconnected");

                    synchronized(this)
                    {
                        UsbDevice device = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);

                        int fd = connectedDevices.get(device.getDeviceId());

                        Log.d(TAG, "device: " + device.getDeviceId() + " disconnected. fd: " + fd);

                        notifyDeviceDetached(fd);

                        connectedDevices.remove(device.getDeviceId());
                    }
                }
            }
            catch(Exception e)
            {
                Log.d(TAG, "Exception: " + e);
            }
        }
    };

    private int connectToDevice(UsbDevice device)
    {
        connection = manager.openDevice(device);
        // if we make this, kernel driver will be disconnected
        connection.claimInterface(device.getInterface(0), true);

        Log.d(TAG, "inserting device with id: " + device.getDeviceId() + " and file descriptor: " + connection.getFileDescriptor());
        connectedDevices.put(device.getDeviceId(), connection.getFileDescriptor());

        return connection.getFileDescriptor();
    }

    private void checkForDevices()
    {
        HashMap<String, UsbDevice> deviceList = manager.getDeviceList();
        Iterator<UsbDevice> deviceIterator = deviceList.values().iterator();

        while(deviceIterator.hasNext())
        {
            UsbDevice device = deviceIterator.next();

            if (device.getVendorId()==VID && device.getProductId()==PID)
            {
                Log.d(TAG, "Found a device: " + device);

                manager.requestPermission(device, mPermissionIntent);
            }
        }
    }
}*/
