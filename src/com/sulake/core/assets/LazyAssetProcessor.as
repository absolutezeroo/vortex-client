package com.sulake.core.assets
{
    import com.sulake.core.runtime.IUpdateReceiver;
    import __AS3__.vec.Vector;
    import com.sulake.core.Core;

    public class LazyAssetProcessor implements IUpdateReceiver 
    {

        private var _queue:Vector.<ILazyAsset> = new Vector.<ILazyAsset>();
        private var _running:Boolean = false;
        private var _disposed:Boolean = false;

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                Core.instance.removeUpdateReceiver(this);
                _queue = null;
                _running = false;
                _disposed = true;
            };
        }

        public function push(lazyAsset:ILazyAsset):void
        {
            if (lazyAsset)
            {
                _queue.push(lazyAsset);

                if (!_running)
                {
                    Core.instance.registerUpdateReceiver(this, 2);
                    _running = true;
                };
            };
        }

        public function flush():void
        {
            for each (var _local_1:ILazyAsset in _queue)
            {
                if (!_local_1.disposed)
                {
                    _local_1.prepareLazyContent();
                };
            };

            _queue = new Vector.<ILazyAsset>();

            if (_running)
            {
                Core.instance.removeUpdateReceiver(this);
                _running = false;
            };
        }

        public function update(_arg_1:uint):void
        {
            var _local_2:ILazyAsset = _queue.shift();

            if (!_local_2)
            {
                if (_running)
                {
                    Core.instance.removeUpdateReceiver(this);
                    _running = false;
                };
            }

            else
            {
                if (!_local_2.disposed)
                {
                    _local_2.prepareLazyContent();
                };
            };
        }

    }
}
