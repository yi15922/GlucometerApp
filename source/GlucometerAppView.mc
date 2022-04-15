import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Timer; 
import Toybox.Time.Gregorian;

class GlucometerAppView extends WatchUi.View {

    var bloodSugar = 0;

    function initialize() {
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    /* 
        Loads the MainLayout file from layouts.layout.xml. Also 
        starts a timer that updates the view every second to 
        update the current time display. 
    */
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        var myTimer = new Timer.Timer(); 
        myTimer.start(method(:timerCallback), 1000, true); 
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {        
    }

    /* 
        Displays the current time as well as a prompt to 
        enter scanning mode. 
    */
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout

        var clockTime = System.getClockTime();
        setBloodSugar(getBloodSugar() + 1);
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var timeString = Lang.format(
            "$1$:$2$:$3$",
            [
                today.hour,
                today.min,
                today.sec
                
            ]
        );
        var timeText = View.findDrawableById("TimeDisplay") as Text;
        var textText = View.findDrawableById("Text") as Text;


        textText.setText(Lang.format("Blood Sugar Level: \n$1$", [getBloodSugar()]));
        timeText.setText(timeString); 

        View.onUpdate(dc);
    }

    function getBloodSugar() {
        return bloodSugar;
    }

    function setBloodSugar(newVal){
        bloodSugar = newVal;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
