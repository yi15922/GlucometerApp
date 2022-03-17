import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy;

class InformationView extends WatchUi.View { 

    var design = new BaseDesign();
    
    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.Information(dc));
        var myTimer = new Timer.Timer(); 
        myTimer.start(method(:timerCallback), 1000, true); 
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        design.menuDots(dc, 1);
        design.upArrow(dc);
        
        var bleResultsText = View.findDrawableById("PairingResult") as Text;
        var timeText = View.findDrawableById("TimeDisplay") as Text; 
        var today = Gregorian.info(Time.now(), Time.FORMAT_LONG); 


        var timeString = Lang.format(
            "$1$, $2$ $3$\n$4$:$5$:$6$",
            [
                today.day_of_week,
                today.month,
                today.day,
                today.hour,
                today.min,
                today.sec,
            ]
        );

        var available = "110"; 

        bleResultsText.setText(available); 
        timeText.setText(timeString); 
    }
}