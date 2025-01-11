package _5BHMIA.lab5.ue01Messgeraete;

import gnu.io.*;

public class Fluke45 extends SerialInterface
{
    String data;
    
    /**
     * Creates a new instance of Fluke45
     */
    public Fluke45(String name) throws Exception
    {
        super(name);
        open();
        setSerialPortParams(9600,SerialPort.DATABITS_8,
                SerialPort.STOPBITS_1,SerialPort.PARITY_NONE);
     }
    
   
    public double getValue() throws Exception
    {
        write("VAL?\n");
        String s = readLine();
        String s2 = readLine();
        String s3 = readLine();
/*
        System.out.println(s);
        System.out.println(s2);
        System.out.println(s3);
*/        
        double value = Double.parseDouble(s2);
        return value;
    }
    
    public static void main(String[] args)
    {
        Fluke45 mg1=null;
        try
        {
            mg1 = new Fluke45("COM7");
            mg1.clear();
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
        finally
        {
            if(mg1!=null)
            {
                mg1.close();
            }
        }
    }
}
