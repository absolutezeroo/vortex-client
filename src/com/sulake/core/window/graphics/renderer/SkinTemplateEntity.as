package com.sulake.core.window.graphics.renderer
{
    import flash.geom.Rectangle;

    public class SkinTemplateEntity implements ISkinTemplateEntity 
    {

        protected var _SafeStr_698:uint;
        protected var _name:String;
        protected var _SafeStr_741:String;
        protected var _SafeStr_1116:Rectangle;

        public function SkinTemplateEntity(name:String, type:String, id:uint, rect:Rectangle)
        {
            _SafeStr_698 = id;
            _name = name;
            _SafeStr_741 = type;
            _SafeStr_1116 = rect;
        }

        public function get id():uint
        {
            return (_SafeStr_698);
        }

        public function get name():String
        {
            return (_name);
        }

        public function get type():String
        {
            return (_SafeStr_741);
        }

        public function get region():Rectangle
        {
            return (_SafeStr_1116);
        }

    }
}
