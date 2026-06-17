package com.sulake.habbo.room
{
    public class PetColorResult 
    {

        private static const COLOR_TAGS:Array = ["Null", "Black", "White", "Grey", "Red", "Orange", "Pink", "Green", "Lime", "Blue", "Light-Blue", "Dark-Blue", "Yellow", "Brown", "Dark-Brown", "Beige", "Cyan", "Purple", "Gold"];

        private var _breed:int;
        private var _tag:String;
        private var _id:String;
        private var _primaryColor:int = 0;
        private var _secondaryColor:int = 0;
        private var _isMaster:Boolean = false;
        private var _layerTags:Array = [];

        public function PetColorResult(primaryColor:int, secondaryColor:int, breed:int, tagIndex:int, id:String, isMaster:Boolean, layerTags:Array)
        {
            _primaryColor = (primaryColor & 0xFFFFFF);
            _secondaryColor = (secondaryColor & 0xFFFFFF);
            _breed = breed;
            _tag = (((tagIndex > -1) && (tagIndex < COLOR_TAGS.length)) ? COLOR_TAGS[tagIndex] : "");
            _id = id;
            _isMaster = isMaster;
            _layerTags = layerTags;
        }

        public function get primaryColor():int
        {
            return (_primaryColor);
        }

        public function get secondaryColor():int
        {
            return (_secondaryColor);
        }

        public function get breed():int
        {
            return (_breed);
        }

        public function get tag():String
        {
            return (_tag);
        }

        public function get id():String
        {
            return (_id);
        }

        public function get isMaster():Boolean
        {
            return (_isMaster);
        }

        public function get layerTags():Array
        {
            return (_layerTags);
        }

    }
}