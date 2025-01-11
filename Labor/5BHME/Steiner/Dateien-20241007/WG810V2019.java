package labor.lab5.serial;

import com.fazecast.jSerialComm.SerialPort;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;


//import javax.comm.*;
/** Fehlerliste<BR>
 *  10.11.2005: getOffset(): negative Offsets korrigiert
 *  26.10.2007: setKurvenform(char form, boolen visible) ergänzt
 * 
 *  23.10.2013: WG810V2013a erstellt wegen Schnittstellenproblemen
 *  23.10.2013: read (7x1 Byte lesen --> 32 Bit OK)
 * 
 *  10.10.2019: Umbau auf has a SimpleSerial 
 */
public class WG810V2019 implements AutoCloseable
{
    private byte paramSend[];
    private byte paramRead[]; 
    
    public static final char OFFSETSIGPOS = 'p';
    public static final char OFFSETSIGNEG = 'n';
    public static final char OFFSETSIGPOSNEG = 'x';
    
    public static final int MODNONE = 0;
    public static final int MODFM = 1;
    public static final int MODAM = 2;
    
    public static final char TRIGCONT = 'c';
    public static final char TRIGONESHOT = 'n';
    public static final char TRIGONESHOTANDTRIG = 'N';
    public static final char TRIGEXT = 'e';
    
    public static final char FORMSIN = 'S';
    public static final char FORMRECT = 'R';
    public static final char FORMTRI = 'T';
    public static final char FORMARBMORPH = 'D';
    public static final char FORMDC = 'G';
    public static final char FORMNOISE = 'N';

    public static final int OUTPUTOFF = 0;
    public static final int OUTPUTM20DB = 1;
    public static final int OUTPUT0DB = 2;

    public static final char CLKINTERN = 'i';
    public static final char CLKSINGLE = 's';
    public static final char CLKSINGLEANDCLOCK = 'S';
    public static final char CLKEXTERN = 'e';
    public static final char CLKSINGLEANDRESETANDCLOCK = 'z';
    
    public static final char MORPHMANUAL = 'm';
    public static final char MORPHEXTERN = 'e';
    public static final char MORPHTIME = 't';
    
    public static final int BITS8 = 8;
    public static final int BITS12 = 12;
    public static final int BITS16 = 16;
    
    private final SimpleSerialV2019 simpleSerial;
    private final InputStream is;
    private final OutputStream os;

    
    public WG810V2019(String name) throws Exception
    {
        simpleSerial = new SimpleSerialV2019(name);
        simpleSerial.open();
        simpleSerial.setComPortParameters(
            57600,8,SerialPort.ONE_STOP_BIT,SerialPort.NO_PARITY);
        simpleSerial.setComPortTimeouts(
            SerialPort.TIMEOUT_READ_SEMI_BLOCKING,5000,5000);
        paramSend = new byte[7];
        paramRead = new byte[7];
        
        is = simpleSerial.getInputStream();
        os = simpleSerial.getOutputStream();
    }
/*    
    @Override
    public byte[] read(int len) throws Exception
    {
        final byte[] buffer = new byte[len];
        int ret;
        try
        {
            if((ret=is.read(buffer,0,1))<1)
            {
                System.out.println("ret="+ret);
            }
        }
        catch (Exception ignore)
        {
            System.out.println("ignore");
        }
        
        if((ret=is.read(buffer,1,len-1))<(len-1))
        {
            System.out.println("ret="+ret+" :len="+len);
            throw new Exception ("timeout occured!!");    
        }
        
        return buffer;
    }
*/
    
    public byte[] read(int len) throws Exception
    {
        final byte[] buffer = new byte[len];
        int ret;

        for(int i=0;i<len;i++)
        {
            try
            {
                if((ret=is.read(buffer,i,1))<1)
                {
                    System.out.println("ret="+ret);
                }
            }
            catch (Exception ignore)
            {
                System.out.println("ignore");
            }
        }
        
        return buffer;
    }
    
    private byte getCRC(byte[] par)
    {
        return (byte)(par[1]^par[2]^par[3]^par[4]^par[5]);
    }
    
