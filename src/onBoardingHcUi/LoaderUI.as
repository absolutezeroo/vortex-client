package onBoardingHcUi
{
    import flash.filters.DropShadowFilter;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.display.Sprite;
    import flash.display.Shape;

    public class LoaderUI
    {

        public static const STYLE_ILLUMINA:int = 1;
        public static const STYLE_HITCH:int = 2;
        public static const _Str_2056:int = STYLE_ILLUMINA;
        public static const _Str_1585:int = STYLE_HITCH;
        public static const ANCHOR_LEFT:String = "l";
        public static const ANCHOR_CENTRE:String = "c";
        public static const ANCHOR_RIGHT:String = "r";
        public static const ANCHOR_TOP:String = "t";
        public static const ANCHOR_MIDDLE:String = "m";
        public static const ANCHOR_BOTTOM:String = "b";
        public static const L:String = ANCHOR_LEFT;
        public static const C:String = ANCHOR_CENTRE;
        public static const R:String = ANCHOR_RIGHT;
        public static const T:String = ANCHOR_TOP;
        public static const M:String = ANCHOR_MIDDLE;
        public static const B:String = ANCHOR_BOTTOM;
        public static const HITCH_TEXT_BODY_COLOUR:uint = 8309486;
        public static const HITCH_TEXT_HIGHLIGHT_COLOUR:uint = 0xFFFFFF;
        public static const _Str_1232:uint = HITCH_TEXT_BODY_COLOUR;
        public static const _Str_1545:uint = HITCH_TEXT_HIGHLIGHT_COLOUR;

        private static const border_text_hitch_png:Class = HabboLoaderUI_border_text_hitch_png;
        public static var ubuntu_regular:Class = HabboLoaderUI_Habboubuntu_regular_ttf;
        public static var ubuntu_bold:Class = HabboLoaderUI_Habboubuntu_bold_ttf;
        public static var ubuntu_italic:Class = HabboLoaderUI_Habboubuntu_italic_ttf;
        public static var ubuntu_bold_italic:Class = HabboLoaderUI_Habboubuntu_bold_italic_ttf;
        private static const block_dark_point_down_png:Class = HabboLoaderUI_block_dark_point_down_png;
        private static const block_dark_point_up_png:Class = HabboLoaderUI_block_dark_point_up_png;
        private static const block_dark_point_left_png:Class = HabboLoaderUI_block_dark_point_left_png;
        private static const block_dark_point_right_png:Class = HabboLoaderUI_block_dark_point_right_png;
        private static const ETCHING_FILTER:DropShadowFilter = new DropShadowFilter(1, 90, 0xD1D400, 1, 1, 1);
        private static const NEGATIVE_ETCHING_FILTER:DropShadowFilter = new DropShadowFilter(1, 270, 0, 0.7, 1, 1);

        public static function createTextField(text:String, size:int, color:uint, isBold:Boolean = false, isMultiline:Boolean = false, isInput:Boolean = false, isItalic:Boolean = false, align:String = "left", useKerning:Boolean = false, useThickness:Boolean = false):TextField
        {
            var format:TextFormat = new TextFormat("Ubuntu", size, color, isBold, isItalic, useThickness);
            format.align = align;
            format.kerning = useKerning;

            var field:LocalizedTextField = new LocalizedTextField();
            field.embedFonts = true;
            field.antiAliasType = "advanced";
            field.defaultTextFormat = format;
            field.multiline = isMultiline;
            field.wordWrap = isMultiline;
            field.type = ((isInput) ? "input" : "dynamic");
            field.selectable = isInput;
            field.htmlText = text;
            field.autoSize = "left";
            field.width = field.textWidth;
            field.height = field.textHeight;
            return (field);
        }

        public static function _Str_1132(text:String, size:int, color:uint, isBold:Boolean = false, isMultiline:Boolean = false, isInput:Boolean = false, isItalic:Boolean = false, align:String = "left", useKerning:Boolean = false, useThickness:Boolean = false):TextField
        {
            return (createTextField(text, size, color, isBold, isMultiline, isInput, isItalic, align, useKerning, useThickness));
        }

        public static function addEtching(target:DisplayObject, isNegative:Boolean = false):void
        {
            target.filters = [((isNegative) ? NEGATIVE_ETCHING_FILTER.clone() : ETCHING_FILTER.clone())];
        }

        public static function _Str_1516(target:DisplayObject, isNegative:Boolean = false):void
        {
            addEtching(target, isNegative);
        }

        public static function lineUpHorizontally(first:DisplayObject, ...args):void
        {
            var pairIndex:int = 0;
            var spacing:int;
            var nextItem:DisplayObject;
            var totalPairs:int = int((args.length / 2));

            while (pairIndex < totalPairs)
            {
                spacing = args[(pairIndex * 2)];
                nextItem = args[((pairIndex * 2) + 1)];
                nextItem.x = ((first.x + first.width) + spacing);
                first = nextItem;
                pairIndex++;
            };
        }

        public static function _Str_2098(first:DisplayObject, ...args):void
        {
            lineUpHorizontally.apply(null, [first].concat(args));
        }

        public static function lineUpHorizontallyRevers(first:DisplayObject, ...args):void
        {
            var pairIndex:int = 0;
            var spacing:int;
            var nextItem:DisplayObject;
            var totalPairs:int = int((args.length / 2));

            while (pairIndex < totalPairs)
            {
                spacing = args[(pairIndex * 2)];
                nextItem = args[((pairIndex * 2) + 1)];
                nextItem.x = ((first.x - spacing) - nextItem.width);
                first = nextItem;
                pairIndex++;
            };
        }

        public static function _Str_2047(first:DisplayObject, ...args):void
        {
            lineUpVertically.apply(null, [first].concat(args));
        }

        public static function lineUpVerticallyRevers(first:DisplayObject, ...args):void
        {
            var pairIndex:int = 0;
            var spacing:int;
            var nextItem:DisplayObject;
            var totalPairs:int = int((args.length / 2));

            while (pairIndex < totalPairs)
            {
                spacing = args[(pairIndex * 2)];
                nextItem = args[((pairIndex * 2) + 1)];
                nextItem.y = ((first.y - spacing) - nextItem.height);
                first = nextItem;
                pairIndex++;
            };
        }

        public static function lineUpVertically(first:DisplayObject, ...args):void
        {
            var pairIndex:int = 0;
            var spacing:int;
            var nextItem:DisplayObject;
            var totalPairs:int = int((args.length / 2));

            while (pairIndex < totalPairs)
            {
                spacing = args[(pairIndex * 2)];
                nextItem = args[((pairIndex * 2) + 1)];
                nextItem.y = ((first.y + first.height) + spacing);
                first = nextItem;
                pairIndex++;
            };
        }

        public static function lineUpElementsVertically(items:Vector.<DisplayObject>, spacing:int):void
        {
            var index:int;
            var nextItem:DisplayObject;

            if (((items == null) || (items.length < 2)))
            {
                return;
            };

            var previous:DisplayObject = items[0];
            index = 0;

            while (index < (items.length - 1))
            {
                nextItem = items[(index + 1)];
                nextItem.y = ((previous.y + previous.height) + spacing);
                previous = nextItem;
                index++;
            };
        }

        public static function alignAnchors(reference:DisplayObject, margin:int, anchor:String, ...targets):void
        {
            for each (var current:DisplayObject in targets)
            {
                if (anchor.indexOf("l") >= 0)
                {
                    current.x = (reference.x + margin);
                };

                if (anchor.indexOf("c") >= 0)
                {
                    current.x = (reference.x + int(((reference.width - current.width) / 2)));
                };

                if (anchor.indexOf("r") >= 0)
                {
                    current.x = (((reference.x + reference.width) - current.width) - margin);
                };

                if (anchor.indexOf("t") >= 0)
                {
                    current.y = (reference.y + margin);
                };

                if (anchor.indexOf("m") >= 0)
                {
                    current.y = (reference.y + int(((reference.height - current.height) / 2)));
                };

                if (anchor.indexOf("b") >= 0)
                {
                    current.y = (((reference.y + reference.height) - current.height) - margin);
                };
            };
        }

        public static function createBalloon(width:int, height:int, pointPosition:int, isDark:Boolean, tint:uint = 0xFFFFFF, anchor:String = "up"):Bitmap
        {
            var tipBitmap:Bitmap;
            var tipHeight:int;
            var tipWidth:int;
            var balloon:Bitmap;

            if (pointPosition < 0)
            {
                pointPosition = int(((width - 9) / 2));
            };

            var balloonShape:NineSplitSprite = NineSplitSprite.DARK_BALLOON;
            switch (anchor)
            {
                case "up":
                    tipBitmap = new block_dark_point_up_png();
                    tipHeight = tipBitmap.height;
                    balloon = new Bitmap(new BitmapData(width, (height + tipBitmap.height), true, 860986));
                    balloonShape.renderOn(balloon, new Rectangle(0, tipHeight, width, height));
                    balloon.bitmapData.copyPixels(tipBitmap.bitmapData, tipBitmap.bitmapData.rect, new Point(pointPosition, 0));
                    break;
                case "down":
                    tipBitmap = new block_dark_point_down_png();
                    tipHeight = tipBitmap.height;
                    balloon = new Bitmap(new BitmapData(width, (height + tipBitmap.height), true, 860986));
                    balloonShape.renderOn(balloon, new Rectangle(0, tipHeight, width, height));
                    balloon.bitmapData.copyPixels(tipBitmap.bitmapData, tipBitmap.bitmapData.rect, new Point(pointPosition, (height + tipHeight)));
                    break;
                case "left":
                    tipBitmap = new block_dark_point_left_png();
                    tipWidth = tipBitmap.width;
                    balloon = new Bitmap(new BitmapData((width + tipWidth), height, true, 0xFFFFFF));
                    balloonShape.renderOn(balloon, new Rectangle(tipWidth, 0, width, height));
                    balloon.bitmapData.copyPixels(tipBitmap.bitmapData, tipBitmap.bitmapData.rect, new Point(0, (pointPosition - tipWidth)));
                    break;
                case "right":
                    tipBitmap = new block_dark_point_right_png();
                    tipWidth = tipBitmap.width;
                    balloon = new Bitmap(new BitmapData((width + tipWidth), height, true, 860986));
                    balloonShape.renderOn(balloon, new Rectangle(0, 0, width, height));
                    balloon.bitmapData.copyPixels(tipBitmap.bitmapData, tipBitmap.bitmapData.rect, new Point(width, (pointPosition - tipWidth)));
                    break;
                case "none":
                    balloon = new Bitmap(new BitmapData(width, height, true, 860986));
                    balloonShape.renderOn(balloon, new Rectangle(0, 0, width, height));
            };

            balloon.bitmapData.colorTransform(balloon.bitmapData.rect, new ColorTransform((((tint >> 16) & 0xFF) / 0xFF), (((tint >> 8) & 0xFF) / 0xFF), ((tint & 0xFF) / 0xFF)));
            return (balloon);
        }

        public static function createFrame(title:String, subtitle:String, bounds:Rectangle, style:int = 1):Sprite
        {
            var subtitleField:TextField;
            var frame:Sprite = new Sprite();
            frame.x = bounds.x;
            frame.y = bounds.y;

            if (style == 1)
            {
                frame.addChild(NineSplitSprite.FRAME.render(bounds.width, bounds.height));
            };

            var titleColor:uint = ((style == 2) ? 8309486 : 0xFFFFFF);
            var titleSize:int = ((style == 2) ? 24 : 40);
            var titleField:TextField = createTextField(title, titleSize, titleColor, false, false, false, false);
            titleField.y = -(titleSize + 8);
            titleField.autoSize = "left";
            frame.addChild(titleField);

            if (style == 2)
            {
                titleField.width = bounds.width;
                titleField.thickness = 50;
            };

            if (((!(subtitle == null)) && (!(subtitle == ""))))
            {
                subtitleField = createTextField(subtitle, 10, 0xAAAAAA, true);
                subtitleField.x = 8;
                subtitleField.y = -(titleSize + 16);
                subtitleField.autoSize = "left";
                frame.addChild(subtitleField);
            };

            return (frame);
        }

        public static function resizeFrame(frame:Sprite, targetWidth:int, targetHeight:int):void
        {
            frame.removeChildAt(0);
            frame.addChildAt(NineSplitSprite.FRAME.render(targetWidth, targetHeight), 0);
        }

        public static function createScale9GridShapeFromImage(sourceBitmapData:BitmapData, sourceGrid:Rectangle):Shape
        {
            var xScaleIndex:int;
            var sourceY:Number;
            var yScaleIndex:int;
            var sourceXGrid:Array = [(sourceGrid.left - 0.001), (sourceGrid.right + 0.001), sourceBitmapData.width];
            var sourceYGrid:Array = [(sourceGrid.top - 0.001), (sourceGrid.bottom + 0.001), sourceBitmapData.height];
            var scaleGrid:Shape = new Shape();
            var sourceX:Number = 0;
            xScaleIndex = 0;

            while (xScaleIndex < 3)
            {
                sourceY = 0;
                yScaleIndex = 0;

                while (yScaleIndex < 3)
                {
                    scaleGrid.graphics.beginBitmapFill(sourceBitmapData);
                    scaleGrid.graphics.drawRect(sourceX, sourceY, (sourceXGrid[xScaleIndex] - sourceX), (sourceYGrid[yScaleIndex] - sourceY));
                    scaleGrid.graphics.endFill();
                    sourceY = sourceYGrid[yScaleIndex];
                    yScaleIndex++;
                };

                sourceX = sourceXGrid[xScaleIndex];
                xScaleIndex++;
            };

            scaleGrid.scale9Grid = sourceGrid;
            return (scaleGrid);
        }

        public static function _Str_2038(sourceBitmapData:BitmapData, sourceGrid:Rectangle):Shape
        {
            return (createScale9GridShapeFromImage(sourceBitmapData, sourceGrid));
        }

        public static function createTextBorder():Shape
        {
            return (createScale9GridShapeFromImage(Bitmap(new border_text_hitch_png()).bitmapData, new Rectangle(10, 10, 10, 10)));
        }

    }
}
