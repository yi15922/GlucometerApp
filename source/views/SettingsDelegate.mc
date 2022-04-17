import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi;
import Toybox.Application.Storage;

class SettingsDelegate extends WatchUi.BehaviorDelegate{

    var view = null;

    function initialize(newView) { 
        view = newView;
        BehaviorDelegate.initialize();
    }

    // function onSelect() as Boolean {
    //     //WatchUi.pushView(new InformationView(), new InformationDelegate(), WatchUi.SLIDE_UP);
    //     return true;
    // }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        if(direction == 2){
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onTap(clickEvent) {
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];

        var area = 1125;

        // dc.fillPolygon([[250,160],[300,160],[275,115]]); // high value up
        // dc.fillPolygon([[250,170],[300,170],[275,215]]); // high value down

        // dc.fillPolygon([[250,280],[300,280],[275,235]]); // low value up
        // dc.fillPolygon([[250,290],[300,290],[275,335]]); // low value down

        var area1 = (0.5*(250*(160-y) + 300*(y-160) + x*(160-160))).abs();
        var area2 = (0.5*(x*(160-115) + 300*(115-y) + 275*(y-160))).abs();
        var area3 = (0.5*(250*(y-115) + x*(115-160) + 275*(160-y))).abs();
        if(area1+area2+area3 == area){
            // high value up pressed
            increaseHigh();
            return true;
        }

        area1 = (0.5*(x*(170-215) + 300*(215-y) + 275*(y-170))).abs();
        area2 = (0.5*(250*(y-215) + x*(215-170) + 275*(170-y))).abs();
        area3 = (0.5*(250*(170-y) + 300*(y-170) + x*(170-170))).abs();
        if(area1+area2+area3 == area){
            // high value down pressed
            decreaseHigh();
            return true;
        }

        area1 = (0.5*(x*(280-235) + 300*(235-y) + 275*(y-280))).abs();
        area2 = (0.5*(250*(y-235) + x*(235-280) + 275*(280-y))).abs();
        area3 = (0.5*(250*(280-y) + 300*(y-280) + x*(280-280))).abs();
        if(area1+area2+area3 == area){
            // low value up pressed
            increaseLow();
            return true;
        }

        area1 = (0.5*(x*(290-335) + 300*(335-y) + 275*(y-290))).abs();
        area2 = (0.5*(250*(y-335) + x*(335-290) + 275*(290-y))).abs();
        area3 = (0.5*(250*(290-y) + 300*(y-290) + x*(290-290))).abs();
        if(area1+area2+area3 == area){
            // low value down pressed
            decreaseLow();
            return true;
        }
        return true;
    }

    function decreaseLow(){
        var lowVal = Storage.getValue("low")-10;
        Storage.setValue("low", lowVal);
        view.requestUpdate();
        // var lowValueText = View.findDrawableById("LowValue") as Text;
        // lowValueText.setText(lowVal.toString());
    }

    function increaseLow(){
        var lowVal = Storage.getValue("low")+10;
        Storage.setValue("low", lowVal);
        view.requestUpdate();
        // var lowValueText = View.findDrawableById("LowValue") as Text;
        // lowValueText.setText(lowVal.toString());
    }

    function decreaseHigh(){
        var highVal = Storage.getValue("high")-10;
        Storage.setValue("high", highVal);
        view.requestUpdate();
        // var highValueText = View.findDrawableById("HighValue") as Text;
        // highValueText.setText(highVal.toString());
    }

    function increaseHigh(){
        var highVal = Storage.getValue("high")+10;
        Storage.setValue("high", highVal);
        view.requestUpdate();
        // var highValueText = View.findDrawableById("HighValue") as Text;
        // highValueText.setText(highVal.toString());
    }
}