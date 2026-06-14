package com.sulake.habbo.session.handler
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;

    public class BaseHandler implements IDisposable 
    {

        private var _connection:IConnection;
        private var _listener:IRoomHandlerListener;
        private var _disposed:Boolean = false;
        public var _SafeStr_586:int;

        public function BaseHandler(connection:IConnection, listener:IRoomHandlerListener)
        {
            _connection = connection;
            _listener = listener;
        }

        public function dispose():void
        {
            _connection = null;
            _listener = null;
            _disposed = true;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get connection():IConnection
        {
            return (_connection);
        }

        public function get listener():IRoomHandlerListener
        {
            return (_listener);
        }

    }
}
