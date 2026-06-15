package vortex.client.haxe.core;

class AppState {
    public var screen:String;
    public var debug:Bool;
    public var lastError:String;

    public function new(?screen:String = "init") {
        this.screen = screen;
        this.debug = false;
        this.lastError = null;
    }

    public function setScreen(value:String):Void {
        this.screen = value;
        trace('AppState.screen=' + value);
    }

    public function setDebug(value:Bool):Void {
        this.debug = value;
        trace('AppState.debug=' + value);
    }

    public function setLastError(value:String):Void {
        this.lastError = value;
        if (value == null) {
            trace("AppState.lastError=cleared");
        } else {
            trace('AppState.lastError=' + value);
        }
    }
}
