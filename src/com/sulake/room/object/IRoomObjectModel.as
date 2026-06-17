package com.sulake.room.object
{
    import com.sulake.core.utils.Map;

    public /*dynamic*/ interface IRoomObjectModel 
    {

        function hasNumber(_variableName:String):Boolean;
        function hasNumberArray(_variableName:String):Boolean;
        function hasString(_variableName:String):Boolean;
        function hasStringArray(_variableName:String):Boolean;
        function getNumber(_variableName:String):Number;
        function getString(_variableName:String):String;
        function getNumberArray(_variableName:String):Array;
        function getStringArray(_variableName:String):Array;
        function getUpdateID():int;
        function getStringToStringMap(_key:String):Map;

    }
}

