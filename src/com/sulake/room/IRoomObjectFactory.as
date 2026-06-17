package com.sulake.room {
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import flash.events.IEventDispatcher;

    public /*dynamic*/interface IRoomObjectFactory extends IUnknown {

        function addObjectEventListener(_callback:Function):void;
        function removeObjectEventListener(_callback:Function):void;
        function createRoomObjectLogic(_logicType:String):IRoomObjectEventHandler;
        function createRoomObjectManager():IRoomObjectManager;
        function get events():IEventDispatcher;

    }
}
