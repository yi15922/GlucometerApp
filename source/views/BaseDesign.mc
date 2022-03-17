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
        System.println(menu_value);
        dc.setColor(menu_value == 1 ? white : gray, Graphics.COLOR_WHITE);
        dc.fillCircle(10, VENU2_CENTER-20, 8);
        dc.setColor(menu_value == 2 ? white : gray, Graphics.COLOR_WHITE);
        dc.fillCircle(10, VENU2_CENTER, 8);
        dc.setColor(menu_value == 3 ? white : gray, Graphics.COLOR_WHITE);
        dc.fillCircle(10, VENU2_CENTER+20, 8);
        dc.setColor(white, Graphics.COLOR_WHITE);
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

}