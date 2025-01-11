/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Frequenzkennlinienmessung.gui;
import javax.swing.AbstractListModel;
import Frequenzkennlinienmessung.data.MeasureValue;
import java.util.List;

/**
 *
 * @author nicob
 */
public class MeasuredValuesListModel extends AbstractListModel<MeasureValue>{

    private final List<MeasureValue> measureValues;

    public MeasuredValuesListModel(List<MeasureValue> measureValues) {
        this.measureValues = measureValues;
    }
    
    @Override
    public int getSize() {
        return measureValues.size();
    }

    @Override
    public MeasureValue getElementAt(int index) {
        return measureValues.get(index);
    }    
}
