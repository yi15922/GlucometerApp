import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy;
import Toybox.Application.Storage;

class InformationView extends WatchUi.View { 

    var design = new BaseDesign();
    var bleFetcher = null; 
    var bgDisplay = "---"; 
    var bleConnectionState = "Awaiting Blood";
    
    function initialize(bleFetch) {
        View.initialize();
        bleFetcher = bleFetch;
        bleFetcher.updateView(method(:updateConnectionState), method(:updateGlucoseValue));
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.Information(dc));
        var myTimer = new Timer.Timer(); 
        myTimer.start(method(:timerCallback), 1000, true);
        addNewValue(130); //TODO: delete when we're actually using glucometer
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        design.menuDots(dc, 1);
        design.upArrow(dc);
        
        var bleResultsText = View.findDrawableById("PairingResult") as Text;
        var available = "110";
        bleResultsText.setText(bgDisplay);

        var today = Gregorian.info(Time.now(), Time.FORMAT_LONG); 
        var timeText = View.findDrawableById("TimeDisplay") as Text;
        var timeString = Lang.format(
            "$1$, $2$ $3$\n$4$:$5$",
            [
                today.day_of_week,
                today.month,
                today.day,
                today.hour,
                design.formatTime(today.min),
            ]
        );
        timeText.setText(timeString);
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
        addNewValue(value);
        self.requestUpdate();
    }

    function addNewValue(value) {
        var arrTimes = new[1];
        var prevStoredTimes = Storage.getValue("times");
        if(prevStoredTimes == null){
            Storage.setValue("times", arrTimes);
        } else {
            arrTimes = new[prevStoredTimes.size()+1];
            for(var i=0; i<prevStoredTimes.size(); i++){
                arrTimes[i] = prevStoredTimes[i];
            }
        }

        var arrMeas = new[1];
        var prevStoredMeas = Storage.getValue("meas");
        if(prevStoredMeas == null){
            Storage.setValue("meas", arrMeas);
        } else {
            // arrMeas = prevStoredMeas;
            arrMeas = new[prevStoredMeas.size()+1];
            for(var i=0; i<prevStoredMeas.size(); i++){
                arrMeas[i] = prevStoredMeas[i];
            }
        }

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var hour = today.hour % 12;
        var amPM = "am";
        if(today.hour > hour){
            amPM = "pm";
        }
        if(hour == 0){
            hour = 12;
        }
        var timeString = Lang.format(
            "$1$:$2$ $3$",
            [
                hour,
                today.min.format("%02d"),
                amPM,
            ]
        );

        var arrSize = arrTimes.size();
        if(arrSize > 24){
            shiftArray(arrTimes);
            shiftArray(arrMeas);
        }
        arrTimes[arrSize-1] = timeString;
        Storage.setValue("times", arrTimes);

        arrMeas[arrSize-1] = value;
        Storage.setValue("meas", arrMeas);

        System.println(Storage.getValue("times"));
        System.println(Storage.getValue("meas"));
    }

    function shiftArray(arr) {
        for (var i = 0; i < arr.size()-1; i++) {
            arr[i] = arr[i+1];
        }
        arr[arr.size()-1] = null;
    }
}