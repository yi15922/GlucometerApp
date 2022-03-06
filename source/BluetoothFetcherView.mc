import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
using Toybox.BluetoothLowEnergy as Ble; 

class BluetoothFetcherView extends WatchUi.View { 

    var bleFetcher = new BluetoothFetcher(); 
    

    function initialize() { 
        View.initialize(); 

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

        var timeString = Lang.format(
            "$1$:$2$:$3$",
            [
                today.hour,
                today.min,
                today.sec,
                
            ]
        );


        var available = Lang.format("Available nearby device: \n$1$", [bleFetcher.getName()]); 

        

        bleResultsText.setText(available); 
        timeText.setText(timeString); 

        View.onUpdate(dc); 
    }

    function onHide() as Void { 
        bleFetcher.stopScan(); 
    }
}