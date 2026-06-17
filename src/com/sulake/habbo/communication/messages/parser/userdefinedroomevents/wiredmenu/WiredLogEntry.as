package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

        public class WiredLogEntry
    {

        private var _id:Number;
        private var _logLevel:int;
        private var _logSource:int;
        private var _logMessage:String;
        private var _timestamp:Number;
        private var _timestampStr:String;

        public function WiredLogEntry(_arg_1:IMessageDataWrapper)
        {
            _id = _arg_1.readLong();
            _logLevel = _arg_1.readByte();
            _logSource = _arg_1.readByte();
            _logMessage = _arg_1.readString();
            _timestamp = _arg_1.readLong();
            _timestampStr = _arg_1.readString();
        }

        public function get id():Number
        {
            return (_id);
        }

        public function get logLevel():int
        {
            return (_logLevel);
        }

        public function get logSource():int
        {
            return (_logSource);
        }

        public function get logMessage():String
        {
            return (_logMessage);
        }

        public function get timestamp():Number
        {
            return (_timestamp);
        }

        public function get timestampStr():String
        {
            return (_timestampStr);
        }

    }
}
