import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
using Toybox.BluetoothLowEnergy as Ble; 

class BluetoothFetcherView extends WatchUi.View { 

    const FETCHER_STATE_SEARCHING = "Searching for glucometers..."; 
    const FETCHER_STATE_CONNECTED = "Glucometer connected!"; 

    var bleFetcher = null; 
    var connectionState = FETCHER_STATE_SEARCHING; 
    var glucoseConcentration = 0; 
    

    function initialize() { 
        View.initialize(); 
        bleFetcher = new BluetoothFetcher(method(:updateConnectionState), method(:updateGlucoseValue)); 
        Ble.setDelegate(bleFetcher); 
        bleFetcher.startScan(); 
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.PairingScreen(dc));
        var myTimer = new Timer.Timer(); 
        myTimer.start(method(:timerCallback), 1000, true); 
    }

    function onUpdate(dc){ 
        
        var bleResultsText = View.findDrawableById("PairingResult") as Text;
        var timeText = View.findDrawableById("TimeDisplay") as Text; 
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 
        var glucoseText = View.findDrawableById("GlucoseValue") as Text; 

        var timeString = Lang.format(
            "$1$:$2$:$3$",
            [
                today.hour,
                today.min,
                today.sec,
                
            ]
        );

        var glucoseFormat = Lang.format("BG: $1$", [glucoseConcentration]); 
        

        bleResultsText.setText(connectionState); 
        glucoseText.setText(glucoseFormat); 
        timeText.setText(timeString); 

        View.onUpdate(dc); 
    }

    function updateConnectionState(){ 
        connectionState = FETCHER_STATE_CONNECTED; 
    }

    function updateGlucoseValue(value) { 
        glucoseConcentration = value; 
    }

    function onHide() as Void { 
        bleFetcher.close(); 
    }
}