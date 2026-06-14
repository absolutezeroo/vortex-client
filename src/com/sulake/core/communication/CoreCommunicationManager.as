package com.sulake.core.communication
{
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.connection.SocketConnection;
    import com.sulake.core.communication.connection.IConnectionStateListener;

        public class CoreCommunicationManager extends Component implements ICoreCommunicationManager, IUpdateReceiver 
    {

        private var _connections:Array;

        public function CoreCommunicationManager(_arg_1:IContext, _arg_2:uint=0)
        {
            super(_arg_1, _arg_2);
            _connections = [];
            registerUpdateReceiver(this, 0);
        }

        override public function dispose():void
        {
            removeUpdateReceiver(this);

            for each (var _local_1:IConnection in _connections)
            {
                _local_1.dispose();
            };

            _connections = null;
            super.dispose();
        }

        public function createConnection(_arg_1:IConnectionStateListener=null):IConnection
        {
            var _local_2:IConnection = new SocketConnection(this, _arg_1);
            _connections.push(_local_2);
            return (_local_2);
        }

        public function update(_arg_1:uint):void
        {
            var _local_2:int;
            var _local_3:IConnection;
            _local_2 = 0;

            while (_local_2 < _connections.length)
            {
                _local_3 = _connections[_local_2];
                _local_3.processReceivedData();

                if (disposed)
                {
                    return;
                };

                if (_local_3.disposed)
                {
                    _connections.splice(_local_2, 1);
                }

                else
                {
                    _local_2++;
                };
            };
        }

    }
}
