import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
using Toybox.BluetoothLowEnergy as Ble; 

/* 
    This class extends the BleDelegate and acts as the asynch
    delegate for a connected BLE peripheral. The class creates
    a specific profile for glucometer devices and scans all 
    devices. If a glucometer is found, it pairs the device and 
    sets its CCCD value to 1, turning on asynch notifications. 
    Then, the class acts as a delegate and makes asynch callbacks
    to BluetoothFetcherView on state changes. 
*/
class BluetoothFetcher extends Ble.BleDelegate { 

    // Defines all constants for a glucometer device profile. 
    const GLUCOSE_SERVICE = Ble.stringToUuid("00001808-0000-1000-8000-00805F9B34FB");
    const GLUCOSE_CHARACTERISTIC = Ble.stringToUuid("00002A18-0000-1000-8000-00805F9B34FB"); 
    const GLUCOSE_CHAR_DESCRIPTOR = Ble.cccdUuid(); 
    const GLUCOMETER_NAME = "glucose"; 

    // Private variables to keep track of the current context
    var scanning = false;
    var device = null; 
    var deviceName = "null"; 
    var profileRegistered = false; 
    var connectionCallback; 
    var glucoseValueCallback;
    

    const FETCHER_STATE_SEARCHING = "Searching for glucometers..."; 
    const FETCHER_STATE_CONNECTED = "Glucometer connected!"; 
    const FETCHER_STATE_FINISHED = "Measurement done."; 

    var connectionState = FETCHER_STATE_SEARCHING; 

    private function debug(str) {
		System.println("[ble] " + str);
	}

    /* 
        Constructor, takes as inputs method symbols for the two callback 
        handlers. One for successful connection, and one for changes in 
        the glucose characteristic. Also initializes superclass. 
    */
    function initialize(connectionCallbackMethod, glucoseValueCallbackMethod){ 
        debug("Initializing Bluetooth Fetcher..."); 
        BleDelegate.initialize(); 
        connectionCallback = connectionCallbackMethod; 
        glucoseValueCallback = glucoseValueCallbackMethod; 
    }

    function updateView(connectionCallbackMethod, glucoseValueCallbackMethod) {
        connectionCallback = connectionCallbackMethod; 
        glucoseValueCallback = glucoseValueCallbackMethod; 
    }

    // Confirms the registration of a BLE profile. 
    function onProfileRegister(uuid, status) {
		debug("registered: " + uuid + " " + status);
	}

    /* 
        Registers a BLE profile for a glucometer. Also 
        updates the value of profileRegistered to ensure 
        no more than 1 profile is registered. 
    */ 
    private function registerProfiles() { 
        if (profileRegistered){ 
            debug("Profile already registered.");
            return; 
        }
        var profile = {
            :uuid => GLUCOSE_SERVICE, 
            :characteristics => [
                {
                    :uuid => GLUCOSE_CHARACTERISTIC, 
                    :descriptors => [GLUCOSE_CHAR_DESCRIPTOR]
                }
            ]
        }; 

        profileRegistered = true; 
        Ble.registerProfile(profile); 
    }

    /* 
        This function is called by a BLE notify, and it will
        update the scanning variable to keep track of scan 
        state. Also notifies the connectionCallback of the 
        scanning state. 
    */
    function onScanStateChange(scanState, status) {
		debug("scanstate: " + scanState + " " + status);
		if (scanState == Ble.SCAN_STATE_SCANNING && connectionCallback != null) {
            connectionCallback.invoke(FETCHER_STATE_SEARCHING); 
			scanning = true;
		} else {
			scanning = false;
		}
	}

    /* 
        Calls registerProfiles() and starts the BLE scan
        for nearby devices. The system will now call onScanResult()
        if a device is detected. 
    */
    function startScan() {
        debug("Scanning for nearby glucometer devices... ");
		registerProfiles();
		Ble.setScanState(Ble.SCAN_STATE_SCANNING);
	}

    // Stops the scan for BLE devices. 
    function stopScan() { 
        if (scanning) { 
            Ble.setScanState(Ble.SCAN_STATE_OFF);
            debug("Scanning stopped."); 
        }
    }

    /* 
        Stops scanning and disconnected any connected
        BLE devices
    */
    function close() { 
        stopScan(); 
        if (device) { 
            Ble.unpairDevice(device); 
        }
    }

    /* 
        Pairs with the given scanResult. 
    */
    private function connect(result) {
		debug("connect");
		stopScan(); 
		Ble.pairDevice(result);
	}

