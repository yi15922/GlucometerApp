import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class GraphDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.pushView(new SettingsView(), new SettingsDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}