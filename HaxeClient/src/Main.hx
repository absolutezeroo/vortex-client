import haxe.Timer;
import vortex.client.haxe.Bootstrap;

class Main {
    public static function main():Void {
        // Start with defaults in browser-friendly mode.
        var bootstrap = new Bootstrap();
        bootstrap.start();

        // Keep process alive when running under local runners that stop on script end.
        Timer.delay(function () {
            // no-op heartbeat
        }, 1);
    }
}
