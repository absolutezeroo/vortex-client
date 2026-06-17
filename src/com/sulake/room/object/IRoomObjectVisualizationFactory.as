package com.sulake.room.object
{
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.room.object.visualization.IRoomObjectGraphicVisualization;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;

    public /*dynamic*/ interface IRoomObjectVisualizationFactory extends IUnknown 
    {

        function createRoomObjectVisualization(_visualizationType:String):IRoomObjectGraphicVisualization;
        function createGraphicAssetCollection():IGraphicAssetCollection;
        function getRoomObjectVisualizationData(_type:String, _visualizationType:String, _visualizationData:XML):IRoomObjectVisualizationData;

    }
}

