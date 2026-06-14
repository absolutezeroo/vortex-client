package com.sulake.habbo.ui.widget.infostand
{
    import flash.utils.Dictionary;

    public class CommandConfiguration 
    {

        private var _allCommandIds:Array;
        private var _enabledCommands:Dictionary = new Dictionary();

        public function CommandConfiguration(_arg_1:Array, _arg_2:Array)
        {
            var _local_3:int;
            var _local_4:int;
            super();
            _allCommandIds = _arg_1;

            while (_local_3 < _arg_2.length)
            {
                _local_4 = _arg_2[_local_3];
                _enabledCommands[_local_4] = true;
                _local_3++;
            };
        }

        public function get allCommandIds():Array
        {
            return (_allCommandIds);
        }

        public function isEnabled(_arg_1:int):Boolean
        {
            return (!(_enabledCommands[_arg_1] == null));
        }

    }
}
