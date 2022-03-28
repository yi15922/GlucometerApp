import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 

class InputStripDelegate extends WatchUi.BehaviorDelegate{ 


    var bleFetcher = null; 

    function initialize(blefetch) { 
        BehaviorDelegate.initialize();
        bleFetcher = blefetch;
    }

    function onSelect() as Boolean {
        WatchUi.switchToView(new ConnectDeviceView(bleFetcher), new ConnectDeviceDelegate(bleFetcher), WatchUi.SLIDE_UP);
        return true;
    }

}