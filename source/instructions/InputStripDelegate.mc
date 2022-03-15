import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class InputStripDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        System.print("MOVING");
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        System.print("MOVING TO TEST BLOOD");
        WatchUi.pushView(new TestBloodView(), new TestBloodDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}