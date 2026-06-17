package onBoardingHcUi
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.habbo.utils._SafeStr_25;

    public class NineSplitSprite
    {

        private static const border_sunk_png:Class = HabboNineSplitSprite_border_sunk_png;
        private static const dark_popup_png:Class = HabboNineSplitSprite_dark_popup_png;
        private static const divider_png:Class = HabboNineSplitSprite_divider_png;
        private static const frame_png:Class = HabboNineSplitSprite_frame_png;
        private static const input_corrected_png:Class = HabboNineSplitSprite_input_corrected_png;
        private static const input_error_png:Class = HabboNineSplitSprite_input_error_png;
        private static const input_field_png:Class = HabboNineSplitSprite_input_field_png;
        private static const input_corrected_hitch_png:Class = HabboNineSplitSprite_input_corrected_hitch_png;
        private static const input_error_hitch_png:Class = HabboNineSplitSprite_input_error_hitch_png;
        private static const input_field_hitch_png:Class = HabboNineSplitSprite_input_field_hitch_png;
        private static const white_balloon_png:Class = HabboNineSplitSprite_white_balloon_png;
        private static const block_dark_base_png:Class = HabboNineSplitSprite_block_dark_base_png;
        private static const BORDER_SUNK_BITMAP:Bitmap = new border_sunk_png();
        public static const DARK_POPUP_BITMAP:Bitmap = new dark_popup_png();
        private static const DIVIDER_BITMAP:Bitmap = new divider_png();
        private static const FRAME_BITMAP:Bitmap = new frame_png();
        private static const INPUT_CORRECTED_BITMAP:Bitmap = new input_corrected_png();
        private static const INPUT_ERROR_BITMAP:Bitmap = new input_error_png();
        private static const INPUT_FIELD_BITMAP:Bitmap = new input_field_png();
        private static const INPUT_CORRECTED_HITCH_BITMAP:Bitmap = new input_corrected_hitch_png();
        private static const INPUT_ERROR_HITCH_BITMAP:Bitmap = new input_error_hitch_png();
        private static const INPUT_FIELD_HITCH_BITMAP:Bitmap = new input_field_hitch_png();
        private static const WHITE_BALLOON_BITMAP:Bitmap = new white_balloon_png();
        private static const DARK_BALLOON_BITMAP:Bitmap = new block_dark_base_png();

        public static var BALLOON_HIGHLIGHTED:NineSplitSprite = new NineSplitSprite(WHITE_BALLOON_BITMAP.bitmapData, new <int>[5, 4, 5], new <int>[11, 1, 5]);
        public static var BALLOON_SHADED:NineSplitSprite = new NineSplitSprite(WHITE_BALLOON_BITMAP.bitmapData, new <int>[5, 4, 5], new <int>[5, 1, 11]);
        public static var BORDER_SUNK:NineSplitSprite = new NineSplitSprite(BORDER_SUNK_BITMAP.bitmapData, new <int>[12, 2, 6], new <int>[14, 2, 4]);
        public static var DARK_POPUP:NineSplitSprite = new NineSplitSprite(DARK_POPUP_BITMAP.bitmapData, new <int>[5, 5, 5], new <int>[5, 12, 5]);
        public static var DIVIDER:NineSplitSprite = new NineSplitSprite(DIVIDER_BITMAP.bitmapData, new <int>[2, 2, 2], new <int>[8, 0, 0]);
        public static var FRAME:NineSplitSprite = new NineSplitSprite(FRAME_BITMAP.bitmapData, new <int>[4, 3, 4], new <int>[5, 1, 7]);
        public static var INPUT_CORRECTED:NineSplitSprite = new NineSplitSprite(INPUT_CORRECTED_BITMAP.bitmapData, new <int>[5, 2, 5], new <int>[5, 2, 6]);
        public static var INPUT_ERROR:NineSplitSprite = new NineSplitSprite(INPUT_ERROR_BITMAP.bitmapData, new <int>[5, 2, 5], new <int>[5, 2, 6]);
        public static var INPUT_FIELD:NineSplitSprite = new NineSplitSprite(INPUT_FIELD_BITMAP.bitmapData, new <int>[5, 4, 5], new <int>[7, 2, 5]);
        public static var INPUT_CORRECTED_HITCH:NineSplitSprite = new NineSplitSprite(INPUT_FIELD_HITCH_BITMAP.bitmapData, new <int>[10, 310, 10], new <int>[5, 21, 5]);
        public static var INPUT_ERROR_HITCH:NineSplitSprite = new NineSplitSprite(INPUT_ERROR_HITCH_BITMAP.bitmapData, new <int>[10, 310, 10], new <int>[5, 21, 5]);
        public static var INPUT_FIELD_HITCH:NineSplitSprite = new NineSplitSprite(INPUT_FIELD_HITCH_BITMAP.bitmapData, new <int>[10, 310, 10], new <int>[5, 21, 5]);
        public static var DARK_BALLOON:NineSplitSprite = new NineSplitSprite(DARK_BALLOON_BITMAP.bitmapData, new <int>[5, 4, 5], new <int>[11, 1, 5]);

        private var _bitmapData:BitmapData;
        private var _widths:Vector.<int>;
        private var _heights:Vector.<int>;

        public function NineSplitSprite(sourceBitmapData:BitmapData, sourceWidths:Vector.<int>, sourceHeights:Vector.<int>)
        {
            _bitmapData = sourceBitmapData;
            _widths = sourceWidths;
            _heights = sourceHeights;
        }

        public function render(targetWidth:int, targetHeight:int):Bitmap
        {
            var targetBitmap:Bitmap = new Bitmap(new BitmapData(targetWidth, targetHeight, true, 0xFFFFFF));
            renderOn(targetBitmap, new Rectangle(0, 0, targetWidth, targetHeight));
            return (targetBitmap);
        }

        public function renderOn(targetBitmap:Bitmap, targetArea:Rectangle):void
        {
            var column:int;
            var row:int;
            var sourceRect:Rectangle;
            var destinationRect:Rectangle;
            var originX:int = targetArea.x;
            var originY:int = targetArea.y;
            var targetWidth:int = targetArea.width;
            var targetHeight:int = targetArea.height;
            var sourceXStarts:Vector.<int> = new <int>[0, _widths[0], (_widths[0] + _widths[1])];
            var sourceYStarts:Vector.<int> = new <int>[0, _heights[0], (_heights[0] + _heights[1])];
            var sourceWidths:Vector.<int> = _widths;
            var sourceHeights:Vector.<int> = _heights;
            var targetXStarts:Vector.<int> = new <int>[originX, (originX + _widths[0]), ((originX + targetWidth) - _widths[2])];
            var targetYStarts:Vector.<int> = new <int>[originY, (originY + _heights[0]), ((originY + targetHeight) - _heights[2])];
            var targetWidths:Vector.<int> = new <int>[_widths[0], ((targetWidth - _widths[0]) - _widths[2]), _widths[2]];
            var targetHeights:Vector.<int> = new <int>[_heights[0], ((targetHeight - _heights[0]) - _heights[2]), _heights[2]];
            column = 0;

            while (column < 3)
            {
                row = 0;

                while (row < 3)
                {
                    if (!((((targetWidths[column] < 1) || (targetHeights[row] < 1)) || (sourceWidths[column] < 1)) || (sourceHeights[row] < 1)))
                    {
                        sourceRect = new Rectangle(sourceXStarts[column], sourceYStarts[row], sourceWidths[column], sourceHeights[row]);

                        if (((!(column == 1)) && (!(row == 1))))
                        {
                            targetBitmap.bitmapData.copyPixels(_bitmapData, sourceRect, new Point(targetXStarts[column], targetYStarts[row]));
                        }

                        else
                        {
                            destinationRect = new Rectangle(targetXStarts[column], targetYStarts[row], targetWidths[column], targetHeights[row]);
                            targetBitmap.bitmapData.draw(_bitmapData, _SafeStr_25.rectangleTransformMatrix(sourceRect, destinationRect), null, null, destinationRect, false);
                        };
                    };

                    row++;
                };

                column++;
            };
        }

        public function get bitmapData():BitmapData
        {
            return (_bitmapData);
        }

    }
}
