import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class InformationDelegate extends WatchUi.BehaviorDelegate{ 

    var bleFetcher = null; 

    function initialize(bleFetch) { 
        BehaviorDelegate.initialize();
        bleFetcher = bleFetch;
    }

    function onSelect() as Boolean {
        WatchUi.pushView(new GraphView(), new GraphDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        if(direction == 0){
            WatchUi.pushView(new GraphView(), new GraphDelegate(), WatchUi.SLIDE_UP);
        }
        return true;
    }
}