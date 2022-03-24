import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy;
import Toybox.Application.Storage;

class GraphView extends WatchUi.View { 
    
    var design = new BaseDesign();
    var currGraphValues = new [10];

    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.Graph(dc));
        currGraphValues = getTenMostRecentReadings();

        // TODO: move to be called with user input
        setRecentReadings();
        setLowValue(70);
        setHighValue(150);
    }

    function onUpdate(dc){ 
        View.onUpdate(dc);
        design.menuDots(dc, 2);
        design.graph(dc,currGraphValues, getLowValue(), getHighValue());

        var bleResultsText = View.findDrawableById("PairingResult") as Text;
        var timeText = View.findDrawableById("TimeDisplay") as Text; 
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 

        var timeString = Lang.format(
            "$1$:$2$:$3$",
            [
                today.hour,
                today.min,
                today.sec,
                
            ]
        );

        var available = ""; 

        bleResultsText.setText(available); 
        timeText.setText(timeString); 
    }

    function getTenMostRecentReadings() as Lang.Array<Lang.Number or Null> {
        var arr = new [10];
        arr[0] = Storage.getValue("0");
        arr[1] = Storage.getValue("1");
        arr[2] = Storage.getValue("2");
        arr[3] = Storage.getValue("3");
        arr[4] = Storage.getValue("4");
        arr[5] = Storage.getValue("5");
        arr[6] = Storage.getValue("6");
        arr[7] = Storage.getValue("7");
        arr[8] = Storage.getValue("8");
        arr[9] = Storage.getValue("9");
        return arr;
    }

    function setRecentReadings() as Void {
        Storage.setValue("0", 110);
        Storage.setValue("1", 100);
        Storage.setValue("2", 80);
        Storage.setValue("3", 90);
        Storage.setValue("4", 130);
        Storage.setValue("5", 120);
        Storage.setValue("6", 150);
        Storage.setValue("7", 110);
        Storage.setValue("8", 70);
        Storage.setValue("9", 65);
    }

    function setLowValue(lowIn) as Void { // TODO: Probably will make sense to move this to settings view
        Storage.setValue("low", lowIn);
    }

    function getLowValue() as Lang.Number {
        return Storage.getValue("low");
    }

    function setHighValue(highIn) as Void { // TODO: Probably will make sense to move this to settings view
        Storage.setValue("high", highIn);
    }

    function getHighValue() as Lang.Number {
        return Storage.getValue("high");
    }

    function buildGraph(dc){

    }

}