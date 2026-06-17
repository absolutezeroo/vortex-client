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

        private function onRemovedFromStage(stageEvent:Event):void
        {
        }

        protected function onAddedToStage(stageEvent:Event):void
        {
            _tileSprite = new Sprite();

            var tileBitmap:Bitmap = new background_tiles_png();
            _backgroundImage = tileBitmap.bitmapData;
            addChild(_tileSprite);
            resize();
        }

        public function resize():void
        {
            var transform:Matrix;

            if (stage)
            {
                var gradientColors:Array = [809599, 801381];
                var gradientAlphas:Array = [1, 1];
                var gradientRatios:Array = [127, 0xFF];
                transform = new Matrix();
                transform.createGradientBox(50, 100, 0, 0, 0);
                transform.rotate((3.14159265358979 / 2));
                transform.scale((stage.stageWidth / 50), (stage.stageHeight / 100));
                graphics.beginGradientFill("linear", gradientColors, gradientAlphas, gradientRatios, transform, "pad");
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
