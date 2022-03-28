import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class ConnectDeviceDelegate extends WatchUi.BehaviorDelegate{ 

    var bleFetcher = null; 

    function initialize(bleFetch) { 
        BehaviorDelegate.initialize();
        bleFetcher = bleFetch;
    }

    function onSelect() as Boolean {
        WatchUi.switchToView(new TestBloodView(bleFetcher), new TestBloodDelegate(bleFetcher), WatchUi.SLIDE_UP);
        return true;
    }
}