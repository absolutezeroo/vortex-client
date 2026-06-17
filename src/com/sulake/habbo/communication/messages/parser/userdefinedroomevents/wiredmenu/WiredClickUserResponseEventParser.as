package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

        public class WiredClickUserResponseEventParser implements IMessageParser
    {

        private var _index:int;
        private var _openMenu:Boolean;

        public function flush():Boolean
        {
            return (true);
        }

        public function parse(_arg_1:IMessageDataWrapper):Boolean
        {
            _index = _arg_1.readInteger();
            _openMenu = _arg_1.readBoolean();
            return (true);
        }

        public function get index():int
        {
            return (_index);
        }

        public function get openMenu():Boolean
        {
            return (_openMenu);
        }

    }
}
