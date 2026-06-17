package com.sulake.room.object.logic
{
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.IEventDispatcher;

    public /*dynamic*/ interface IRoomObjectEventHandler extends IRoomObjectMouseHandler 
    {

        function set object(_object:IRoomObjectController):void;
        function get object():IRoomObjectController;
        function dispose():void;
        function initialize(_data:XML):void;
        function tearDown():void;
        function update(_timeSinceUpdate:int):void;
        function processUpdateMessage(_message:RoomObjectUpdateMessage):void;
        function useObject():void;
        function set eventDispatcher(_dispatcher:IEventDispatcher):void;
        function get eventDispatcher():IEventDispatcher;
        function getEventTypes():Array;
        function get widget():String;
        function get contextMenu():String;

    }
}

