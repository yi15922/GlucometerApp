import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 
import Toybox.Application.Storage;

class GraphView extends WatchUi.View {
    
    var design = new BaseDesign();
    var currStartIdx = 20;

    function initialize() { 
        View.initialize();
        var lowVal = Storage.getValue("low");
        if(lowVal == null){
            Storage.setValue("low",70);
            lowVal = 70;
        }

        var highVal = Storage.getValue("high");
        if(highVal == null){
            Storage.setValue("high",180);
            highVal = 180;
        }

        var idx = Storage.getValue("idx");
        if(idx == null){
            Storage.setValue("idx",0);
            idx = 0;
        }
    }

    function onLayout(dc){
        setLayout(Rez.Layouts.Graph(dc));
    }

    function onUpdate(dc){ 
        View.onUpdate(dc);
        design.menuDots(dc, 2);
        
        var startIdx = Storage.getValue("idx");
        var endIdx = startIdx;
        var arrSize = Storage.getValue("meas").size();
        if(arrSize < 5){
            endIdx = arrSize;
        } else if (startIdx > arrSize - 5) {
            startIdx = arrSize-5;
            endIdx = arrSize;
        } else {
            endIdx = startIdx + 5;
        }
        design.graph(dc, Storage.getValue("meas").slice(startIdx, endIdx), Storage.getValue("times").slice(startIdx, endIdx));
        var timeText = View.findDrawableById("TimeDisplay") as Text;
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 

        var timeString = Lang.format(
            "$1$, $2$ $3$\n$4$:$5$",
            [
                today.day_of_week,
                today.month,
                today.day,
                today.hour,
                today.min,
            ]
        );
        timeText.setText(timeString);

        dc.setColor(Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY);

        dc.fillPolygon([[90,90],[140,65],[140,115]]); // left
        dc.fillPolygon([[325,90],[275,65],[275,115]]); // right
    }

}