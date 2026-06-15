package vortex.client.haxe.net;

import haxe.Timer;
import haxe.io.Bytes;

typedef PacketHandler = (HabboPacket) -> Void;
typedef VoidHandler = () -> Void;

class MockSocket {
    public var onOpen:VoidHandler;
    public var onClose:VoidHandler;
    public var onMessage:PacketHandler;

    private final host:String;
    private final port:Int;

    public function new(host:String, port:Int) {
        this.host = host;
        this.port = port;
    }

    public function connect():Void {
        // Simulate async connect
        Timer.delay(function () {
            if (onOpen != null) {
                onOpen();
            }

            // Simulate an immediate handshake ACK to bootstrap flow.
            if (onMessage != null) {
                var ack = new HabboPacket(1, Bytes.ofString("ack.handshake"));
                onMessage(ack);
            }
        }, 120);
    }

    public function send(frame:HabboPacket):Void {
        // No-op for now; dedicated transport will replace this.
        if (frame == null || frame.messageId < 0) {
            throw "Invalid frame";
        }
    }

    public function close():Void {
        if (onClose != null) {
            Timer.delay(function () {
                onClose();
            }, 20);
        }
    }
}
