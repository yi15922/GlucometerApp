import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class TestBloodDelegate extends WatchUi.BehaviorDelegate{ 

    var bleFetcher = null; 

    function initialize(bleFetch) { 
        BehaviorDelegate.initialize();
        bleFetcher = bleFetch;
    }

    function onSelect() as Boolean {
        WatchUi.switchToView(new InformationView(bleFetcher), new InformationDelegate(bleFetcher), WatchUi.SLIDE_UP);
        return true;
    }
}