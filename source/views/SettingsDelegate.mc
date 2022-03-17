import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class SettingsDelegate extends WatchUi.BehaviorDelegate{ 
    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        //WatchUi.pushView(new InformationView(), new InformationDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        if(direction == 2){
            WatchUi.popView(WatchUi.SLIDE_LEFT);
        }
        return true;
    }
}