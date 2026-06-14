package com.sulake.habbo.communication.messages.outgoing.groupforums
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class UpdateForumReadMarkerMessageComposer implements IMessageComposer, IDisposable 
    {

        private var _array:Array = [0];

        public function add(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            _array.push(_arg_1, _arg_2, _arg_3);
            _array[0]++;
        }

        public function getMessageArray():Array
        {
            return (this._array);
        }

        public function get size():int
        {
            return (_array[0]);
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
