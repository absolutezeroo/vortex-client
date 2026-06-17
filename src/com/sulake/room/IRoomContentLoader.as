package com.sulake.room {
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.object.IRoomObject;

    public /*dynamic*/interface IRoomContentLoader {

        function dispose():void;
        function getPlaceHolderType(_contentType:String):String;
        function getPlaceHolderTypes():Array;
        function getContentType(_contentType:String):String;
        function hasInternalContent(_contentType:String):Boolean;
        function loadObjectContent(_contentType:String, _events:IEventDispatcher):Boolean;
        function insertObjectContent(_contentCategory:int, _objectType:int, _assetLibrary:IAssetLibrary):Boolean;
        function getVisualizationType(_contentType:String):String;
        function getLogicType(_contentType:String):String;
        function hasVisualizationXML(_contentType:String):Boolean;
        function getVisualizationXML(_contentType:String):XML;
        function hasAssetXML(_contentType:String):Boolean;
        function getAssetXML(_contentType:String):XML;
        function hasLogicXML(_contentType:String):Boolean;
        function getLogicXML(_contentType:String):XML;
        function getGraphicAssetCollection(_contentType:String):IGraphicAssetCollection;
        function roomObjectCreated(_roomObject:com.sulake.room.object.IRoomObject, _roomId:String):void;

    }
}
