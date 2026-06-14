package com.sulake.habbo.communication.messages.outgoing.camera
{
    import com.sulake.core.communication.messages.IMessageComposer;

        public class PurchasePhotoMessageComposer implements IMessageComposer 
    {

        private var _data:Array = [];

        public function getMessageArray():Array
        {
            return (_data);
        }

        public function dispose():void
        {
            _data = [];
        }

    }
}
