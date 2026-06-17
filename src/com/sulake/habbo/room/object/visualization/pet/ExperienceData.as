package com.sulake.habbo.room.object.visualization.pet
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.geom.Matrix;

    public class ExperienceData 
    {

        private var _image:BitmapData;
        private var _ownCanvas:Boolean;
        private var _copy:BitmapData;
        private var _amount:int = -1;
        private var _alpha:int;

        public function ExperienceData(image:BitmapData, ownCanvas:Boolean=true)
        {
            _image = image;
            _ownCanvas = ownCanvas;

            if (_image != null)
            {
                _copy = _image.clone();
            };

            setExperience(0);
        }

        public function dispose():void
        {
            if (_copy)
            {
                _copy.dispose();
                _copy = null;
            };

            if (_image != null)
            {
                if (_ownCanvas)
                {
                    _image.dispose();
                };

                _image = null;
            };
        }

        public function get alpha():int
        {
            return (_alpha);
        }

        public function set alpha(value:int):void
        {
            _alpha = value;
        }

        public function get image():BitmapData
        {
            return (_image);
        }

        public function setExperience(amount:int):void
        {
            if (((_amount == amount) || (_image == null)))
            {
                return;
            };

            _image.copyPixels(_copy, _copy.rect, new Point(0, 0));

            var textFormat:TextFormat = new TextFormat();
            textFormat.font = "Volter";
            textFormat.color = 0xFFFFFF;
            textFormat.size = 9;

            var textField:TextField = new TextField();
            textField.embedFonts = true;
            textField.width = 30;
            textField.height = 12;
            textField.background = true;
            textField.backgroundColor = 0xE6C0B500;
            textField.defaultTextFormat = textFormat;
            textField.text = ("+" + amount);

            var matrix:Matrix = new Matrix();
            matrix.translate(15, 19);
            _image.draw(textField, matrix);
        }

    }
}
