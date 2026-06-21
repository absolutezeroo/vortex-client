package com.sulake.core.communication.connection
{
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;
    import flash.net.Socket;
    import flash.utils.Timer;
    import flash.utils.ByteArray;
    import com.sulake.core.communication.wireformat.IWireFormat;
    import com.sulake.core.communication.encryption.IEncryption;
    import com.sulake.core.communication.messages.MessageClassManager;
    import com.sulake.core.communication.ICoreCommunicationManager;
    import __AS3__.vec.Vector;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.wireformat.EvaWireFormat;
    import flash.utils.getTimer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    import com.sulake.core.utils.ClassUtils;
    import com.sulake.core.communication.messages.IPreEncryptionMessage;
    import com.sulake.core.communication.messages.IMessageConfiguration;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.Core;
    import flash.events.ProgressEvent;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.events.Event;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;

        public class SocketConnection extends EventDispatcherWrapper implements IConnection, IDisposable
    {

        public static const DEFAULT_SOCKET_TIMEOUT:int = 10000;

        private var _socket:Socket;
        private var _timeOutTimer:Timer;
        private var _timeOutStarted:int;
        private var _dataBuffer:ByteArray;
        private var _wireFormat:IWireFormat;
        private var _clientToServerEncryption:IEncryption;
        private var _serverToClientEncryption:IEncryption;
        private var _messageClassManager:MessageClassManager;
        private var _communicationManager:ICoreCommunicationManager;
        private var _stateListener:IConnectionStateListener;
        private var _authenticated:Boolean;
        private var _configurationReady:Boolean;
        private var _pendingClientMessages:Vector.<IMessageComposer>;
        private var _pendingServerMessages:Vector.<IMessageDataWrapper>;
        private var _lastProcessedMessage:IMessageDataWrapper;

        public function SocketConnection(communicationManager:ICoreCommunicationManager, stateListener:IConnectionStateListener)
        {
            _communicationManager = communicationManager;
            _messageClassManager = new MessageClassManager();
            _wireFormat = new EvaWireFormat();
            createSocket();
            _timeOutTimer = new Timer(10000, 1);
            _timeOutTimer.addEventListener("timer", onTimeOutTimer);
            _stateListener = stateListener;
        }

        private static function getKeyValue(keys:Array, value:int):String
        {
            var _local_5:String = "";

            for each (var _local_3:Array in keys)
            {
                for each (var _local_4:int in _local_3)
                {
                    _local_5 = (_local_5 + String.fromCharCode(((65290 - _local_4) + value--)));
                };
            };

            return (_local_5);
        }

        public function addListener(_arg_1:String, _arg_2:Function):void
        {
            addEventListener(_arg_1, _arg_2);
        }

        override public function dispose():void
        {
            if (!disposed)
            {
                disposeSocket();

                if (_timeOutTimer)
                {
                    _timeOutTimer.stop();
                    _timeOutTimer.removeEventListener("timer", onTimeOutTimer);
                };

                _timeOutTimer = null;
                _dataBuffer = null;
                _stateListener = null;
                _clientToServerEncryption = null;
                _serverToClientEncryption = null;
                _wireFormat = null;

                if (_messageClassManager)
                {
                    _messageClassManager.dispose();
                };

                _messageClassManager = null;
                _communicationManager = null;
                _stateListener = null;
                _lastProcessedMessage = null;
                super.dispose();
            };
        }

        public function createSocket():void
        {
            disposeSocket();
            _dataBuffer = new ByteArray();
            _serverToClientEncryption = null;
            _clientToServerEncryption = null;
            _authenticated = false;
            _configurationReady = false;
            _pendingClientMessages = null;
            _pendingServerMessages = null;
            _lastProcessedMessage = null;
            _socket = new Socket();
            _socket.addEventListener("connect", onConnect);
            _socket.addEventListener("complete", onComplete);
            _socket.addEventListener("close", onClose);
            _socket.addEventListener("socketData", onRead);
            _socket.addEventListener("securityError", onSecurityError);
            _socket.addEventListener("ioError", onIOError);
        }

        private function disposeSocket():void
        {
            if (_socket)
            {
                _socket.removeEventListener("connect", onConnect);
                _socket.removeEventListener("complete", onComplete);
                _socket.removeEventListener("close", onClose);
                _socket.removeEventListener("socketData", onRead);
                _socket.removeEventListener("securityError", onSecurityError);
                _socket.removeEventListener("ioError", onIOError);

                if (_socket.connected)
                {
                    _socket.close();
                };

                _socket = null;
            };
        }

                public function init(_arg_1:String, _arg_2:uint=0):Boolean
        {
            if (_stateListener)
            {
                _stateListener.connectionInit(_arg_1, _arg_2);
            };

            if (_socket == null)
            {
                createSocket();
            };

            _timeOutTimer.stop();
            _timeOutTimer.reset();
            _timeOutTimer.start();
            _timeOutStarted = getTimer();

            try
            {
                _socket.connect(_arg_1, _arg_2);
            }

            catch(e:Error)
            {
                _timeOutTimer.stop();

                var _local_3:IOErrorEvent = new IOErrorEvent("ioError");
                _local_3.text = e.message;
                dispatchEvent(_local_3);
                return (false);
            };

            return (true);
        }

        public function set timeout(_arg_1:int):void
        {
            if (disposed)
            {
                return;
            };

            _timeOutTimer.delay = _arg_1;
        }

        public function addMessageEvent(_arg_1:IMessageEvent):void
        {
            if (disposed)
            {
                return;
            };

            _messageClassManager.registerMessageEvent(_arg_1);
        }

        public function removeMessageEvent(_arg_1:IMessageEvent):void
        {
            if (disposed)
            {
                return;
            };

            _messageClassManager.unregisterMessageEvent(_arg_1);
        }

        public function isAuthenticated():void
        {
            _authenticated = true;
        }

        public function isConfigured():void
        {
            var _local_1:int;
            var _local_3:Array;
            _configurationReady = true;

            if (_pendingServerMessages)
            {
                for each (var _local_4:IMessageDataWrapper in _pendingServerMessages)
                {
                    _local_1 = _local_4.getID();
                    _local_3 = parseReceivedMessage(_local_4);

                    if (_local_3 != null)
                    {
                        handleReceivedMessage(_local_1, _local_3);
                    };
                };
            };

            if (_pendingClientMessages)
            {
                for each (var _local_2:IMessageComposer in _pendingClientMessages)
                {
                    send(_local_2);
                };

                _pendingClientMessages = null;
            };

            _pendingClientMessages = new Vector.<IMessageComposer>(0);
            _pendingServerMessages = new Vector.<IMessageDataWrapper>(0);
        }

                public function send(message:IMessageComposer):Boolean
        {
            if (disposed)
            {
                return (false);
            };

            if (((_authenticated) && (!(_configurationReady))))
            {
                if (_pendingClientMessages == null)
                {
                    _pendingClientMessages = new Vector.<IMessageComposer>(0);
                };

                _pendingClientMessages.push(message);
                return (false);
            };

            var _local_4:int = _messageClassManager.getMessageIDForComposer(message);

            if (_local_4 < 0)
            {
                return (false);
            };

            var _local_2:Array = message.getMessageArray();
            var _local_3:ByteArray = _wireFormat.encode(_local_4, _local_2);

            if (_stateListener)
            {
                _stateListener.messageSent(String(_local_4));
            };

            if (_clientToServerEncryption == null)
            {
                return (false);
            };

            if (_socket.connected)
            {
                _clientToServerEncryption.encipher(_local_3);
                _socket.writeBytes(_local_3);
                _socket.flush();
            }

            else
            {
                return (false);
            };

            return (true);
        }

                public function sendUnencrypted(_arg_1:IMessageComposer):Boolean
        {
            if (disposed)
            {
                return (false);
            };

            var _local_4:int = _messageClassManager.getMessageIDForComposer(_arg_1);

            if (_local_4 < 0)
            {
                return (false);
            };

            var _local_2:Array = _arg_1.getMessageArray();
            var _local_3:ByteArray = _wireFormat.encode(_local_4, _local_2);
            var _local_6:String = getQualifiedClassName(_arg_1);
            var _local_5:Class = (getDefinitionByName(_local_6) as Class);

            if (!ClassUtils.implementsInterface(_local_5, IPreEncryptionMessage))
            {
                return (false);
            };

            if (_stateListener)
            {
                _stateListener.messageSent(String(_local_4));
            };

            if (_socket.connected)
            {
                _socket.writeBytes(_local_3);
                _socket.flush();
            }

            else
            {
                return (false);
            };

            return (true);
        }

        public function setEncryption(_arg_1:IEncryption, _arg_2:IEncryption):void
        {
            _clientToServerEncryption = _arg_1;
            _serverToClientEncryption = _arg_2;
        }

        public function registerMessageClasses(_arg_1:IMessageConfiguration):void
        {
            _messageClassManager.registerMessages(_arg_1);
        }

        private function processData():void
        {
            var _local_1:Array;
            var _local_2:int;
            var _local_3:Array;
            _local_1 = splitReceivedMessages();

            for each (_lastProcessedMessage in _local_1)
            {
                _local_2 = _lastProcessedMessage.getID();

                if (_stateListener)
                {
                    _stateListener.messageReceived(String(_local_2));
                };

                if (((_authenticated) && (!(_configurationReady))))
                {
                    if (_pendingServerMessages == null)
                    {
                        _pendingServerMessages = new Vector.<IMessageDataWrapper>(0);
                    };

                    _pendingServerMessages.push(_lastProcessedMessage);
                }

                else
                {
                    _local_3 = parseReceivedMessage(_lastProcessedMessage);

                    if (_local_3 != null)
                    {
                        handleReceivedMessage(_local_2, _local_3);
                    };
                };
            };
        }

                public function processReceivedData():void
        {
            if (disposed)
            {
                return;
            };

            try
            {
                processData();
            }

            catch(e:Error)
            {
                if (((_stateListener) && (_lastProcessedMessage)))
                {
                    _stateListener.messageParseError(_lastProcessedMessage);
                };

                if (!disposed)
                {
                    throw (e);
                };
            };
        }

        private function splitReceivedMessages():Array
        {
            var _local_1:ByteArray;
            _dataBuffer.position = 0;

            if (_dataBuffer.bytesAvailable == 0)
            {
                return ([]);
            };

            var _local_2:Array = _wireFormat.splitMessages(_dataBuffer, this);

            if (_dataBuffer.bytesAvailable == 0)
            {
                _dataBuffer = new ByteArray();
            }

            else
            {
                if (_dataBuffer.position > 0)
                {
                    _local_1 = new ByteArray();
                    _local_1.writeBytes(_dataBuffer, _dataBuffer.position);
                    _dataBuffer = _local_1;
                };
            };

            return (_local_2);
        }

        private function parseReceivedMessage(message:IMessageDataWrapper):Array
        {
            var _local_2:IMessageParser;
            var _local_3:Array = _messageClassManager.getMessageEventsForID(message.getID());

            if (_local_3 != null)
            {
                _local_2 = (_local_3[0] as IMessageEvent).parser;
                try
                {
                    _local_2.flush();
                    _local_2.parse(message);
                }

                catch(e:Error)
                {
                    Core.crash((getKeyValue([[65220, 65192, 65183, 65179], [65185, 65185, 65252, 65167], [65171, 65249, 65168, 65182], [65164, 65162, 65175, 65243], [65169, 65163, 65173, 65160], [65161, 65164, 65158, 65164], [65234, 65156, 65163, 65148], [65147, 65164, 65157, 65158], [65226, 65140, 65141, 65150, 65144, 65150]], 0) + getQualifiedClassName(_local_2)), e.errorID, e);
                };
            };

            return (_local_3);
        }

        private function handleReceivedMessage(_arg_1:int, _arg_2:Array):void
        {
            for each (var _local_3:IMessageEvent in _arg_2)
            {
                _local_3.connection = this;
                _local_3.callback.call(null, _local_3);
            };
        }

        public function get connected():Boolean
        {
            if (_socket == null)
            {
                return (false);
            };

            return (_socket.connected);
        }

        public function close():void
        {
            if (_socket == null)
            {
                return;
            };

            try
            {
                _socket.close();
            }

            catch(e:Error)
            {
                Logger.log(("[SocketConnection] Failed to close socket: " + e.message));
            };
        }

        private function onRead(_arg_1:ProgressEvent):void
        {
            if (_socket == null)
            {
                return;
            };

            _dataBuffer.position = _dataBuffer.length;
            _socket.readBytes(_dataBuffer, _dataBuffer.position);
        }

        public function getServerToClientEncryption():IEncryption
        {
            return (_serverToClientEncryption);
        }

        private function onConnect(_arg_1:Event):void
        {
            _timeOutTimer.stop();
            ErrorReportStorage.addDebugData(getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65178], [65171, 65171, 65196, 65174], [65169, 65176, 65162]], 0), (getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65182], [65182, 65249, 65175, 65169, 65246]], 0) + (getTimer() - _timeOutStarted)));
            dispatchEvent(_arg_1);
        }

        private function onClose(_arg_1:Event):void
        {
            _timeOutTimer.stop();
            ErrorReportStorage.addDebugData(getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65178], [65171, 65171, 65196, 65174], [65169, 65176, 65162]], 0), (getKeyValue([[65223, 65181, 65177, 65172], [65185, 65185, 65252, 65178], [65172, 65249]], 0) + (getTimer() - _timeOutStarted)));
            dispatchEvent(_arg_1);
        }

        private function onComplete(_arg_1:Event):void
        {
            _timeOutTimer.stop();
            ErrorReportStorage.addDebugData(getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65178], [65171, 65171, 65196, 65174], [65169, 65176, 65162]], 0), (getKeyValue([[65223, 65178, 65179, 65175], [65178, 65184, 65168, 65182], [65182, 65249, 65175, 65169, 65246]], 0) + (getTimer() - _timeOutStarted)));
            dispatchEvent(_arg_1);
        }

        private function onSecurityError(_arg_1:SecurityErrorEvent):void
        {
            _timeOutTimer.stop();
            ErrorReportStorage.addDebugData(getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65178], [65171, 65171, 65196, 65174], [65169, 65176, 65162]], 0), (getKeyValue([[65207, 65188, 65189, 65170], [65172, 65180, 65168, 65162], [65213, 65167, 65166, 65168], [65164, 65245, 65171, 65165, 65242]], 0) + (getTimer() - _timeOutStarted)));
            dispatchEvent(_arg_1);
        }

        private function onIOError(_arg_1:IOErrorEvent):void
        {
            _timeOutTimer.stop();
            ErrorReportStorage.addDebugData(getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65178], [65171, 65171, 65196, 65174], [65169, 65176, 65162]], 0), (getKeyValue([[65217, 65210, 65219, 65173], [65172, 65174, 65170, 65251], [65177, 65171, 65248]], 0) + (getTimer() - _timeOutStarted)));
            switch (_arg_1.type)
            {
                case "ioError":
                    break;
                case "diskError":
                    break;
                case "networkError":
                    break;
                case "verifyError":
            };

            dispatchEvent(_arg_1);
        }

        private function onTimeOutTimer(_arg_1:TimerEvent):void
        {
            _timeOutTimer.stop();
            ErrorReportStorage.addDebugData(getKeyValue([[65223, 65178, 65178, 65177], [65185, 65186, 65168, 65178], [65171, 65171, 65196, 65174], [65169, 65176, 65162]], 0), (getKeyValue([[65206, 65184, 65179, 65186], [65207, 65168, 65168, 65251], [65177, 65171, 65248, 65247]], 0) + (getTimer() - _timeOutStarted)));

            var _local_2:IOErrorEvent = new IOErrorEvent("ioError");
            _local_2.text = ((getKeyValue([[65207, 65178, 65189, 65180], [65185, 65169, 65252, 65199], [65177, 65172, 65179, 65168], [65161, 65161, 65244, 65235]], 0) + _timeOutTimer.delay) + getKeyValue([[65258, 65180, 65173, 65246], [65240, 65253, 65204, 65172], [65167, 65166, 65175, 65181], [65170, 65176, 65244, 65205], [65169, 65159, 65171, 65152], [65173, 65161, 65160, 65221]], 0));
            dispatchEvent(_local_2);
        }

    }
}
