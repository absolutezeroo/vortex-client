package vortex.client.haxe;

import haxe.Timer;
import haxe.Json;
import haxe.io.Bytes;
import haxe.log.Logger;

import vortex.client.haxe.core.AppState;
import vortex.client.haxe.config.ClientConfig;
import vortex.client.haxe.net.HabboPacket;
import vortex.client.haxe.net.MockSocket;

class Bootstrap {
    private static inline var DEFAULT_CONFIG_JSON:String =
        '{"clientType":"haxe","environment":"local","debug":true,"server":"127.0.0.1","port":30000}';

    private var state:AppState;
    private var config:ClientConfig;
    private var socket:MockSocket;

    public function new():Void {
        state = new AppState();
        config = ClientConfig.fromJson(DEFAULT_CONFIG_JSON);
    }

    public function start():Void {
        trace('Starting Haxe migration bootstrap...');

        state.setScreen("loading");
        state.setDebug(config.debug);
        state.setLastError(null);

        Logger.log("vortex-migration", "Config loaded: " + config.toString());

        socket = new MockSocket(config.server, config.port);
        socket.onOpen = onSocketOpen;
        socket.onClose = onSocketClosed;
        socket.onMessage = onSocketMessage;
        socket.connect();
    }

    private function onSocketOpen():Void {
        state.setScreen("connected");
        trace('Socket connected to ${config.server}:${config.port}');

        // Keep the packet shape stable now, fill real fields later.
        var hello = new HabboPacket(1, Bytes.ofString("migration.hello"));
        socket.send(hello);
    }

    private function onSocketClosed():Void {
        state.setScreen("disconnected");
        trace("Socket closed.");
    }

    private function onSocketMessage(frame:HabboPacket):Void {
        if (frame.messageId == 1) {
            state.setScreen("handshake_done");
            trace("Handshake acknowledged by mock transport.");
            return;
        }

        state.setLastError('Unhandled packet id=${frame.messageId}');
        trace(state.lastError);
    }
}
