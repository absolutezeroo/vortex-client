package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class WiredClickUserMessageComposer implements IMessageComposer, IDisposable
    {

        private var _array:Array = [];

        public function WiredClickUserMessageComposer(_arg_1:int)
        {
            _array.push(_arg_1);
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
