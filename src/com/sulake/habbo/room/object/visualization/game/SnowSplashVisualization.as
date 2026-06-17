package com.sulake.habbo.room.object.visualization.game
{
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.SnowballVisualizationData;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;

    public class SnowSplashVisualization extends RoomObjectSpriteVisualization 
    {

        private static const FRAME_ASSET_NAMES:Array = ["snowball_splash_1", "snowball_splash_2", "snowball_splash_3"];

        private var _frameNumber:int = 0;
        private var _SafeStr_690:SnowballVisualizationData;

        public function get isDone():Boolean
        {
            return (!(_frameNumber < FRAME_ASSET_NAMES.length));
        }

        override public function initialize(visualizationData:IRoomObjectVisualizationData):Boolean
        {
            var frameAsset:BitmapDataAsset;
            _SafeStr_690 = (visualizationData as SnowballVisualizationData);
            createSprites(1);
            frameAsset = (_SafeStr_690.assets.getAssetByName(FRAME_ASSET_NAMES[_frameNumber]) as BitmapDataAsset);
            getSprite(0).asset = (frameAsset.content as BitmapData);
            return (true);
        }

        override public function update(geometry:IRoomGeometry, updateId:int, hasUpdate:Boolean, isVisible:Boolean):void
        {
            _frameNumber++;
            getSprite(0).asset = ((isDone) ? null : (_SafeStr_690.assets.getAssetByName(FRAME_ASSET_NAMES[_frameNumber]).content as BitmapData));
        }

    }
}
