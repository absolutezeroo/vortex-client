package com.sulake.habbo.navigator
{
    import com.sulake.core.window.components.ITextWindow;

    public class CutToWidth implements BinarySearchTest 
    {

        private var _value:String;
        private var _text:ITextWindow;
        private var _maxWidth:int;

        public function test(_arg_1:int):Boolean
        {
            _text.text = (_value.substring(0, _arg_1) + "...");
            return (_text.textWidth > _maxWidth);
        }

        public function beforeSearch(_arg_1:String, _arg_2:ITextWindow, _arg_3:int):void
        {
            _value = _arg_1;
            _text = _arg_2;
            _maxWidth = _arg_3;
        }

    }
}
