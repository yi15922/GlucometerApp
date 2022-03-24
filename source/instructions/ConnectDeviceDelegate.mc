import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class ConnectDeviceDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.switchToView(new TestBloodView(), new TestBloodDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}