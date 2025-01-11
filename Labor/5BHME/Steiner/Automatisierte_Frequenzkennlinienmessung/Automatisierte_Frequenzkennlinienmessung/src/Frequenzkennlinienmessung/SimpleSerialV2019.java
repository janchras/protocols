/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Frequenzkennlinienmessung;

import com.fazecast.jSerialComm.SerialPort;
import java.io.*;
import java.util.*;

/**
 *
 * @author Steiner
 */
public class SimpleSerialV2019
{
    private final SerialPort serialPort;
    private InputStream inputStream;
    private OutputStream outputStream;
    private BufferedWriter writer;
    private BufferedReader reader;
    

    public SimpleSerialV2019(String portName)
    {
        serialPort = SerialPort.getCommPort(portName);
    }
    
    public void open() throws Exception
    {
        if(!serialPort.openPort())
            throw new Exception("error on opening port "+ serialPort.getSystemPortName());
        writer = new BufferedWriter(new OutputStreamWriter(
            outputStream=serialPort.getOutputStream(),"utf8"));
        reader = new BufferedReader(new InputStreamReader(
            inputStream=serialPort.getInputStream(),"utf8"));
    }
    
    public void write(String text) throws Exception
    {
        writer.write(text);
        writer.flush();
    }
    
    public String readLine()throws Exception
    {
        return reader.readLine();
    }
    
    public void close() throws Exception
    {
        if(!serialPort.closePort())
            throw new Exception(
                "error on closing port "+serialPort.getSystemPortName());
    }

    public final void setComPortParameters(
        int newBaudRate, int newDataBits, int newStopBits, int newParity)
    {
        serialPort.setComPortParameters(
            newBaudRate, newDataBits, newStopBits, newParity);
    }

    public final void setComPortTimeouts(
        int newTimeoutMode, int newReadTimeout, int newWriteTimeout)
    {
        serialPort.setComPortTimeouts(
            newTimeoutMode, newReadTimeout, newWriteTimeout);
    }

    public InputStream getInputStream()
    {
        return inputStream;
    }

    public OutputStream getOutputStream()
    {
        return outputStream;
    }

    public BufferedWriter getWriter()
    {
        return writer;
    }

    public BufferedReader getReader()
    {
        return reader;
    }
    
    
    
    public static List<String> findSerialPorts()
    {
        final List<String> liste = new ArrayList<>();      
        final SerialPort[] ports = SerialPort.getCommPorts();
        
        for(SerialPort port:ports)
        {
            liste.add(port.getSystemPortName());
        }
        
        return liste;
    }

    
    
    
    public static void main(String[] args)
    {
        List<String> liste = findSerialPorts();
        
        System.out.println("Anzahl Ports: "+ liste.size());
        for(String port:liste)
        {
            System.out.println(port);
        }
    }
}