    private void printDebug(byte par[], boolean character)
    {
        for( int i=0; i<par.length; i++)
            if(character)
                System.out.print(((char)par[i])+" ");
            else    
                System.out.print(((int)par[i])+" ");
        System.out.println();
    }
    
    
    public void setRemote(boolean remote) throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'R';
        paramSend[2] = remote ? (byte)0 : (byte)1;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        printDebug(paramSend,true);
//        printDebug(paramRead,true);
    }
    
    public boolean getRemote() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'r';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
 
//        printDebug(paramSend,true);
//        printDebug(paramRead,true);
        return (paramRead[2]=='0');
    }
    
    public void setDefault() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'S';
        paramSend[2] = (byte)'D';
        paramSend[3] = (byte)'e';
        paramSend[4] = (byte)'f';
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        try
        {
            paramRead = read(7);
        }
        catch (Exception e)
        {
        }
    }
    
    public String getTyp() throws Exception
    {
        String str;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'&';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        int wert = paramRead[2]*256 + paramRead[3];
        str = "WG";
        str += wert;
        str += ", " + paramRead[4] + " Kanäle, ";
        str += paramRead[5] == 'm' ? "Morphing möglich" : "kein Morphing möglich";
        return str;
    }
    
    public int getKanalAnzahl() throws Exception
    {
        String str;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'!';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        
        return paramRead[5];
    }
    
    public String getFirmware() throws Exception
    {
        String str="";
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'e';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        
        str += (char)paramRead[2];
        str += (char)paramRead[3];
        str += (char)paramRead[4];
        str += (char)paramRead[5];
        
        return str;
    }
    
    public void setFrequenz(double freq, boolean visible) throws Exception
    {
        int exp = 3;
        int ifreq;
        while(freq >= 10000)
        {
            freq/=10;
            exp++;
        }
        
        while(freq<1000)
        {
            freq*=10;
            exp--;
        }
        ifreq = (int)freq;
        
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'F';
        paramSend[2] = (byte)(ifreq/256);
        paramSend[3] = (byte)(ifreq%256);
        paramSend[4] = (byte)exp;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }
    
    public double getFrequenz() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'f';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        int hi = (int)paramRead[2];if(hi<0) hi+=256;
        int lo = (int)paramRead[3]; if(lo<0) lo+=256;
        int pow = (int)paramRead[4]; if(pow<0) pow +=256;
        
        double wert = hi*256 + lo;
        wert *= Math.pow(10, pow-3);
        return wert;
    }
    
    public void setAmplitude(double amplitude, boolean visible) throws Exception
    {
        int iAmplitude = (int)(amplitude*1000);
        
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'A';
        paramSend[2] = (byte)(iAmplitude/256);
        paramSend[3] = (byte)(iAmplitude%256);
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public double getAmplitude() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'a';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        int hi = (int)paramRead[2];if(hi<0) hi+=256;
        int lo = (int)paramRead[3]; if(lo<0) lo+=256;
        
        return ((double)hi*256 + lo)/1000;
    }
    
    public void setOffset(double offset, boolean visible) throws Exception
    {
        int iOffset = (int)(offset*1000);
        
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'O';
        paramSend[2] = (byte)(iOffset/256);
        paramSend[3] = (byte)(iOffset%256);
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public double getOffset() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'o';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        int hi = (int)paramRead[2];
        int lo = (int)paramRead[3]; if(lo<0) lo+=256;
        
//        this.printDebug(paramRead, false);
        
        return ((double)hi*256 + lo)/1000;
    }

    public void setFilter(boolean filter, boolean visible) throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'G';
        paramSend[2] = (byte)(filter?1:0);
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public boolean getFilter() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'g';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        
        return paramRead[2] == 1;
    }

    public void setOffsetMode(char mode, boolean visible) throws Exception
    {
        if(mode != this.OFFSETSIGPOS && mode != this.OFFSETSIGNEG && mode !=this.OFFSETSIGPOSNEG)
            throw new Exception("falscher Offsetmode!!");
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'W';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        byte bmode=(byte)mode;
        if(visible)
            bmode-=128;
        paramSend[5] = bmode;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public char getOffsetMode() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'w';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        
        return (char)paramRead[5];
    }
    
    public void setDutyCycle(int prozent, boolean visible) throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'D';
        paramSend[2] = (byte)prozent;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }
    
    public int getDutyCycle() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'d';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        return (int)paramRead[2];
    }
    
    public void setSyncPosition(int position, boolean visible) throws Exception
    {
        byte lo = (byte)position;
        position /= 256;
        byte mi = (byte)position;
        position /= 256;
        byte hi = (byte)position;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'Z';
        paramSend[2] = (byte)hi;
        paramSend[3] = (byte)mi;
        paramSend[4] = (byte)lo;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        this.printDebug(paramSend,true);
    }

    public int getSyncPosition() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'z';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        int hi = (int)paramRead[2]; if(hi<0) hi+=256;
        int mi = (int)paramRead[3]; if(mi<0) mi+=256;
        int lo = (int)paramRead[4]; if(lo<0) lo+=256;
        
        return (hi*256+mi)*256 + lo;
    }
    
    public void setModulation(int modulation, boolean visible) throws Exception
    {
        if(modulation != this.MODNONE && modulation != this.MODAM && modulation !=this.MODFM)
            throw new Exception("falsche Modulation!!");
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'M';
        paramSend[2] = (byte)modulation;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public int getModulation() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'m';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        return (int)paramRead[2];
    }

    public void setTriggerModus(char trigger, boolean visible) throws Exception
    {
        if(trigger != this.TRIGCONT && trigger != this.TRIGONESHOT && trigger != this.TRIGONESHOTANDTRIG && trigger != this.TRIGEXT)
            throw new Exception("falscher Triggermode!!");
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'T';
        paramSend[2] = (byte)trigger;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public char getTriggerModus() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'t';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        return (char)paramRead[2];
    }

    public void setKurvenform(char form, boolean visible) throws Exception
    {
        setKurvenform(form,0,visible);
    }
    
    public void setKurvenform(char form, int nr, boolean visible) throws Exception
    {
        if(form != this.FORMSIN && form != this.FORMRECT && form != this.FORMTRI && 
           form != this.FORMARBMORPH && form != this.FORMDC && form != this.FORMNOISE)
            throw new Exception("falsche Kurvenform");
        
        if(form == WG810V2019.FORMARBMORPH)
            if(nr<1 || nr>7)
                throw new Exception("falsche Kurvennummer");
        
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'K';
        paramSend[2] = (byte)form;
        paramSend[3] = (byte)(form==WG810V2019.FORMARBMORPH ? nr : 0);
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        Thread.sleep(2000);
        try
        {
            paramRead = read(7);
        }
        catch(Exception e)
        {
        }
    }
    
    public char getKurvenform() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'k';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        char ret = (char)paramRead[2];
        
        if(ret==WG810V2019.FORMARBMORPH)
            ret=(char)(paramRead[3]+48);
        
        return ret;
    }
   
    public void setAusgangsModus(int modus, boolean visible) throws Exception
    {
        if(modus != this.OUTPUTOFF && modus != this.OUTPUTM20DB && modus !=this.OUTPUT0DB)
            throw new Exception("falscher Ausgangsmodus!!");
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'Q';
        paramSend[2] = (byte)modus;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)(visible?-1:0);
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }

    public int getAusgangsModus() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'q';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        return (int)(paramRead[2]-48);
    }

    public void setClockSource(char source, boolean visible) throws Exception
    {
        if(source !=  this.CLKINTERN && source != this.CLKSINGLE && source !=this.CLKSINGLEANDCLOCK &&
           source != this.CLKEXTERN && source != this.CLKSINGLEANDRESETANDCLOCK)
            throw new Exception("falsche Taktquelle!!");
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'P';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        byte bsource = (byte)source;
        if(visible)
            bsource -= 128;
        paramSend[5] = (byte)bsource;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
    }
        
    public char getClockSource() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'p';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);

        return (char)(paramRead[5]);
    }

    public void setMorphingParameter(char par, int nr, boolean visible) throws Exception
    {
        if(par !=  WG810V2019.MORPHMANUAL && par != WG810V2019.MORPHEXTERN && par !=WG810V2019.MORPHTIME)
            throw new Exception("falscher Morphing Parameter!!");
        if(par == WG810V2019.MORPHEXTERN)
            nr=0;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'[';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)nr;
        byte bpar = (byte)par;
        if(visible)
            bpar -= 128;
        paramSend[5] = (byte)bpar;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        
        this.printDebug(paramSend,true);
        this.printDebug(paramRead,true);
    }
    
    public String getMorphingParameter() throws Exception
    {
        String str = "";
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)']';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
        
        this.printDebug(paramSend,true);
        this.printDebug(paramRead,true);

        int par3 = (int)paramRead[4];
        if(par3 < 0)
            par3+=256;

        if(paramRead[5] == WG810V2019.MORPHEXTERN)
            str = "e";
        
        if(paramRead[5] == WG810V2019.MORPHMANUAL)
            str = "m" + par3;
        
        if(paramRead[5] == WG810V2019.MORPHTIME)
            str = "t" + par3;
        
        return str;
    }
    
    public void startProgrammierung(int position, int nr) throws Exception
    {
        byte lo = (byte)position;
        position /= 256;
        byte mi = (byte)position;
        position /= 256;
        byte hi = (byte)position;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'B';
        paramSend[2] = (byte)hi;
        paramSend[3] = (byte)mi;
        paramSend[4] = (byte)lo;
        paramSend[5] = (byte)nr;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        this.printDebug(paramSend,true);
    }
    
    public boolean getStartFertig(int position, int nr) throws Exception
    {
        byte lo = (byte)position;
        position /= 256;
        byte mi = (byte)position;
        position /= 256;
        byte hi = (byte)position;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'b';
        paramSend[2] = (byte)hi;
        paramSend[3] = (byte)mi;
        paramSend[4] = (byte)lo;
        paramSend[5] = (byte)nr;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        this.printDebug(paramSend,true);
        
        return paramRead[5] == 1;
    }
    
    public void stopProgrammierung(int position, int nr) throws Exception
    {
        byte lo = (byte)position;
        position /= 256;
        byte mi = (byte)position;
        position /= 256;
        byte hi = (byte)position;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'U';
        paramSend[2] = (byte)hi;
        paramSend[3] = (byte)mi;
        paramSend[4] = (byte)lo;
        paramSend[5] = (byte)nr;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        this.printDebug(paramSend,true);
    }
    
    public boolean getStopFertig(int position, int nr) throws Exception
    {
        byte lo = (byte)position;
        position /= 256;
        byte mi = (byte)position;
        position /= 256;
        byte hi = (byte)position;
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'u';
        paramSend[2] = (byte)hi;
        paramSend[3] = (byte)mi;
        paramSend[4] = (byte)lo;
        paramSend[5] = (byte)nr;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        this.printDebug(paramSend,true);
        
        return paramRead[5] == 1;
    }
    
    public void setMorphModus(int nr) throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'*';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)nr;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        this.printDebug(paramSend,true);
    }
    
