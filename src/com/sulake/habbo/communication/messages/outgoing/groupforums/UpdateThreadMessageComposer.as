package com.sulake.habbo.communication.messages.outgoing.groupforums
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class UpdateThreadMessageComposer implements IMessageComposer, IDisposable 
    {

        private var _array:Array = [];

        public function UpdateThreadMessageComposer(_arg_1:int, _arg_2:int, _arg_3:Boolean, _arg_4:Boolean)
        {
            this._array = [_arg_1, _arg_2, _arg_4, _arg_3];
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

        public function unwatch(_arg_1:String):void
        {
            // super.unwatch(_arg_1);
        }

    }
}
