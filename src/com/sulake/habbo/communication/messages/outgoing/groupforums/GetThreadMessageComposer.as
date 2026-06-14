package com.sulake.habbo.communication.messages.outgoing.groupforums
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class GetThreadMessageComposer implements IMessageComposer, IDisposable 
    {

        private var _array:Array = [];

        public function GetThreadMessageComposer(_arg_1:int, _arg_2:int)
        {
            this._array = [_arg_1, _arg_2];
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
