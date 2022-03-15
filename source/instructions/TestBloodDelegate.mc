import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class TestBloodDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.pushView(new InformationView(), new InformationDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}