package com.sulake.habbo.communication.messages.incoming.room.furniture
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RentableSpaceConfigMessageParser;

    public class RentableSpaceConfigMessageEvent extends MessageEvent
    {

        public function RentableSpaceConfigMessageEvent(_arg_1:Function)
        {
            super(_arg_1, RentableSpaceConfigMessageParser);
        }

        public function getParser():RentableSpaceConfigMessageParser
        {
            return (parser as RentableSpaceConfigMessageParser);
        }

    }
}
