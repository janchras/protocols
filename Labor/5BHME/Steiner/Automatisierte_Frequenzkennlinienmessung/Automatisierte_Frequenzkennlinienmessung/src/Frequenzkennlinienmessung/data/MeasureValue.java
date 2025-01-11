/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Frequenzkennlinienmessung.data;
import Frequenzkennlinienmessung.data.Waveform;

/**
 *
 * @author nicob
 */
public record MeasureValue(Waveform waveform, double frequency, double ue, double ua) {
    
}
