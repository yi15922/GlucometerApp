import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.BluetoothLowEnergy; 

class ConnectDevice { 

    function initialize(){ 
        System.println("Connect Device..."); 
        var connectDeviceDelegate = new ConnectDeviceDelegate(); 

        ConnectDevice.setDelegate(connectDeviceDelegate); 
    }

    function fetchInfo() { 
        
        var availCount = BluetoothLowEnergy.getAvailableConnectionCount(); 
        var UUID = BluetoothLowEnergy.cccdUuid(); 
        // var str = Lang.format("$1$, \n$2$", [availCount, UUID]);
        // System.println(str); 
        return [UUID, availCount]; 
    }




}