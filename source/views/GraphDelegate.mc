import Toybox.Lang; 
import Toybox.System; 
import Toybox.WatchUi;
import Toybox.Application.Storage;

class GraphDelegate extends WatchUi.BehaviorDelegate{

    function initialize() { 
        BehaviorDelegate.initialize();
    }

    function onSwipe(swipeEvent) {
        var direction = swipeEvent.getDirection();
        if(direction == 0){
            var newView = new HighSettingsView();
            WatchUi.pushView(newView, new HighSettingsDelegate(newView), WatchUi.SLIDE_UP);
        }
        else if(direction == 2){
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

        var area = 1250;

        // dc.fillPolygon([[90,90],[140,65],[140,115]]); // left
        // dc.fillPolygon([[325,90],[275,65],[275,115]]); // right

        var area1 = (0.5*(90*(65-y) + 140*(y-90) + x*(90-65))).abs();
        var area2 = (0.5*(x*(65-115) + 140*(115-y) + 140*(y-65))).abs();
        var area3 = (0.5*(90*(y-115) + x*(115-90) + 140*(90-y))).abs();
        if(area1+area2+area3 == area){
            // left pressed
            shiftLeft();
            return true;
        }

        area1 = (0.5*(325*(65-y) + 275*(y-90) + x*(90-65))).abs();
        area2 = (0.5*(x*(65-115) + 275*(115-y) + 275*(y-65))).abs();
        area3 = (0.5*(325*(y-115) + x*(115-90) + 275*(90-y))).abs();
        if(area1+area2+area3 == area){
            // right pressed
            shiftRight();
            return true;
        }

        return true;
    }

    function shiftLeft() {
        var idx = Storage.getValue("idx");
        if(idx >= 4){
            idx = idx - 4;
            Storage.setValue("idx",idx);
        } else if (idx > 0) {
            Storage.setValue("idx",0);
        }
    }

    function shiftRight() {
        var idx = Storage.getValue("idx");
        var arrSize = Storage.getValue("meas").size();
        if(arrSize > idx + 4){
            idx = idx + 4;
            Storage.setValue("idx",idx);
        } else if (arrSize >= 5) {
            Storage.setValue("idx",arrSize-5);
        } else {
            Storage.setValue("idx", 0);
        }
    }

}