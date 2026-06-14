package com.sulake.habbo.avatar.structure.parts
{
    public class ActivePartSet 
    {

        private var _id:String;
        private var _parts:Array;

        public function ActivePartSet(_arg_1:XML)
        {
            _id = String(_arg_1.@id);
            _parts = [];

            for each (var _local_2:XML in _arg_1.activePart)
            {
                _parts.push(String(_local_2.@["set-type"]));
            };
        }

        public function get parts():Array
        {
            return (_parts);
        }

    }
}
