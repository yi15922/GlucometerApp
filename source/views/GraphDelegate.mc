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

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        if(direction == 0){
            WatchUi.pushView(new SettingsView(), new SettingsDelegate(), WatchUi.SLIDE_RIGHT);
        }
        else if(direction == 2){
            WatchUi.popView(WatchUi.SLIDE_LEFT);
        }
        return true;
    }

}