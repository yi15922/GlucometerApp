import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
import Toybox.Graphics;
import Toybox.BluetoothLowEnergy; 

class BluetoothFetcherView extends WatchUi.View { 

    var bleFetcher = new BluetoothFetcher(); 
    var bleInfo = bleFetcher.fetchInfo(); 

    function initialize() { 
        View.initialize(); 
    }

    function onLayout(dc){ 
        setLayout(Rez.Layouts.PairingScreen(dc));
    }

    function onUpdate(dc){ 
        
        var bleResultsText = View.findDrawableById("PairingResult") as Text;
        System.println(bleInfo[0]);

        var available = Lang.format("Available nearby devices: \n$1$", [bleInfo[1]]); 

        bleResultsText.setText(available); 

        View.onUpdate(dc); 
    }

}