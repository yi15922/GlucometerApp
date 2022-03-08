import Toybox.Lang;
import Toybox.WatchUi;

class GlucometerAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    /* 
        On tap on any part of the current view, 
        the BluetoothFetcher view will be pushed, which
        contains the main glucose measurement session. 
    */
    function onSelect() as Boolean {
        WatchUi.pushView(new BluetoothFetcherView(), null, WatchUi.SLIDE_UP);
        return true;
    }

}