    /* 
        This function is called by a BLE notify when 
        a listened characteristic is changed. In this case
        the function receives a glucose value in the form of
        a byte array, which is decoded and sent to handleBLEValue. 
        The result of handleBLEValue is then sent to glucoseValueCallback
        as a string.  
    */
    function onCharacteristicChanged(ch, value) {
		debug("char read " + ch.getUuid() + " value: " + value);
        var BG = value.decodeNumber(NUMBER_FORMAT_UINT16, {:offset => 0, :endianness => Lang.ENDIAN_LITTLE});
        var callbackString = handleBLEValue(BG);  
        if(glucoseValueCallback != null || callbackString.equals("Blood detected! \nPlease wait...")){
		    glucoseValueCallback.invoke(callbackString); 
        }
	}

    /* 
        If a device is connected successfully, this function
        will keep track of this device as a local variable. It 
        will also set the CCCD value to 1 for asynch notifications
        and invokes connectionCallback to notify this new connection
        state. 
    */
    function onConnectedStateChanged(device, state) {
		debug("connected: " + device.getName() + " " + state);
		if (state == Ble.CONNECTION_STATE_CONNECTED && connectionCallback != null) {
			self.device = device;
            setGlucoseNotifications(1); 
            connectionState = FETCHER_STATE_CONNECTED; 
            connectionCallback.invoke(connectionState); 
		} else {
			self.device = null;
		}
	}

    /* 
        Debug function used to print all UUIDs of 
        a given scanResult. 
    */
    private function scanServiceUUID(iter) {
		for (var x = iter.next(); x != null; x = iter.next()) {
			debug("uuid: " + x);
		}
	}

    /* 
        This function sets the CCCD value of the connected
        device to 1, allowing the device to send asynch 
        notifications for the enclosing characteristic. 
    */
    function setGlucoseNotifications(value) {
		var service;
		var ch;
		var desc;

		if (device == null) {
			debug("setGlucoseNotifications: not connected");
			return;
		}
		debug("setGlucoseNotifications: " + value);

		service = device.getService(GLUCOSE_SERVICE);
		ch = service.getCharacteristic(GLUCOSE_CHARACTERISTIC);
		desc = ch.getDescriptor(GLUCOSE_CHAR_DESCRIPTOR);
		desc.requestWrite([value & 0x01, 0x00]b);
	}

    /* 
        This function is called by BLE notifications every time
        a new device is discovered in the scanning state. The function
        pulls all information available from the device and searches 
        for the glucometer UUIDs specified in the class. If found, it will
        attempt to connect to the device and halt the scanning process. 
    */
    function onScanResults(scanResults) {
		debug("scan results");
		var appearance, name, rssi;
		var mfg, uuids, service;
		for (var result = scanResults.next(); result != null; result = scanResults.next()) {
			appearance = result.getAppearance();
			deviceName = result.getDeviceName();
			rssi = result.getRssi();
			mfg = result.getManufacturerSpecificDataIterator();
			uuids = result.getServiceUuids();

			debug("device: appearance: " + appearance + " name: " + deviceName + " rssi: " + rssi);

            for (var foundID = uuids.next(); foundID != null; foundID = uuids.next()){ 
                debug("uuid: " + foundID);
                if (foundID.equals(GLUCOSE_SERVICE)) { 
                    connect(result); 
                    return; 
                }
            }
            
		}
	}

   

    /* 
        Reads and interprets the integer value of the received 
        glucose concentration. The value 0 is reserved for the
        "Awaiting blood" state and the value 65535 is reserved 
        for the "Blood detected" state. Any value other than those
        two will be interpreted as a valid glucose concentration
        measured in mg/dL. Once a glucose value is interpreted, 
        closes the fetcher to prevent further overwriting of 
        the data. 

        This method returns a string representing either the 
        glucometer state or the glucose concentration. 
    */
    private function handleBLEValue(glucoseConcentration) { 
        var outputString = ""; 
        if (connectionState == FETCHER_STATE_SEARCHING){ 
            return outputString; 
        }

        if (glucoseConcentration == 0){ 
            outputString = "Awaiting blood"; 
        } else if (glucoseConcentration == 65535) {
            outputString = "Blood detected! \nPlease wait..."; 
        } else { 
            outputString = Lang.format("$1$", [glucoseConcentration]); 
            connectionState = FETCHER_STATE_FINISHED; 
            close(); 
        }
        return outputString;
    }

}