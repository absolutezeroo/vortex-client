package com.sulake.habbo.friendbar.view.utils
{
    import com.sulake.core.runtime.IDisposable;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.sulake.core.window.components.ITextWindow;

    public class TextCropper implements IDisposable 
    {

        private var _disposed:Boolean = false;
        private var _textField:TextField;
        private var _textFormat:TextFormat;
        private var _tailText:String = "...";
        private var _tailSize:int = 20;

        public function TextCropper()
        {
            _textField = new TextField();
            _textField.autoSize = "left";
            _textField.antiAliasType = "advanced";
            _textField.gridFitType = "pixel";
            _textFormat = _textField.defaultTextFormat;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                _textField = null;
                _disposed = true;
            };
        }

        public function crop(_arg_1:ITextWindow):void
        {
            var _local_2:int;
            _textFormat.font = _arg_1.fontFace;
            _textFormat.size = _arg_1.fontSize;
            _textFormat.bold = _arg_1.bold;
            _textFormat.italic = _arg_1.italic;
            _textField.setTextFormat(_textFormat);
            _textField.text = _arg_1.getLineText(0);

            var _local_3:int = _textField.textWidth;

            if (_local_3 > _arg_1.width)
            {
                _local_2 = int(_textField.getCharIndexAtPoint((_arg_1.width - _tailSize), (_textField.textHeight / 2)));
                _arg_1.text = (_arg_1.text.slice(0, _local_2) + _tailText);
            };
        }

    }
}
