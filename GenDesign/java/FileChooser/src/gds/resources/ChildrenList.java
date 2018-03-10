/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package gds.resources;

import gds.resources.GDS.MyPanel;
import java.awt.Color;
import java.awt.Graphics2D;
import java.util.List;
import javax.swing.DefaultListModel;
import javax.swing.JList;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

/**
 *
 * @author owenpaulmeyer
 */
public class ChildrenList extends JList
                      implements ListSelectionListener {
    
    //private JList list;
    private DefaultListModel listModel;
    private EditElement editElem;
    List< Child > selections;
    Grid grid;
    MyPanel mp;
    
    
    public ChildrenList( DefaultListModel lm ) {
        super( lm );
        listModel = lm;
        setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        addListSelectionListener(this);
    }
    public void setEditElem( EditElement ee ) {
        editElem = ee;
    }
    public void setGrid ( Grid g ){
        grid = g;
    }
    public void setPanel ( MyPanel panel){
        mp = panel;
    }
    public void removeChild( Child c ) {
        if ( listModel.contains(c)){
            int index = listModel.indexOf( c );
            listModel.remove(index);
        }
    }
    public void addChild( Child add ) {
        if (alreadyInList(add)) {
            return;
        } else {
            listModel.addElement(add);
        }
    }
    @Override
    public void removeAll(){
        listModel.removeAllElements();
    }
    public boolean alreadyInList(Child e) {
        return listModel.contains(e);
    }
    //This method is required by ListSelectionListener.
    @Override
    public void valueChanged(ListSelectionEvent e) {
        selections = this.getSelectedValuesList();
        mp.repaint();
    }
    
    public void paintSelections(Graphics2D g){
        //if (selections.size()!=0)
        //System.out.println( "selections " + selections);//sure is getting called alot...
        if ( selections != null )
            for( Child c : selections ){
                int xLoc = c.location().xLoc();
                int yLoc = c.location().yLoc();
                g.setColor(new Color(250,231,61,150));
                g.fillOval(grid.originX()+(xLoc*grid.mS)-7, grid.originY()+(yLoc*grid.mS)-7, 14, 14);
            }
        }
}
 
