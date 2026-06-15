package vortex.client.haxe.config;

import haxe.Json;

class ClientConfig {
    public var clientType:String;
    public var environment:String;
    public var debug:Bool;
    public var server:String;
    public var port:Int;

    public function new(clientType:String, environment:String, debug:Bool, server:String, port:Int) {
        this.clientType = clientType;
        this.environment = environment;
        this.debug = debug;
        this.server = server;
        this.port = port;
    }

    public static function fromJson(value:String):ClientConfig {
        var raw:Dynamic = Json.parse(value);
        return new ClientConfig(
            raw.clientType == null ? "haxe" : cast(raw.clientType, String),
            raw.environment == null ? "local" : cast(raw.environment, String),
            raw.debug == null ? false : cast(raw.debug, Bool),
            raw.server == null ? "127.0.0.1" : cast(raw.server, String),
            raw.port == null ? 30000 : cast(raw.port, Int)
        );
    }

    public function toString():String {
        return 'clientType=${clientType}, environment=${environment}, debug=${debug}, server=${server}, port=${port}';
    }
}
