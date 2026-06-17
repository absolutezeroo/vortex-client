package com.sulake.room.object.visualization
{
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

    public /*dynamic*/ interface IRoomObjectGraphicVisualization extends IRoomObjectVisualization 
    {

        function get assetCollection():IGraphicAssetCollection;
        function set assetCollection(_assetCollection:IGraphicAssetCollection):void;
        function setExternalBaseUrls(_normal:String, _avatar:String, _override:Boolean):void;

    }
}

