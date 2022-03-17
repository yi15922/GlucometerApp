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
    
    function initialize() { 
        View.initialize();
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

        var available = "Test Blood"; 

        bleResultsText.setText(available); 
        timeText.setText(timeString); 
    }

}