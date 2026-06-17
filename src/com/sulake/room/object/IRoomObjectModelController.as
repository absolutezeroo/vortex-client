package com.sulake.room.object
{
    import com.sulake.core.utils.Map;

    public /*dynamic*/ interface IRoomObjectModelController extends IRoomObjectModel 
    {

        function setNumber(_key:String, _value:Number, _readOnly:Boolean=false):void;
        function setString(_key:String, _value:String, _readOnly:Boolean=false):void;
        function setNumberArray(_key:String, _values:Array, _readOnly:Boolean=false):void;
        function setStringArray(_key:String, _values:Array, _readOnly:Boolean=false):void;
        function setStringToStringMap(_key:String, _value:Map, _readOnly:Boolean=false):void;

    }
}

