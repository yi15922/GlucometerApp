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
    const FETCHER_STATE_FINISHED = "Measurement done."; 

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
        // var myTimer = new Timer.Timer(); 
        // myTimer.start(method(:timerCallback), 1000, true); 
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
        

        bleResultsText.setText(connectionState); 
        timeText.setText(timeString); 
        if (connectionState != FETCHER_STATE_FINISHED){ 
            glucoseText.setText(handleBLEValue()); 
        }

        View.onUpdate(dc); 
    }

    function handleBLEValue() { 
        var outputString = ""; 
        if (connectionState == FETCHER_STATE_SEARCHING){ 
            return outputString; 
        }

        if (glucoseConcentration == 0){ 
            outputString = "Awaiting blood"; 
        } else if (glucoseConcentration == 65535) {
            outputString = "Blood detected! \nPlease wait..."; 
        } else { 
            outputString = Lang.format("BG: $1$mg/dL", [glucoseConcentration]); 
            bleFetcher.close(); 
            connectionState = FETCHER_STATE_FINISHED; 
        }
        return outputString;
    }

    function updateConnectionState(){ 
        connectionState = FETCHER_STATE_CONNECTED; 
        self.requestUpdate(); 
    }

    function updateGlucoseValue(value) { 
        var BG = value.decodeNumber(NUMBER_FORMAT_UINT16, {:offset => 0, :endianness => Lang.ENDIAN_LITTLE});
        glucoseConcentration = BG; 
        self.requestUpdate(); 
    }

    function onHide() as Void { 
        bleFetcher.close(); 
    }
}