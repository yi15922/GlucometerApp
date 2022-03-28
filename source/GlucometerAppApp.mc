import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble; 

class GlucometerAppApp extends Application.AppBase {

    var bleFetcher = null; 

    function initialize() {
        AppBase.initialize(); 
        bleFetcher = new BluetoothFetcher(null, null); 
        Ble.setDelegate(bleFetcher); 
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new InputStripView(), new InputStripDelegate(bleFetcher) ] as Array<Views or InputDelegates>;
    }

}

function getApp() as GlucometerAppApp {
    return Application.getApp() as GlucometerAppApp;
}