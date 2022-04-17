import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;

class ConnectDeviceView extends WatchUi.View {

    var flip = true; 
    var bleFetcher = null; 
    var bgDisplay = ""; 
    var bleConnectionState = ""; 
    
    function initialize(bleFetch) { 
        View.initialize();
        bleFetcher = bleFetch;
        bleFetcher.updateView(method(:updateConnectionState), method(:updateGlucoseValue));
        bleFetcher.startScan(); 
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.ConnectDevice(dc));
    }

    function onUpdate(dc){ 
        View.onUpdate(dc);

        flip = !flip;

        if(flip){
            dc.drawBitmap(210-50, 210+15, WatchUi.loadResource(Rez.Drawables.Bluetooth));
        }

        var bleResultsText = View.findDrawableById("PairingResult") as Text;
        var timeText = View.findDrawableById("TimeDisplay") as Text; 
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM); 

        var timeString = Lang.format(
            "$1$:$2$",
            [
                today.hour,
                (today.min).format("%02d"),
            ]
        );

        var available = "Connect Device"; 

        bleResultsText.setText(bleConnectionState); 
        timeText.setText(timeString);

        if(bleConnectionState.equals("Glucometer connected!")){
            moveToNextView();
        }

    }

    function moveToNextView() as Boolean {
        WatchUi.switchToView(new TestBloodView(bleFetcher), new TestBloodDelegate(bleFetcher), WatchUi.SLIDE_UP);
        return true;
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

}