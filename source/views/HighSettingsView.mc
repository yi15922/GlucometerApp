import Toybox.Lang; 
import Toybox.System;
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.Timer; 
import Toybox.Time; 
import Toybox.Time.Gregorian;
import Toybox.BluetoothLowEnergy; 
import Toybox.Application.Storage;

class HighSettingsView extends WatchUi.View { 
    
    var design = new BaseDesign();
    
    function initialize() { 
        View.initialize();
    }

    function timerCallback() { 
        self.requestUpdate(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.SingleSettings(dc));

        var settingsText = View.findDrawableById("SettingsLabel") as Text;
        settingsText.setText("Settings");
        var subText = View.findDrawableById("SubLabel") as Text;
        subText.setText("Set high value");
        var unitsText = View.findDrawableById("Units") as Text;
        unitsText.setText("mg/dL");

    }

    function onUpdate(dc){ 
        View.onUpdate(dc);
        design.menuDots(dc, 3);

        var center = 210;
        var edge = center*2;

        var val = Storage.getValue("high");

        var valueText = View.findDrawableById("Value") as Text;
        valueText.setText(val.toString());

        dc.setColor(Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY);

        dc.fillPolygon([[10,center-30],[edge-10,center-30],[center,center-150]]); // up
        dc.fillPolygon([[10,center+30],[edge-10,center+30],[center,center+150]]); // down

    }

}