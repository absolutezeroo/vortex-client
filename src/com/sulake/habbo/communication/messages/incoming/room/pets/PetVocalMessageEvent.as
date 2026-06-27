package com.sulake.habbo.communication.messages.incoming.room.pets
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.pets.PetVocalMessageParser;

    public class PetVocalMessageEvent extends MessageEvent implements IMessageEvent
    {

        public function PetVocalMessageEvent(_arg_1:Function)
        {
            super(_arg_1, PetVocalMessageParser);
        }

        public function getParser():PetVocalMessageParser
        {
            return (_SafeStr_816 as PetVocalMessageParser);
        }

    }
}
