import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 
import Toybox.Application.Storage;

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

<<<<<<< HEAD
    function graph(dc as Dc, measurements, times) as Void {
        var lowVal = Storage.getValue("low");
        var highVal = Storage.getValue("high");
        dc.setPenWidth(2);
        dc.drawLine(100, VENU2_CENTER*2-80, 100, 120); //y axis
        dc.drawLine(100, VENU2_CENTER*2-80, VENU2_CENTER*2-100, VENU2_CENTER*2-80); //x axis
        dc.setColor(Graphics.COLOR_DK_GREEN,Graphics.COLOR_BLACK);
        dc.fillRectangle(102,VENU2_CENTER*2-80-highVal+1,VENU2_CENTER*2-202,highVal-lowVal);
        dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_BLACK);
        dc.drawLine(100, VENU2_CENTER*2-80-lowVal, VENU2_CENTER*2-100, VENU2_CENTER*2-80-lowVal); //low val
        dc.drawLine(100, VENU2_CENTER*2-80-highVal, VENU2_CENTER*2-100, VENU2_CENTER*2-80-highVal); //high val
        dc.setColor(white, Graphics.COLOR_BLACK);
        var yVals = [30,60,90,120,150,180];
        for(var i=0; i<yVals.size(); i++){
            var yVal = VENU2_CENTER*2-95-yVals[i];
            dc.drawText(78, yVal, Graphics.FONT_XTINY, yVals[i].toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        dc.drawText(90, 115, Graphics.FONT_XTINY, "mg/dL", Graphics.TEXT_JUSTIFY_CENTER);
        var offset = (VENU2_CENTER*2-200)/(measurements.size());
=======
    function graph(dc as Dc, bsVals, lowVal, highVal) as Void {

        // Draw plot and labels
        dc.setPenWidth(2);
        dc.drawLine(100, VENU2_CENTER*2-80, 100, 120);
        dc.drawLine(100, VENU2_CENTER*2-80, VENU2_CENTER*2-100, VENU2_CENTER*2-80);
        dc.drawText(95, 115, Graphics.FONT_XTINY, "mg/dL", Graphics.TEXT_JUSTIFY_CENTER);

        // Draw high and low regions

        // Draw glucose reading values
        var offset = (VENU2_CENTER*2-200)/(bsVals.size()+2);
>>>>>>> 4ff46cc87497493bd21c2bd0ff7cf37e392b8c6d
        var currX = 100 + offset;
        dc.setColor(white, Graphics.COLOR_BLACK);
        var prevX = 0;
        var prevY = 0;
        for(var i = 0; i<measurements.size(); i++){
            var currY = VENU2_CENTER*2-80-measurements[i];
            dc.fillCircle(currX, currY, 3);
            if(i > 0){
                dc.drawLine(prevX,prevY,currX,currY);
            }
            if(i % 2 == 0){
                dc.drawText(currX-10, VENU2_CENTER*2-80, Graphics.FONT_XTINY, times[i], Graphics.TEXT_JUSTIFY_CENTER);
            } else {
                dc.drawText(currX-10, VENU2_CENTER*2-50, Graphics.FONT_XTINY, times[i], Graphics.TEXT_JUSTIFY_CENTER);
            }
            prevX = currX;
            prevY = currY;
            currX += offset;
        }
    }

    function formatTime(value){
        if(value < 10){
            return Lang.format("0$1$", [value]);
        }
        else{
            return value;
        }
    }
}