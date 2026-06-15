package onBoardingHc
{
    import flash.display.Sprite;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.display.Bitmap;
    import flash.geom.Matrix;

    public class Background extends Sprite implements IDisposable
    {

        private static const background_tiles_png:Class = HabboBackground_background_tiles_png;

        private var _backgroundImage:BitmapData;
        private var _disposed:Boolean;
        private var _tileSprite:Sprite;

        public function Background()
        {
            addEventListener("addedToStage", onAddedToStage);
            addEventListener("removedFromStage", onRemovedFromStage);
        }

        public function dispose():void
        {
            _disposed = true;

            while (numChildren > 0)
            {
                removeChildAt(0);
            };
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        private function onRemovedFromStage(_arg_1:Event):void
        {
        }

        protected function onAddedToStage(_arg_1:Event):void
        {
            _tileSprite = new Sprite();

            var _local_2:Bitmap = new background_tiles_png();
            _backgroundImage = _local_2.bitmapData;
            addChild(_tileSprite);
            resize();
        }

        public function resize():void
        {
            var _local_1:Matrix;

            if (stage)
            {
                var _local_2:Array = [809599, 801381];
                var _local_3:Array = [1, 1];
                var _local_4:Array = [127, 0xFF];
                _local_1 = new Matrix();
                _local_1.createGradientBox(50, 100, 0, 0, 0);
                _local_1.rotate((3.14159265358979 / 2));
                _local_1.scale((stage.stageWidth / 50), (stage.stageHeight / 100));
                graphics.beginGradientFill("linear", _local_2, _local_3, _local_4, _local_1, "pad");
                graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);

                if (_tileSprite != null)
                {
                    _tileSprite.graphics.clear();
                    _tileSprite.graphics.beginBitmapFill(_backgroundImage);
                    _tileSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
                    _tileSprite.graphics.endFill();
                };
            };
        }

    }
}
