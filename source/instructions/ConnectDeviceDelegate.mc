import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class ConnectDeviceDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.pushView(new InputStripView(), null, WatchUi.SLIDE_UP);
        return true;
    }

}