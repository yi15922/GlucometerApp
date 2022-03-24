import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 

class BaseDesign {

    var VENU2_CENTER = 210;
    var gray = Graphics.COLOR_DK_GRAY;
    var white = Graphics.COLOR_WHITE;

    function menuDots(dc as Dc, menu_value) as Void {
        dc.setColor(menu_value == 1 ? white : gray, Graphics.COLOR_BLACK);
        dc.fillCircle(10, VENU2_CENTER-20, 8);
        dc.setColor(menu_value == 2 ? white : gray, Graphics.COLOR_BLACK);
        dc.fillCircle(10, VENU2_CENTER, 8);
        dc.setColor(menu_value == 3 ? white : gray, Graphics.COLOR_BLACK);
        dc.fillCircle(10, VENU2_CENTER+20, 8);
        dc.setColor(white, Graphics.COLOR_BLACK);
    }

    function upArrow(dc as Dc) as Void {
        dc.setPenWidth(4);
        dc.drawLine(VENU2_CENTER-20, VENU2_CENTER+150, VENU2_CENTER+20, VENU2_CENTER+110);
        dc.drawLine(VENU2_CENTER+20, VENU2_CENTER+110, VENU2_CENTER, VENU2_CENTER+110);
        dc.drawLine(VENU2_CENTER+20, VENU2_CENTER+110, VENU2_CENTER+20, VENU2_CENTER+130);
    }

    function downArrow(dc as Dc) as Void {
        dc.setPenWidth(4);
        dc.drawLine(VENU2_CENTER-20, VENU2_CENTER+110, VENU2_CENTER+20, VENU2_CENTER+150);
        dc.drawLine(VENU2_CENTER+20, VENU2_CENTER+150, VENU2_CENTER+20, VENU2_CENTER+130);
        dc.drawLine(VENU2_CENTER+20, VENU2_CENTER+150, VENU2_CENTER, VENU2_CENTER+150);
    }

    function graph(dc as Dc, bsVals, lowVal, highVal) as Void {

        // Draw plot and labels
        dc.setPenWidth(2);
        dc.drawLine(100, VENU2_CENTER*2-80, 100, 120);
        dc.drawLine(100, VENU2_CENTER*2-80, VENU2_CENTER*2-100, VENU2_CENTER*2-80);
        dc.drawText(95, 115, Graphics.FONT_XTINY, "mg/dL", Graphics.TEXT_JUSTIFY_CENTER);

        // Draw high and low regions

        // Draw glucose reading values
        var offset = (VENU2_CENTER*2-200)/(bsVals.size()+2);
        var currX = 100 + offset;
        dc.setColor(white, Graphics.COLOR_BLACK);
        for(var i = 0; i<bsVals.size(); i++){
            dc.fillCircle(currX, VENU2_CENTER*2-80-bsVals[i], 3);
            currX += offset;
        }
    }
}