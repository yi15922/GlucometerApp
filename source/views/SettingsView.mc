import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 
import Toybox.Application.Storage;

class SettingsView extends WatchUi.View { 
    
    var design = new BaseDesign();
    
    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.Settings(dc));
        // TODO: Add buttons
    }

    function onUpdate(dc){ 
        View.onUpdate(dc);
        design.menuDots(dc, 3);
        var lowVal = Storage.getValue("low");
        var highVal = Storage.getValue("high");

        var settingsText = View.findDrawableById("SettingsLabel") as Text;
        settingsText.setText("Settings");
        var highText = View.findDrawableById("HighLabel") as Text;
        highText.setText("Set high value:");
        var lowText = View.findDrawableById("LowLabel") as Text;
        lowText.setText("Set low value:");
        var highValueText = View.findDrawableById("HighValue") as Text;
        highValueText.setText(highVal.toString());
        var lowValueText = View.findDrawableById("LowValue") as Text;
        lowValueText.setText(lowVal.toString());
    }

    function decreaseLow(){
        var lowVal = Storage.getValue("low")-10;
        Storage.setValue("low", lowVal-10);
        var lowValueText = View.findDrawableById("LowValue") as Text;
        lowValueText.setText(lowVal.toString());
    }

    function increaseLow(){
        var lowVal = Storage.getValue("low");
        Storage.setValue("low", lowVal+10);
    }

    function decreaseHigh(){
        var highVal = Storage.getValue("high");
        Storage.setValue("high", highVal-10);
    }

    function increaseHigh(){
        var highVal = Storage.getValue("high");
        Storage.setValue("high", highVal+10);
    }

}