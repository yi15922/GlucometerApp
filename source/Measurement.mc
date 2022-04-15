import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class Measurement {

    private var time;
    private var glucose;

    public function initialize(measuredTime,measuredGlucose){
        time = measuredTime;
        glucose = measuredGlucose;
    }

    public function getTime(){
        return time;
    }

    public function getGlucose(){
        return glucose;
    }

}