/** Diese Funktion wurde aus zus�tzlicher Dokumentation ennommen
     * @throws java.lang.Exception
 */    
    public void setProgrammierModus() throws Exception
    {
        paramSend[0] = (byte)'X';
        paramSend[1] = (byte)'C';
        paramSend[2] = (byte)0;
        paramSend[3] = (byte)0;
        paramSend[4] = (byte)0;
        paramSend[5] = (byte)0;
        paramSend[6] = getCRC(paramSend);
        
        os.write(paramSend);
        paramRead = read(7);
//        this.printDebug(paramSend,true);
//        this.printDebug(paramRead,true);
    }
    
    /** Achtung: Diese Methode funtioniert noch nicht!!! <BR>
     *           Bei Aufruf wird die Sinus Kurvenform zerst�rt bis zum Aus- und Einschalten!!!
     * @param data
     * @param nr
     * @param bits
     * @throws java.lang.Exception
     */
    public void progKurve(int []data, int nr, int bits) throws Exception
    {
            boolean ok=false;
            setProgrammierModus();
            try
            {
                startProgrammierung(3,1);
            }
            catch (Exception e)
            {
            }
            do
            {
                ok=getStartFertig(3, 2*data.length);
            }
            while(!ok);
            
            sendKurve(data, bits);
            Thread.sleep(500);
            try
            {
                stopProgrammierung(3, 1);
            }
            catch(Exception e)
            {
            }
            
            do
            {
                getStopFertig(3, 2*data.length);
            }
            while(!ok);
    }
    
    public void sendKurve(int f[], int bit) throws Exception
    {
        for(int i=0; i<f.length; i++)
        {
            if(bit==8)
                f[i] <<= 8;
            if(bit==12)
                f[i] <<= 4;
        }
        
        byte bf[] = new byte[2*f.length];
        
        for(int i=0; i<f.length; i++)
        {
            bf[2*i] = (byte)f[i];
            bf[2*i+1] = (byte)(f[i]>>=8);
        }
        os.write(bf);
    }
    
    @Override
    public void close() throws Exception
    {
        simpleSerial.close();
    }    
    
    /**
     * @param args
     * @paramSend args the command line arguments
     */
    public static void main(String[] args)
    {
        final List<String> ports = SimpleSerialV2019.findSerialPorts();
        System.out.println("Anzahl seriellen Ports: "+ports.size());
        for(String port:ports)
        {
            System.out.println(port);
        }

        try(WG810V2019 wg810 = new WG810V2019("COM3"))
        {
            wg810.setRemote(true);

            System.out.println("Remote: "+wg810.getRemote());
//            wg810.setDefault();
//            Thread.sleep(5000);
//            System.out.println("Typ: "+wg810.getTyp());
            System.out.println("Kanäle: "+wg810.getKanalAnzahl());
            System.out.println("Firmware: "+wg810.getFirmware());
            System.out.println("Remote: "+wg810.getRemote());
            Thread.sleep(2000);
            wg810.setKurvenform(WG810V2019.FORMTRI, 0, true);
            System.out.println("Kurvenform: " + wg810.getKurvenform());
            wg810.setFrequenz(10000,true);
            System.out.println("Frequenz: " + wg810.getFrequenz());
            wg810.setAmplitude(1.0,true);
            System.out.println("Amplitude: " + wg810.getAmplitude());
            wg810.setOffsetMode(WG810V2019.OFFSETSIGPOSNEG, true);
            System.out.println("Offset: " + wg810.getOffsetMode());
            
            wg810.setOffset(0.5,true);
            System.out.println("Offset: " + wg810.getOffset());
            
            wg810.setDutyCycle(60,true);
            System.out.println("DutyCycle: " + wg810.getDutyCycle());

            wg810.setAusgangsModus(WG810V2019.OUTPUT0DB, true);
            System.out.println("Ausgangsmodus: " + wg810.getAusgangsModus());
            
            wg810.setFilter(true,true);
            System.out.println("Filter: " + wg810.getFilter());

            wg810.setSyncPosition(56,true);
            System.out.println("SyncPosition: " + wg810.getSyncPosition());
            
            wg810.setModulation(WG810V2019.MODNONE, false);
            System.out.println("Modulation: " + wg810.getModulation());
            
            wg810.setTriggerModus(WG810V2019.TRIGCONT, false);
            System.out.println("Triggermode: " + wg810.getTriggerModus());

            wg810.setClockSource(WG810V2019.CLKINTERN,true);
            System.out.println("Taktquelle: " + wg810.getClockSource());
            
            wg810.setMorphingParameter(WG810V2019.MORPHMANUAL, 3, true);
            System.out.println("Morphing Parameter: " + wg810.getMorphingParameter());
            
            
            // Ein erster Versuch Kurvendaten in den Funktionsgenerator zu schreiben
//            int daten[] = {0,0,255,255,255,255,128,128};
//            wg810.progKurve(daten, 1, wg810.BITS8);

            wg810.setRemote(false);
            System.out.println("Remote: "+wg810.getRemote());
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}
