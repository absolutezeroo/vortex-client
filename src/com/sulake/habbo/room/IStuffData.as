package com.sulake.habbo.room
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;

    public /*dynamic*/ interface IStuffData 
    {

        function initializeFromIncomingMessage(wrapper:IMessageDataWrapper):void;
        function initializeFromRoomObjectModel(model:IRoomObjectModel):void;
        function writeRoomObjectModel(model:IRoomObjectModelController):void;
        function getLegacyString():String;
        function getJSONValue(key:String):String;
        function compare(stuffData:IStuffData):Boolean;
        function set flags(flags:int):void;
        function get uniqueSerialNumber():int;
        function get uniqueSeriesSize():int;
        function set uniqueSerialNumber(uniqueSerialNumber:int):void;
        function set uniqueSeriesSize(uniqueSeriesSize:int):void;
        function get rarityLevel():int;

    }
}