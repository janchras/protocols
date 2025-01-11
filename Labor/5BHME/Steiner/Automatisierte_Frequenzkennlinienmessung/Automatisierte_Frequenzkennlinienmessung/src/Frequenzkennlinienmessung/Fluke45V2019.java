package Frequenzkennlinienmessung;

import com.fazecast.jSerialComm.SerialPort;
import java.util.List;


public class Fluke45V2019 implements AutoCloseable
{
    private final SimpleSerialV2019 simpleSerial;
    /**
     * Creates a new instance of Fluke45
     * @param name
     * @throws java.lang.Exception
     */
    public Fluke45V2019(String name) throws Exception
    {
        simpleSerial = new SimpleSerialV2019(name);
        simpleSerial.open();
        simpleSerial.setComPortParameters(
            9600,8,SerialPort.ONE_STOP_BIT,SerialPort.NO_PARITY);
        simpleSerial.setComPortTimeouts(
            SerialPort.TIMEOUT_READ_SEMI_BLOCKING,5000,5000);
     }
    
   
    public double getValue() throws Exception
    {
        String s = simpleSerial.readLine();
        simpleSerial.write("VAL?\n");
        String s2 = simpleSerial.readLine();
        String s3 = simpleSerial.readLine();
/*
        System.out.println(s);
        System.out.println(s2);
        System.out.println(s3);
*/        
        double value = Double.parseDouble(s2);
        return value;
    }

    @Override
    public void close() throws Exception
    {
        simpleSerial.close();
    }
    
    
    
    public static void main(String[] args)
    {
        final List<String> ports = SimpleSerialV2019.findSerialPorts();
        System.out.println("Anzahl seriellen Ports: "+ports.size());
        for(String port:ports)
        {
            System.out.println(port);
        }
        
        try(Fluke45V2019 mg1 = new Fluke45V2019("COM12"))
        {         
            for(int i=0;i<10;i++)
            {
                double value = mg1.getValue();
                System.out.format("%d: %.03f%n",i+1,value);
                Thread.sleep(1000);
            }
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
}
