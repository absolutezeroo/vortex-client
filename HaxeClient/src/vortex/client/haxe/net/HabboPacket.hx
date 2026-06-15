package vortex.client.haxe.net;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;

/**
 * Minimal packet abstraction for migration.
 * Protocol here is intentionally tiny and explicit:
 *  - first UInt16: message id
 *  - second UInt16: payload length
 *  - payload bytes
 */
class HabboPacket {
    public var messageId:Int;
    public var payload:Bytes;

    public function new(messageId:Int, payload:Bytes) {
        this.messageId = messageId;
        this.payload = payload == null ? Bytes.alloc(0) : payload;
    }

    public static function fromBytes(data:Bytes):HabboPacket {
        if (data == null || data.length < 4) {
            throw "Invalid packet buffer";
        }

        var id = data.getUInt16(0);
        var length = data.getUInt16(2);

        if (data.length < 4 + length) {
            throw 'Invalid packet body length: expected=${length}, actual=${data.length - 4}';
        }

        var payload = Bytes.alloc(length);
        payload.blit(0, data, 4, length);
        return new HabboPacket(id, payload);
    }

    public function toBytes():Bytes {
        var out = new BytesBuffer();
        out.addByte((messageId >> 8) & 0xFF);
        out.addByte(messageId & 0xFF);
        out.addByte((payload.length >> 8) & 0xFF);
        out.addByte(payload.length & 0xFF);
        out.addBytes(payload, 0, payload.length);
        return out.getBytes();
    }

    public function payloadAsString():String {
        return payload.toString();
    }
}
