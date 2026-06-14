package com.sulake.habbo.communication.messages.outgoing.handshake
{
    import com.sulake.core.communication.messages.IMessageComposer;

        public class UniqueIDMessageComposer implements IMessageComposer 
    {

        private var _machineId:String;
        private var _fingerprint:String;
        private var _flashVersion:String;

        public function UniqueIDMessageComposer(machineId:String, fingerprint:String, flashVersion:String)
        {
            _machineId = machineId;
            _fingerprint = fingerprint;
            _flashVersion = flashVersion;
        }

        public function dispose():void
        {
        }

        public function getMessageArray():Array
        {
            return ([_machineId, _fingerprint, _flashVersion]);
        }

    }
}
