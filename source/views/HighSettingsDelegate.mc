import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi;
import Toybox.Application.Storage;

class HighSettingsDelegate extends WatchUi.BehaviorDelegate{

    var view = null;

    function initialize(newView) { 
        view = newView;
        BehaviorDelegate.initialize();
    }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        if(direction == 0){
            var newView = new LowSettingsView();
            WatchUi.pushView(newView, new LowSettingsDelegate(newView), WatchUi.SLIDE_UP);
        }
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

        var area = 24000;
        var center = 210;
        var edge = center*2;

        var area1 = (0.5*(10*((center-30)-y) + (edge-10)*(y-(center-30)) + x*((center-30)-(center-30)))).abs();
        var area2 = (0.5*(x*((center-30)-(center-150)) + (edge-10)*((center-150)-y) + center*(y-(center-30)))).abs();
        var area3 = (0.5*(10*(y-(center-150)) + x*((center-150)-(center-30)) + center*((center-30)-y))).abs();
        System.println(area1+area2+area3);
        if(area1+area2+area3 == area){
            // up pressed
            increaseValue();
            return true;
        }

        area1 = (0.5*(10*((center+30)-y) + (edge-10)*(y-(center+30)) + x*((center+30)-(center+30)))).abs();
        area2 = (0.5*(x*((center+30)-(center+150)) + (edge-10)*((center+150)-y) + center*(y-(center+30)))).abs();
        area3 = (0.5*(10*(y-(center+150)) + x*((center+150)-(center+30)) + center*((center+30)-y))).abs();
        if(area1+area2+area3 == area){
            // down pressed
            decreaseValue();
            return true;
        }
        return true;
    }

    function decreaseValue(){
        var val = Storage.getValue("high")-10;
        Storage.setValue("high", val);
        view.requestUpdate();
    }

    function increaseValue(){
        var val = Storage.getValue("high")+10;
        Storage.setValue("high", val);
        view.requestUpdate();
    }
}