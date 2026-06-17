package com.sulake.room {
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.renderer.IRoomRendererBase;

    public /*dynamic*/interface IRoomInstance {

        function getNumber(_key:String):Number;
        function setNumber(_key:String, _value:Number, _isReadOnly:Boolean = false):void;
        function getString(_key:String):String;
        function setString(_key:String, _value:String, _isReadOnly:Boolean = false):void;
        function dispose():void;
        function update():void;
        function createRoomObject(_objectId:int, _objectType:String, _category:int):IRoomObject;
        function getObject(_objectId:int, _category:int):IRoomObject;
        function getObjects(_category:int):Array;
        function disposeObject(_objectId:int, _category:int):Boolean;
        function getObjectCount(_category:int):int;
        function getObjectWithIndexAndType(_index:int, _objectType:String, _category:int):IRoomObject;
        function getObjectCountForType(_objectType:String, _category:int):int;
        function getObjectWithIndex(_index:int, _category:int):IRoomObject;
        function disposeObjects(_category:int):int;
        function setRenderer(_renderer:IRoomRendererBase):void;
        function getRenderer():IRoomRendererBase;

    }
}
