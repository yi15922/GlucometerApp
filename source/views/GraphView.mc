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

    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.Graph(dc));
        getRecentReadings();
    }

    function onUpdate(dc){ 
        View.onUpdate(dc);
        design.menuDots(dc, 2);
        design.graph(dc, [100, 80, 150, 200, 180]);

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

    function getRecentReadings() as Void {
        Storage.setValue("number", 2);
        System.println("Set number to 2");
        Storage.setValue("float", 3.14);
        System.println("Set float to 3.14");
        Storage.setValue("string", "Hello World!");
        System.println("Set string to \"Hello World!\"");
        Storage.setValue("boolean1", false);
        System.println("Set boolean to true");

        var int = Storage.getValue("number");
        System.print("Found number to be ");
        System.println(int);
        var float = Storage.getValue("float");
        System.print("Found float to be ");
        System.println(float);
        var string = Storage.getValue("string");
        System.print("Found string to be ");
        System.println(string);
        var boolean = Storage.getValue("boolean");
        System.print("Found boolean to be ");
        System.println(boolean);
        var boolean1 = Storage.getValue("boolean1");
        System.print("Found boolean1 to be ");
        System.println(boolean1);
    }

    function buildGraph(dc){

    }

}