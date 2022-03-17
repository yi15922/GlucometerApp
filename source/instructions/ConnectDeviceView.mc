import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 

class ConnectDeviceView extends WatchUi.View {

    var flip = true; 
    
    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.ConnectDevice(dc));
        var myTimer = new Timer.Timer(); 
        myTimer.start(method(:timerCallback), 1000, true); 
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
            "$1$:$2$:$3$",
            [
                today.hour,
                today.min,
                today.sec,
                
            ]
        );

        var available = "Connect Device"; 

        bleResultsText.setText(available); 
        timeText.setText(timeString); 

    }

}