package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

        public class WiredGetRoomLogsComposer implements IMessageComposer, IDisposable
    {

        private var _array:Array = [];

        public function WiredGetRoomLogsComposer(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String)
        {
            _array.push(_arg_1);
            _array.push(_arg_2);
            _array.push(_arg_3);
            _array.push(_arg_4);
            _array.push(_arg_5);
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
