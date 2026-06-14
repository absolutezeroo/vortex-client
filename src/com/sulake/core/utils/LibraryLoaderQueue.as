package com.sulake.core.utils
{
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.runtime.IDisposable;

    public class LibraryLoaderQueue extends EventDispatcherWrapper implements IDisposable 
    {

        protected static const MAX_SIMULTANEOUS_DOWNLOADS:int = 4;

        private var _debug:Boolean = false;
        private var _queue:Array = [];
        private var _loaders:Array = [];

        public function LibraryLoaderQueue(debug:Boolean=false)
        {
            _debug = debug;
            super();
        }

        public function get length():int
        {
            return (_queue.length + _loaders.length);
        }

        override public function dispose():void
        {
            var _local_1:LibraryLoader;

            if (!disposed)
            {
                for each (_local_1 in _loaders)
                {
                    _local_1.dispose();
                };

                for each (_local_1 in _queue)
                {
                    _local_1.dispose();
                };

                _loaders = null;
                _queue = null;
                super.dispose();
            };
        }

        public function push(loader:LibraryLoader):void
        {
            if ((((!(disposed)) && (!(isUrlInQueue(loader.url)))) && (!(findLibraryLoaderByURL(loader.url)))))
            {
                if (loader.paused)
                {
                    _queue.push(loader);
                }

                else
                {
                    _loaders.push(loader);
                };

                loader.addEventListener("LIBRARY_LOADER_EVENT_COMPLETE", libraryLoadedHandler);
                loader.addEventListener("LIBRARY_LOADER_EVENT_PROGRESS", loadProgressHandler);
                loader.addEventListener("LIBRARY_LOADER_EVENT_DISPOSE", loaderDisposeHandler);
                loader.addEventListener("LIBRARY_LOADER_EVENT_ERROR", loadErrorHandler);
                next();
            };
        }

        private function next():void
        {
            var _local_1:LibraryLoader;

            if (!disposed)
            {
                while (((_loaders.length < 4) && (_queue.length > 0)))
                {
                    _local_1 = _queue.shift();
                    _loaders.push(_local_1);
                    _local_1.resume();
                };
            };
        }

        private function libraryLoadedHandler(event:LibraryLoaderEvent):void
        {
            var _local_2:LibraryLoader = (event.target as LibraryLoader);

            if (_local_2)
            {
                removeLoader(_local_2);
            };

            next();
        }

        private function loadProgressHandler(event:LibraryLoaderEvent):void
        {
            var _local_2:LibraryLoader = (event.target as LibraryLoader);
        }

        private function loaderDisposeHandler(event:LibraryLoaderEvent):void
        {
            var _local_2:LibraryLoader = (event.target as LibraryLoader);
            removeLoader(_local_2);
            next();
        }

        private function loadErrorHandler(event:LibraryLoaderEvent):void
        {
            var _local_2:LibraryLoader = (event.target as LibraryLoader);

            if (_local_2)
            {
                removeLoader(_local_2);
            };

            next();
        }

        private function removeLoader(loader:LibraryLoader):void
        {
            var _local_2:int;
            loader.removeEventListener("LIBRARY_LOADER_EVENT_COMPLETE", libraryLoadedHandler);
            loader.removeEventListener("LIBRARY_LOADER_EVENT_PROGRESS", loadProgressHandler);
            loader.removeEventListener("LIBRARY_LOADER_EVENT_DISPOSE", loaderDisposeHandler);
            loader.removeEventListener("LIBRARY_LOADER_EVENT_ERROR", loadErrorHandler);
            try
            {
                _local_2 = _queue.indexOf(loader);

                if (_local_2 > -1)
                {
                    _queue.splice(_local_2, 1);
                };

                _local_2 = _loaders.indexOf(loader);

                if (_local_2 > -1)
                {
                    _loaders.splice(_local_2, 1);
                };
            }

            catch(e:Error)
            {
            };
        }

        private function isUrlInQueue(url:String, removeParameter:Boolean=true):Boolean
        {
            if (!disposed)
            {
                if (((removeParameter) && (url.indexOf("?") > -1)))
                {
                    url = url.slice(0, url.indexOf("?"));
                };

                for each (var _local_3:LibraryLoader in _queue)
                {
                    if (removeParameter)
                    {
                        if (_local_3.url.indexOf(url) == 0)
                        {
                            return (true);
                        };
                    }

                    else
                    {
                        if (_local_3.url == url)
                        {
                            return (true);
                        };
                    };
                };
            };

            return (false);
        }

        public function findLibraryLoaderByURL(url:String, removeParameter:Boolean=true):LibraryLoader
        {
            if (!disposed)
            {
                if (((removeParameter) && (url.indexOf("?") > -1)))
                {
                    url = url.slice(0, url.indexOf("?"));
                };

                for each (var _local_3:LibraryLoader in _loaders)
                {
                    if (removeParameter)
                    {
                        if (_local_3.url.indexOf(url) == 0)
                        {
                            return (_local_3);
                        };
                    }

                    else
                    {
                        if (_local_3.url == url)
                        {
                            return (_local_3);
                        };
                    };
                };
            };

            return (null);
        }

    }
}
