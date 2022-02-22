import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.BluetoothLowEnergy; 

class BluetoothFetcher { 

    function initialize(){ 
        System.println("Initializing Bluetooth Fetcher..."); 
        var fetcherDelegate = new BluetoothFetcherDelegate(); 

        BluetoothLowEnergy.setDelegate(fetcherDelegate); 

        var profile = {
            :uuid => BluetoothLowEnergy.stringToUuid("00001808-0000-1000-8000-00805F9B34FB"), 
            :characteristics => [
                {
                    :uuid => BluetoothLowEnergy.stringToUuid("00002A18-0000-1000-8000-00805F9B34FB"), 
                    :descriptors => []
                }
            ]
        }; 

        BluetoothLowEnergy.registerProfile(profile); 
    }

    function fetchInfo() { 
        System.println("Getting nearby BLE devices..."); 
        
        var availCount = BluetoothLowEnergy.getAvailableConnectionCount(); 
        var UUID = BluetoothLowEnergy.cccdUuid(); 
        // var str = Lang.format("$1$, \n$2$", [availCount, UUID]);
        // System.println(str); 
        return [UUID, availCount]; 
    }




}