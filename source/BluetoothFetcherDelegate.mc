import Toybox.Lang; 
import Toybox.System; 
import Toybox.BluetoothLowEnergy; 

class BluetoothFetcherDelegate extends BluetoothLowEnergy.BleDelegate { 
    function initialize() { 
        BleDelegate.initialize(); 
    }

    function onScanResults(scanResults) { 
        System.println("Found result"); 
        System.println("$1$", [scanResults.getDeviceName()]); 
    }

}