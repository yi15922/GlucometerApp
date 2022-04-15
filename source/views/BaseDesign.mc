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

    function graph(dc as Dc, measurements, times) as Void {
        var lowVal = Storage.getValue("low");
        var highVal = Storage.getValue("high");
        System.println("high and low vals:");
        System.println(highVal);
        System.println(lowVal);
        dc.setPenWidth(2);
        dc.drawLine(100, VENU2_CENTER*2-80, 100, 120); //y axis
        dc.drawLine(100, VENU2_CENTER*2-80, VENU2_CENTER*2-100, VENU2_CENTER*2-80); //x axis
        dc.setColor(Graphics.COLOR_DK_GREEN,Graphics.COLOR_BLACK);
        dc.fillRectangle(102,VENU2_CENTER*2-80-highVal+1,VENU2_CENTER*2-202,highVal-lowVal);
        dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_BLACK);
        dc.drawLine(100, VENU2_CENTER*2-80-lowVal, VENU2_CENTER*2-100, VENU2_CENTER*2-80-lowVal); //low val
        dc.drawLine(100, VENU2_CENTER*2-80-highVal, VENU2_CENTER*2-100, VENU2_CENTER*2-80-highVal); //high val
        dc.setColor(white, Graphics.COLOR_BLACK);
        System.println("drew graph lines");
        var yVals = [30,60,90,120,150,180];
        for(var i=0; i<yVals.size(); i++){
            var yVal = VENU2_CENTER*2-95-yVals[i];
            dc.drawText(78, yVal, Graphics.FONT_XTINY, yVals[i].toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        System.println("drew graph times");
        dc.drawText(90, 115, Graphics.FONT_XTINY, "mg/dL", Graphics.TEXT_JUSTIFY_CENTER);
        var offset = (VENU2_CENTER*2-200)/(measurements.size()+1);
        System.println("offset:");
        System.println(offset);
        System.println(offset as Number);
        var currX = 100 + offset;
        System.println("currX:");
        System.println(currX);
        System.println(currX as Number);
        
        dc.setColor(white, Graphics.COLOR_BLACK);
        var prevX = 0;
        var prevY = 0;
        System.println("measurements:");
        System.println(measurements);
        System.println(measurements[0] as Number);
        for(var i = 0; i<measurements.size(); i++){

            var currY = VENU2_CENTER*2-80-measurements[i].toNumber();
            System.println("currY:");
            System.println(currY);
            System.println(currY as Number);
            dc.fillCircle(currX, currY, 3);
            System.println("filled circle");
            if(i > 0){
                dc.drawLine(prevX,prevY,currX,currY);
            }
            System.println("drew line");
            if(i % 2 == 0){
                dc.drawText(currX-10, VENU2_CENTER*2-80, Graphics.FONT_XTINY, times[i], Graphics.TEXT_JUSTIFY_CENTER);
            } else {
                dc.drawText(currX-10, VENU2_CENTER*2-50, Graphics.FONT_XTINY, times[i], Graphics.TEXT_JUSTIFY_CENTER);
            }
            System.println("drew text");
            prevX = currX;
            prevY = currY;
            currX += offset;
            System.println("updated values");
        }
        System.println("drew graph points");
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