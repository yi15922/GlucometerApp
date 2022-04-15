import Toybox.Lang;
import Toybox.WatchUi;

class GlucometerAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        WatchUi.pushView(new BluetoothFetcherView(), null, WatchUi.SLIDE_UP);
        return true;
    }

    /*function onBack() as Boolean {
        System.print("BACKKKKKKK");
        return true;
    }*/

}