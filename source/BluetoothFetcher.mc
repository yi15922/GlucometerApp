import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.BluetoothLowEnergy; 

class BluetoothFetcher { 

    function initialize(){ 
        System.println("Initializing Bluetooth Fetcher..."); 
    }

    function fetchInfo() { 
        System.println("Getting nearby BLE devices..."); 
        var availCount = BluetoothLowEnergy.getAvailableConnectionCount(); 
        var UUID = BluetoothLowEnergy.cccdUuid(); 
        var str = Lang.format("$1$, \n$2$", [availCount, UUID]);
        System.println(str); 
        return [UUID, availCount]; 
    }


}