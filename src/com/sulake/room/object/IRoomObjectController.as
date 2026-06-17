package com.sulake.room.object
{
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;

    public /*dynamic*/ interface IRoomObjectController extends IRoomObject 
    {

        function dispose():void;
        function setInitialized(_initialized:Boolean):void;
        function setLocation(_location:IVector3d):void;
        function setDirection(_direction:IVector3d):void;
        function setVisualization(_visualization:IRoomObjectVisualization):void;
        function setState(_state:int, _stateIndex:int):Boolean;
        function setEventHandler(_handler:IRoomObjectEventHandler):void;
        function getEventHandler():IRoomObjectEventHandler;
        function getModelController():IRoomObjectModelController;

    }
}

