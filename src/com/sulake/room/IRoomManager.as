package com.sulake.room {
    import com.sulake.core.runtime.IUnknown;

    public /*dynamic*/interface IRoomManager extends IUnknown {

        function initialize(_configuration:XML, _listener:IRoomManagerListener):Boolean;
        function update(_delta:uint):void;
        function setContentLoader(_contentLoader:IRoomContentLoader):void;
        function addObjectUpdateCategory(_category:int):void;
        function removeObjectUpdateCategory(_category:int):void;
        function createRoom(_roomId:String, _roomData:XML):IRoomInstance;
        function disposeRoom(_roomId:String):Boolean;
        function getRoom(_roomId:String):IRoomInstance;
        function getRoomWithIndex(_index:int):IRoomInstance;
        function getRoomCount():int;
        function isContentAvailable(_contentType:String):Boolean;

    }
}
