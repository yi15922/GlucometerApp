import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 

class InputStripView extends WatchUi.View { 
    
    var flip = true;
    var myTimer = new Timer.Timer(); 


    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.InputStrip(dc));
        myTimer.start(method(:timerCallback), 1000, true); 
    }

    function onUpdate(dc){ 

        View.onUpdate(dc); 

        flip = !flip;

        if(flip){
            dc.drawBitmap(210-65, 210+50, WatchUi.loadResource(Rez.Drawables.TestStrip));
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

        var available = "Input Strip\nTap The Screen To Continue"; 

        bleResultsText.setText(available); 
        timeText.setText(timeString); 

    }
}

