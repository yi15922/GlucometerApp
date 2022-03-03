import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 

class BluetoothFetcherView extends WatchUi.View { 

    var bleFetcher = new BluetoothFetcher(); 
    

    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.PairingScreen(dc));
    }

    function onUpdate(dc){ 
        
        var bleInfo = bleFetcher.fetchInfo(); 

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

        System.println(bleInfo[0]);

        var available = Lang.format("Available nearby devices: \n$1$", [bleInfo[1]]); 

        

        bleResultsText.setText(available); 
        timeText.setText(timeString); 

        View.onUpdate(dc); 
    }

}