import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class ConnectDeviceDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        WatchUi.popView(WatchUi.SLIDE_UP);
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.switchToView(new InputStripView(), new InputStripDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}