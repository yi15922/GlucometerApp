import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
// import Toybox.Timer; 
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
        System.println("lowVal:");
        System.println(lowVal);
        if(lowVal == null){
            Storage.setValue("low",70);
            lowVal = 70;
        }

        var highVal = Storage.getValue("high");
        System.println("highVal:");
        System.println(highVal);
        if(highVal == null){
            Storage.setValue("high",180);
            highVal = 180;
        }
        lowVal = Storage.getValue("low");
        highVal = Storage.getValue("high");
    }

    // function timerCallback() { 
    //     self.requestUpdate(); 
    // }

    function onLayout(dc){
        setLayout(Rez.Layouts.Graph(dc));
    }

    function onUpdate(dc){ 
        View.onUpdate(dc);
        design.menuDots(dc, 2);
        
        var startIdx = 0;
        var endIdx = 0;
        var arrSize = Storage.getValue("meas").size();
        System.println("arrSize:");
        System.println(arrSize);
        if(arrSize < 5){
            endIdx = arrSize;
        } else {
            startIdx = arrSize-5;
            endIdx = arrSize;
        }
        System.println("startIdx:");
        System.println(startIdx);
        System.println("endIdx:");
        System.println(endIdx);
        try {
            design.graph(dc, Storage.getValue("meas").slice(startIdx, endIdx), Storage.getValue("times").slice(startIdx, endIdx));
        } catch (e) { 
            System.println(e.getErrorMessage());
        }
        System.println("made graph");
        // var bleResultsText = View.findDrawableById("PairingResult") as Text;
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
        System.println("time string:");
        System.println(timeString);

        // var available = ""; 

        // bleResultsText.setText(available); 
        timeText.setText(timeString);
    }

    function buildGraph(dc){

    }



}