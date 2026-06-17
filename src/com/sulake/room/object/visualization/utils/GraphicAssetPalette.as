package com.sulake.room.object.visualization.utils
{
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class GraphicAssetPalette 
    {

        private static var BLANK:Array = [];

        private var _palette:Array = [];
        private var _primaryColor:int = 0;
        private var _secondaryColor:int = 0;

        public function GraphicAssetPalette(paletteData:ByteArray, primaryColor:int, secondaryColor:int)
        {
            var _local_4:uint;
            var _local_6:uint;
            var _local_5:uint;
            var _local_7:uint;
            super();
            paletteData.position = 0;

            while (paletteData.bytesAvailable >= 3)
            {
                _local_4 = paletteData.readUnsignedByte();
                _local_6 = paletteData.readUnsignedByte();
                _local_5 = paletteData.readUnsignedByte();
                _local_7 = (((0xFF000000 | (_local_4 << 16)) | (_local_6 << 8)) | _local_5);
                _palette.push(_local_7);
            };

            while (_palette.length < 0x0100)
            {
                _palette.push(0);
            };

            while (BLANK.length < 0x0100)
            {
                BLANK.push(0);
            };

            _primaryColor = primaryColor;
            _secondaryColor = secondaryColor;
        }

        public function get primaryColor():int
        {
            return (_primaryColor);
        }

        public function get secondaryColor():int
        {
            return (_secondaryColor);
        }

        public function dispose():void
        {
            _palette = [];
        }

        public function colorizeBitmap(bitmapData:BitmapData):void
        {
            var _local_2:BitmapData = bitmapData.clone();
            bitmapData.paletteMap(bitmapData, bitmapData.rect, new Point(0, 0), BLANK, _palette, BLANK, BLANK);
            bitmapData.copyChannel(_local_2, bitmapData.rect, new Point(0, 0), 8, 8);
            _local_2.dispose();
        }

    }
}
