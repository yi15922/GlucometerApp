import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi; 
using Toybox.BluetoothLowEnergy as Ble; 

class BluetoothFetcher extends Ble.BleDelegate { 

    const GLUCOSE_SERVICE = Ble.stringToUuid("00001808-0000-1000-8000-00805F9B34FB");
    const GLUCOSE_CHARACTERISTIC = Ble.stringToUuid("00002A18-0000-1000-8000-00805F9B34FB"); 
    const GLUCOSE_CHAR_DESCRIPTOR = Ble.cccdUuid(); 
    const GLUCOMETER_NAME = "glucose"; 

    var scanning = false;
    var device = null; 
    var deviceName = "null"; 
    var profileRegistered = false; 
    var connectionCallback; 
    var glucoseValueCallback;

    function debug(str) {
		System.println("[ble] " + str);
	}

    function initialize(connectionCallbackMethod, glucoseValueCallbackMethod){ 
        debug("Initializing Bluetooth Fetcher..."); 
        BleDelegate.initialize(); 
        connectionCallback = connectionCallbackMethod; 
        glucoseValueCallback = glucoseValueCallbackMethod; 
    }

    function onProfileRegister(uuid, status) {
		debug("registered: " + uuid + " " + status);
	}

    function registerProfiles() { 
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

    function onScanStateChange(scanState, status) {
		debug("scanstate: " + scanState + " " + status);
		if (scanState == Ble.SCAN_STATE_SCANNING) {
			scanning = true;
		} else {
			scanning = false;
		}
	}

    function startScan() {
        debug("Scanning for nearby glucometer devices... ");
		registerProfiles();
		Ble.setScanState(Ble.SCAN_STATE_SCANNING);
	}

    function stopScan() { 
        if (scanning) { 
            Ble.setScanState(Ble.SCAN_STATE_OFF);
            debug("Scanning stopped."); 
        }
    }

    function close() { 
        stopScan(); 
        if (device) { 
            Ble.unpairDevice(device); 
        }
    }

    function getConnectedDeviceName() { 
        if (device){ 
            return device.getName(); 
        }
    }

    private function connect(result) {
		debug("connect");
		stopScan(); 
		Ble.pairDevice(result);
	}

    function onCharacteristicChanged(ch, value) {
		debug("char read " + ch.getUuid() + " value: " + value);
		glucoseValueCallback.invoke(value); 
	}

    function onConnectedStateChanged(device, state) {
		debug("connected: " + device.getName() + " " + state);
		if (state == Ble.CONNECTION_STATE_CONNECTED) {
			self.device = device;
            setGlucoseNotifications(1); 
            connectionCallback.invoke(); 
		} else {
			self.device = null;
		}
	}

    private function scanServiceUUID(iter) {
		for (var x = iter.next(); x != null; x = iter.next()) {
			debug("uuid: " + x);
		}
	}

    function setGlucoseNotifications(value) {
		var service;
		var ch;
		var desc;

		if (device == null) {
			debug("setButtonNotifications: not connected");
			return;
		}
		debug("setButtonNotifications: " + value);

		service = device.getService(GLUCOSE_SERVICE);
		ch = service.getCharacteristic(GLUCOSE_CHARACTERISTIC);
		desc = ch.getDescriptor(GLUCOSE_CHAR_DESCRIPTOR);
		desc.requestWrite([value & 0x01, 0x00]b);
	}

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

}