package _5AHMIA.lab1;

import gnu.io.*;
import java.io.*;
import java.util.*;

public class SerialInterfaceV2013
{
    private CommPortIdentifier portIdentifier = null;
    private SerialPort         port = null;
    protected OutputStream       os = null;
    private OutputStreamWriter osw = null;
    private BufferedWriter     bw = null;
    protected InputStream        is = null;
    private InputStreamReader  isr = null;
    private BufferedReader     br = null;
    
    public SerialInterfaceV2013(String name) throws Exception
    {
        Enumeration e =  CommPortIdentifier.getPortIdentifiers();
        while (e.hasMoreElements())
        {
            CommPortIdentifier cpi = (CommPortIdentifier)e.nextElement();
//            System.out.println(cpi.getName());
            if (cpi.getPortType()==CommPortIdentifier.PORT_SERIAL)
                if (cpi.getName().equalsIgnoreCase(name))
                {
                    portIdentifier = cpi;
                    break;
                }
        }
        if (portIdentifier==null)
            throw new Exception("port not found!");
    }
    
    static Vector<String> getAllInterfaces()
    {
        Vector<String> v = new Vector<String>();
        Enumeration e =  CommPortIdentifier.getPortIdentifiers();
        while (e.hasMoreElements())
        {
            CommPortIdentifier cpi = (CommPortIdentifier)e.nextElement();
 //           System.out.println(cpi.getName());
            if (cpi.getPortType()==CommPortIdentifier.PORT_SERIAL)
            {
                v.add(cpi.getName());
            }
        }
        
        return v;
    }
    
    public void open() throws Exception
    {
        if (port!=null)
            close();
        port = (SerialPort)portIdentifier.open("SerialInterface",3000);
        port.enableReceiveTimeout(3000);
        os = port.getOutputStream();
        is = port.getInputStream();
        
        osw = new OutputStreamWriter(os);
        bw = new BufferedWriter(osw);
        
        isr = new InputStreamReader(is);
        br = new BufferedReader(isr);
    }
    
    public void close()
    {
        if (port!=null)
        {
            port.close();
            port=null;
        }
    }
    
    public void write(byte[] buffer) throws Exception
    {
        os.write(buffer);
        os.flush();
    }
    
    public void write(String s) throws Exception
    {
        bw.write(s);
        bw.flush();
    }
    
    public String readLine() throws Exception
    {
        return(br.readLine());
    }
    
    public byte[] read(int len) throws Exception
    {
        int isLen;
        byte[] buffer = new byte[len];
        if ((isLen=is.read(buffer,0,len))<len)
            throw new Exception("timeout occured!("+len+","+isLen+")");
        return buffer;
    }
    
    public void setSerialPortParams(int baudrate,int dataBits,
            int stopBits,int parity)
            throws UnsupportedCommOperationException
    {
        if (port!=null)
            port.setSerialPortParams(baudrate,dataBits,stopBits,parity);
    }
    
    public void setDTR(boolean b)
    {
        if(port!=null)
            port.setDTR(b);
    }
    
    public void setRTS(boolean b)
    {
        if(port!=null)
            port.setRTS(b);
    }
    
    public void clear() throws Exception
    {
        while (is.available()!=0)
            is.read();
    }
}
