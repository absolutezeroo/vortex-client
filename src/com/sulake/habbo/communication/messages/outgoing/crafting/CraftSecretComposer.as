package com.sulake.habbo.communication.messages.outgoing.crafting
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;
    import __AS3__.vec.Vector;

        public class CraftSecretComposer implements IMessageComposer, IDisposable 
    {

        private var _array:Array = [];

        public function CraftSecretComposer(_arg_1:int, _arg_2:Vector.<int>)
        {
            var _local_3:int;
            super();
            _array.push(_arg_1);
            _array.push(_arg_2.length);
            _local_3 = 0;

            while (_local_3 < _arg_2.length)
            {
                _array.push(_arg_2[_local_3]);
                _local_3++;
            };
        }

        public function getMessageArray():Array
        {
            return (this._array);
        }

        public function dispose():void
        {
            this._array = null;
        }

        public function get disposed():Boolean
        {
            return (false);
        }

    }
}
