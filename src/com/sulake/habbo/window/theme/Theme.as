package com.sulake.habbo.window.theme
{
    import com.sulake.core.window.theme.PropertyMap;

    public class Theme 
    {

        public static const _SafeStr_617:String = "None";
        public static const ICON:String = "Icon";
        public static const LEGACY_BORDER:String = "Legacy border";
        public static const VOLTER:String = "Volter";
        public static const UBUNTU:String = "Ubuntu";
        public static const ILLUMINA_LIGHT:String = "Illumina Light";
        public static const ILLUMINA_DARK:String = "Illumina Dark";

        private var _name:String;
        private var _isReal:Boolean;
        private var _baseStyle:uint;
        private var _styleCount:uint;
        private var _propertyDefaults:PropertyMap;

        public function Theme(name:String, isReal:Boolean, baseStyle:uint, styleCount:uint, propertyDefaults:PropertyMap)
        {
            _name = name;
            _isReal = isReal;
            _baseStyle = baseStyle;
            _styleCount = styleCount;
            _propertyDefaults = propertyDefaults;
        }

        public function get name():String
        {
            return (_name);
        }

        public function get isReal():Boolean
        {
            return (_isReal);
        }

        public function get baseStyle():uint
        {
            return (_baseStyle);
        }

        public function get styleCount():uint
        {
            return (_styleCount);
        }

        public function get propertyDefaults():PropertyMap
        {
            return (_propertyDefaults);
        }

        public function coversStyle(style:uint):Boolean
        {
            return ((style >= _baseStyle) && (style < (_baseStyle + _styleCount)));
        }

    }
}
