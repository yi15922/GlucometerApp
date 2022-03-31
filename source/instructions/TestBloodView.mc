import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 

class TestBloodView extends WatchUi.View { 

    var flip = true;
    var bleFetcher = null; 
    var bgDisplay = ""; 
    var bleConnectionState = "Awaiting Blood"; 
    
    function initialize(blefetch) { 
        View.initialize();
        bleFetcher = blefetch;
        bleFetcher.updateView(method(:updateConnectionState), method(:updateGlucoseValue));
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.TestBlood(dc));
    }

    function onUpdate(dc){ 

        View.onUpdate(dc); 

        dc.drawBitmap(210-65, 210+50, WatchUi.loadResource(Rez.Drawables.TestStrip));
        flip = !flip;

        if(flip){
            dc.drawBitmap(210+40, 210+20, WatchUi.loadResource(Rez.Drawables.Blood));
        }

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

        var available = "Awaiting Blood"; 

        bleResultsText.setText(bleConnectionState); 
        timeText.setText(timeString); 
        if(bleFetcher.getBgVal() != 0){
            moveToNextView();
        }
    }

    function moveToNextView() as Boolean {
        WatchUi.switchToView(new InformationView(bleFetcher), new InformationDelegate(bleFetcher), WatchUi.SLIDE_UP);
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