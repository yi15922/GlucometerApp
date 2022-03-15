import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class InformationDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.pushView(new GraphView(), new GraphDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}