#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <ArduinoBLE.h>


#define TESTPIN A2
#define BIASPIN A0
#define BIASVOLTAGE 95
#define CONTROL_LV_1_BG 86
#define CONTROL_LV_2_BG 209
#define CONTROL_LV_1_OUTPUT 1961
#define CONTROL_LV_2_OUTPUT 1874

LiquidCrystal_I2C lcd(0x27, 16, 2);
// Initializes a BLE service with UUID for glucometer
BLEService glucoseService("1808"); 
// Initializes a BLE characteristic with UUID of glucose measurement
// Also initializes the data field as a 2 byte value 0x0000
BLECharacteristic glucoseCharacteristic("2A18", BLERead | BLENotify, 2, 0);

/*
  Sets up the LCD, serial, BLE, and biasing components
  of the glucometer. 
*/
void setup() {
  pinMode(TESTPIN, INPUT); 
  
  Serial.begin(9600); 

  setUpLCD(); 
  setUpBLE(); 
  
  analogReadResolution(12); 
  analogWrite(BIASPIN, BIASVOLTAGE); 
  delay(2000); 
}


// Sets up an LCD peripheral for debugging
void setUpLCD(){ 
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0); 
  lcd.print("Glucometer ready"); 
}

/*
  Sets up the BLE profile of the device. This sets the 
  UUID of the device service as glucose, the characteristic, 
  as glucose measurement, and a CCCD descriptor to allow 
  requests for asynch updates. 
*/
void setUpBLE() { 
  BLE.setDeviceName("Arduino"); 
  BLE.setLocalName("Arduino"); 

  if (!BLE.begin()){ 
    Serial.println("BLE did not initialize"); 
  } else { 
    Serial.print("BLE initialized with UUID: "); 
    Serial.println(glucoseService.uuid()); 
  }
  
  BLE.setAdvertisedService(glucoseService); 
  glucoseService.addCharacteristic(glucoseCharacteristic); 
  BLE.addService(glucoseService); 

  BLE.advertise(); 
  
}

/*
  Transmits the ready state of the glucometer. 
  The value transmitted to BLE should 0. 
*/
void readyState(){ 
  Serial.println("Waiting for sample..."); 
  glucoseCharacteristic.writeValue((uint16_t)0x0000); 
}

/* 
  Waits for a BLE central to connect to device. This function
  will stall until a central connects. 
*/
void waitForBLECentral(){ 
  BLEDevice bleCentral; 
  while (!bleCentral){ 
    bleCentral = BLE.central(); 
  } 
  Serial.print("Connected to central: "); 
  Serial.println(bleCentral.address()); 
  Serial.println("Central is connected, gracefully infinite looping"); 
}

/*
  Transmits the blood detected state
  via BLE, which is 0xffff. 
*/
void bloodDetected() { 
  lcd.setCursor(0,0);
  lcd.clear(); 
  Serial.println("Blood detected!"); 
  lcd.print("Blood detected!");
  lcd.setCursor(0,1); 
  lcd.print("Please wait..."); 
  glucoseCharacteristic.writeValue((uint16_t)0xffff); 
}

/*
  Transmits the calculated glucose concentration
  as an unsigned 16-bit integer. 
*/
void transmitResult(int bgLevel){ 
  Serial.print("BG level: "); 
  Serial.print(bgLevel); 
  Serial.println(" mg/dL");
  lcd.clear(); 
  lcd.setCursor(0, 0); 
  lcd.print("BG:");
  lcd.setCursor(0, 1); 
  lcd.print(bgLevel); 
  lcd.setCursor(7, 1); 
  lcd.print("mg/dL"); 
  glucoseCharacteristic.writeValue((uint16_t)bgLevel); 
}

/* 
  Main loop of the system: waits for a central to connect, 
  then transmits the ready state until blood is detected. 
  After detection, measure the ADC value and convert to 
  a BG value, and transmits it via bluetooth. The system
  then stalls until reset. 
*/
void loop() {
  waitForBLECentral(); 
  readyState(); 
  if (analogRead(TESTPIN)<2030){ 
    //printAllAnalogValues(); 
    bloodDetected(); 

    float rawOutput = takeMeasurement(TESTPIN); 
    float bgLevel = convertToBG(rawOutput);

    transmitResult(bgLevel); 
    
    while (1) {}
  }
  delay(100); 
}

/*  takes an analog pin number and waits for 5 seconds 
 *  to read the output. Then reads the last 4 outputs 
 *  and takes the average. 
 *  
 *  Returns a float average of the last 4 analog values. 
 */
float takeMeasurement(int pinNumber){ 
  delay(4500); 
  float resultSum = 0.0; 
  for (int i = 0; i < 4; i++){ 
    resultSum += analogRead(pinNumber); 
    delay(100); 
  }
  return resultSum/4.0; 
}

/* Calculates a linear equation using calibration values, 
 *  then uses the equation to convert to a BG value
 *  measured in mg/dL. 
 *  
 *  Returns a float value of BG concentration in mg/dL. 
 */
float convertToBG(float rawOutput){ 
  float slope = (CONTROL_LV_1_BG-CONTROL_LV_2_BG)/(CONTROL_LV_1_OUTPUT-CONTROL_LV_2_OUTPUT); 
  float b = CONTROL_LV_1_BG-(slope*CONTROL_LV_1_OUTPUT); 
  float bg = slope*rawOutput+b; 
  return bg; 
}

/* Prints out all analog values made in the duration of 
 *  a measurement. This is used for debugging and calibration
 *  purposes. 
 */
void printAllAnalogValues(){ 
  unsigned long startTime = millis(); 
  unsigned long waitTime = 5000; 
  while(millis() - startTime <= waitTime){ 
    int finalValue = analogRead(TESTPIN);
    Serial.println(finalValue); 
    delay(100);    
    }
}
