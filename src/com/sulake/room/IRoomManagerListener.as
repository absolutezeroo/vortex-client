package com.sulake.room {

    public /*dynamic*/interface IRoomManagerListener {

        function roomManagerInitialized(_success:Boolean):void;
        function contentLoaded(_contentType:String, _success:Boolean):void;
        function objectInitialized(_roomId:String, _objectId:int, _category:int):void;
        function objectsInitialized(_roomId:String):void;

    }
}
