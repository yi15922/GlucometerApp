import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class InputStripDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.switchToView(new ConnectDeviceView(), new ConnectDeviceDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}