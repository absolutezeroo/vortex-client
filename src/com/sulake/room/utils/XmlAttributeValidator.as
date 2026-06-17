package com.sulake.room.utils
{
    public class XmlAttributeValidator
    {
        public static function checkRequiredAttributes(data:Object, requiredAttributes:Array):Boolean
        {
            return (XmlUtil.checkRequiredAttributes(data, requiredAttributes));
        }
    }
}
