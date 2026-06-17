package com.sulake.room {
    import com.sulake.room.object.IRoomObject;

    public /*dynamic*/interface IRoomInstanceContainer {

        function createRoomObject(_roomId:String, _objectId:int, _objectType:String, _category:int):IRoomObject;
        function createRoomObjectManager():IRoomObjectManager;

    }
}
