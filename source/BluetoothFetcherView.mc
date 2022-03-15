import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
using Toybox.BluetoothLowEnergy as Ble; 

/* 
    This class extends WatchUi.View and shows BLE connection state as 
    well as glucometer device status. The view will load a BleDelegate 
    object upon layout and will receive asynchronous callbacks for 
    device state changes.  
*/
class BluetoothFetcherView extends WatchUi.View { 


    var bleFetcher = null; 
    var bgDisplay = ""; 
    var bleConnectionState = ""; 

    
    /* 
        Constructor, initializes the view and the BleDelegate, 
        also registers the delegate with the current BLE instance. 
        Once registered, starts the bluetooth device scanning process.
    */
    function initialize() { 
        View.initialize(); 
        bleFetcher = new BluetoothFetcher(method(:updateConnectionState), method(:updateGlucoseValue)); 
        Ble.setDelegate(bleFetcher); 
        bleFetcher.startScan(); 
    }


    private function timerCallback() { 
        self.requestUpdate(); 
    }

    // Renders the layout specified in layouts.pairing.xml
    function onLayout(dc){ 
        setLayout(Rez.Layouts.PairingScreen(dc));
        // var myTimer = new Timer.Timer(); 
        // myTimer.start(method(:timerCallback), 1000, true); 
    }

    /* 
        On view update, update the current time as well as any other 
        BLE dependent parameters that may have changed. 
    */
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
        

        bleResultsText.setText(bleConnectionState); 
        timeText.setText(timeString); 
        glucoseText.setText(bgDisplay); 
        

        View.onUpdate(dc); 
    }

    /* 
        Callback function for the onConnectStateChanged() call
        in the BleDelegate. Receives and updates the connection 
        state and refreshes the UI. 
    */
    function updateConnectionState(connectionState){ 
        bleConnectionState = connectionState; 
        self.requestUpdate(); 
    }

    /*
         Callback function for the onCharacteristicChanged() call
         in the BleDelegate. The value received is a string representation
         of either the glucometer state or the glucose concentration. It 
         sets the value of bgDisplay to the string received and refreshes 
         the UI. 
    */
    function updateGlucoseValue(value) { 
        bgDisplay = value; 
        self.requestUpdate(); 
    }
    /* 
        Upon removal of this view from the UI stack, close the
        BleDelegate and disconnect any connected peripherals. 
    */
    function onHide() as Void { 
        bleFetcher.close(); 
    }
}