package com.sulake.core.assets
{
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import __AS3__.vec.Vector;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import com.sulake.core.utils.LibraryLoader;
    import flash.events.Event;
    import com.sulake.core.utils.LibraryLoaderEvent;
    import flash.net.URLRequest;

    public class AssetLibraryCollection extends EventDispatcherWrapper implements IAssetLibrary 
    {

        protected var _SafeStr_794:Vector.<IAssetLibrary>;
        protected var _SafeStr_792:Array;
        protected var _SafeStr_781:LoaderContext;
        protected var _SafeStr_793:AssetLibrary;
        protected var _manifest:XML;
        protected var _name:String;
        private var _counter:uint = 0;

        public function AssetLibraryCollection(name:String)
        {
            _name = name;
            _manifest = null;
            _SafeStr_794 = new Vector.<IAssetLibrary>();
            _SafeStr_792 = [];
            _SafeStr_781 = new LoaderContext(false, ApplicationDomain.currentDomain, null);
        }

        public function get url():String
        {
            return ("");
        }

        public function get name():String
        {
            return (_name);
        }

        public function get isReady():Boolean
        {
            return (_SafeStr_792.length == 0);
        }

        public function get numAssets():uint
        {
            return (getNumAssets());
        }

        public function get nameArray():Array
        {
            return (getAssetNameArray());
        }

        public function get manifest():XML
        {
            return ((_manifest) ? _manifest : _manifest = new XML());
        }

        public function get loaderContext():LoaderContext
        {
            return (_SafeStr_781);
        }

        public function set loaderContext(loaderContext:LoaderContext):void
        {
            _SafeStr_781 = loaderContext;
        }

        private function get binLibrary():IAssetLibrary
        {
            if (!_SafeStr_793)
            {
                _SafeStr_793 = new AssetLibrary("bin");
                _SafeStr_794.splice(0, 0, _SafeStr_793);
            };

            return (_SafeStr_793);
        }

        public function loadFromFile(libraryLoader:LibraryLoader, prepareAssets:Boolean=false):void
        {
            if (loaderContext == null)
            {
                loaderContext = _SafeStr_781;
            };

            var _local_3:IAssetLibrary = new AssetLibrary(("lib-" + _counter++));
            _SafeStr_792.push(_local_3);
            _local_3.loadFromFile(libraryLoader, prepareAssets);
            libraryLoader.addEventListener("LIBRARY_LOADER_EVENT_COMPLETE", loadEventHandler);
            libraryLoader.addEventListener("LIBRARY_LOADER_EVENT_ERROR", loadEventHandler);
            libraryLoader.addEventListener("LIBRARY_LOADER_EVENT_PROGRESS", loadEventHandler);
        }

        public function loadFromResource(xml:XML, type:Class):Boolean
        {
            return (binLibrary.loadFromResource(xml, type));
        }

        public function unload():void
        {
            while (_SafeStr_792.length > 0)
            {
                (_SafeStr_792.pop() as IAssetLibrary).dispose();
            };

            while (_SafeStr_794.length > 0)
            {
                (_SafeStr_794.pop() as IAssetLibrary).dispose();
            };
        }

        override public function dispose():void
        {
            var _local_2:uint;
            var _local_1:IAssetLibrary;
            var _local_3:uint;

            if (!disposed)
            {
                super.dispose();
                _local_2 = _SafeStr_794.length;
                _local_3 = 0;

                while (_local_3 < _local_2)
                {
                    _local_1 = _SafeStr_794.pop();
                    _local_1.dispose();
                    _local_3++;
                };

                _SafeStr_793 = null;
            };
        }

        private function loadEventHandler(event:LibraryLoaderEvent):void
        {
            var _local_3:LibraryLoader;
            var _local_2:IAssetLibrary;
            var _local_4:uint;

            if (event.type == "LIBRARY_LOADER_EVENT_COMPLETE")
            {
                _local_3 = (event.target as LibraryLoader);
                _local_4 = 0;

                while (_local_4 < _SafeStr_792.length)
                {
                    _local_2 = (_SafeStr_792[_local_4] as IAssetLibrary);

                    if (_local_2.url == _local_3.url)
                    {
                        _SafeStr_792.splice(_local_4, 1);
                        break;
                    };

                    _local_4++;
                };

                _SafeStr_794.push(_local_2);
                _local_3.removeEventListener("LIBRARY_LOADER_EVENT_COMPLETE", loadEventHandler);
                _local_3.removeEventListener("LIBRARY_LOADER_EVENT_ERROR", loadEventHandler);
                _local_3.removeEventListener("LIBRARY_LOADER_EVENT_PROGRESS", loadEventHandler);

                if (_SafeStr_792.length == 0)
                {
                    dispatchEvent(new Event("AssetLibraryLoaded"));
                };
            };
        }

        public function hasAssetLibrary(name:String):Boolean
        {
            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                if (_local_2.name == name)
                {
                    return (true);
                };
            };

            return (false);
        }

        public function getAssetLibraryByName(name:String):IAssetLibrary
        {
            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                if (_local_2.name == name)
                {
                    return (_local_2);
                };
            };

            return (null);
        }

        public function getAssetLibraryByUrl(url:String):IAssetLibrary
        {
            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                if (_local_2.url == url)
                {
                    return (_local_2);
                };
            };

            return (null);
        }

        public function getAssetLibraryByPartialUrl(_arg_1:String):IAssetLibrary
        {
            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                if (((_local_2.url) && (!(_local_2.url.indexOf(_arg_1) === -1))))
                {
                    return (_local_2);
                };
            };

            return (null);
        }

        public function addAssetLibrary(library:IAssetLibrary):void
        {
            if (_SafeStr_794.indexOf(library) == -1)
            {
                _SafeStr_794.push(library);
            };
        }

        public function loadAssetFromFile(name:String, urlRequest:URLRequest, type:String=null, _arg_4:String=null, _arg_5:String=null, _arg_6:int=-1):AssetLoaderStruct
        {
            return (binLibrary.loadAssetFromFile(name, urlRequest, type, _arg_4, _arg_5, _arg_6));
        }

        public function getAssetByName(_arg_1:String):IAsset
        {
            var _local_3:IAsset;

            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                _local_3 = _local_2.getAssetByName(_arg_1);

                if (_local_3 != null)
                {
                    return (_local_3);
                };
            };

            return (null);
        }

        public function getAssetsByName(name:String):Array
        {
            var _local_4:IAsset;
            var _local_2:Array = [];

            for each (var _local_3:IAssetLibrary in _SafeStr_794)
            {
                _local_4 = _local_3.getAssetByName(name);

                if (_local_4 != null)
                {
                    _local_2.push(_local_4);
                };
            };

            return (_local_2);
        }

        public function getAssetByContent(content:Object):IAsset
        {
            var _local_3:IAsset;

            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                _local_3 = _local_2.getAssetByContent(content);

                if (_local_3 != null)
                {
                    return (_local_3);
                };
            };

            return (null);
        }

        public function getAssetByIndex(index:uint):IAsset
        {
            var _local_2:uint;
            var _local_3:uint;

            for each (var _local_4:IAssetLibrary in _SafeStr_794)
            {
                _local_2 = (_local_2 + _local_4.numAssets);

                if (_local_2 <= index)
                {
                    return (_local_4.getAssetByIndex((index - _local_3)));
                };

                _local_3 = _local_2;
            };

            return (null);
        }

        public function getAssetIndex(asset:IAsset):int
        {
            var _local_2:int;
            var _local_4:int;

            for each (var _local_3:IAssetLibrary in _SafeStr_794)
            {
                _local_4 = _local_3.getAssetIndex(asset);

                if (_local_4 != -1)
                {
                    return (_local_2 + _local_4);
                };

                _local_2 = (_local_2 + _local_3.numAssets);
            };

            return (-1);
        }

        public function hasAsset(name:String):Boolean
        {
            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                if (_local_2.hasAsset(name))
                {
                    return (true);
                };
            };

            return (false);
        }

        public function setAsset(name:String, asset:IAsset, _arg_3:Boolean=true):Boolean
        {
            return (binLibrary.setAsset(name, asset, _arg_3));
        }

        public function createAsset(name:String, typeDeclaration:AssetTypeDeclaration):IAsset
        {
            return (binLibrary.createAsset(name, typeDeclaration));
        }

        public function removeAsset(asset:IAsset):IAsset
        {
            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                if (_local_2.removeAsset(asset) == asset)
                {
                    return (asset);
                };
            };

            return (null);
        }

        public function registerAssetTypeDeclaration(_arg_1:AssetTypeDeclaration, _arg_2:Boolean=true):Boolean
        {
            return (binLibrary.registerAssetTypeDeclaration(_arg_1, _arg_2));
        }

        public function getAssetTypeDeclarationByMimeType(type:String, shared:Boolean=true):AssetTypeDeclaration
        {
            var _local_3:AssetTypeDeclaration;

            if (shared)
            {
                return (binLibrary.getAssetTypeDeclarationByMimeType(type, true));
            };

            for each (var _local_4:IAssetLibrary in _SafeStr_794)
            {
                _local_3 = _local_4.getAssetTypeDeclarationByMimeType(type, false);

                if (_local_3 != null)
                {
                    return (_local_3);
                };
            };

            return (null);
        }

        public function getAssetTypeDeclarationByClass(typeClass:Class, shared:Boolean=true):AssetTypeDeclaration
        {
            var _local_3:AssetTypeDeclaration;

            if (shared)
            {
                return (binLibrary.getAssetTypeDeclarationByClass(typeClass, true));
            };

            for each (var _local_4:IAssetLibrary in _SafeStr_794)
            {
                _local_3 = _local_4.getAssetTypeDeclarationByClass(typeClass, false);

                if (_local_3 != null)
                {
                    return (_local_3);
                };
            };

            return (null);
        }

        public function getAssetTypeDeclarationByFileName(name:String, shared:Boolean=true):AssetTypeDeclaration
        {
            var _local_3:AssetTypeDeclaration;

            if (shared)
            {
                return (binLibrary.getAssetTypeDeclarationByFileName(name, true));
            };

            for each (var _local_4:IAssetLibrary in _SafeStr_794)
            {
                _local_3 = _local_4.getAssetTypeDeclarationByFileName(name, false);

                if (_local_3 != null)
                {
                    return (_local_3);
                };
            };

            return (null);
        }

        private function getNumAssets():uint
        {
            var _local_1:uint;

            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                _local_1 = (_local_1 + _local_2.numAssets);
            };

            return (_local_1);
        }

        private function getAssetNameArray():Array
        {
            var _local_2:Array = [];

            for each (var _local_1:IAssetLibrary in _SafeStr_794)
            {
                _local_2 = _local_2.concat(_local_1.nameArray);
            };

            return (_local_2);
        }

        public function getManifests():Array
        {
            var _local_2:Array = [];

            for each (var _local_1:IAssetLibrary in _SafeStr_794)
            {
                _local_2.push(_local_1.manifest);
            };

            return (_local_2);
        }

        private function buildManifest():XML
        {
            var _local_3:XML = new XML("<manifest><library></library></manifest>");
            var _local_1:XMLList = _local_3.child("library");

            if (_SafeStr_793)
            {
                applyManifestNodes(_local_1, _SafeStr_793);
            };

            for each (var _local_2:IAssetLibrary in _SafeStr_794)
            {
                applyManifestNodes(_local_1, _local_2);
            };

            return (_local_3);
        }

        private function applyManifestNodes(xmlList:XMLList, library:IAssetLibrary):void
        {
            var _local_3:XML;
            var _local_4:XMLList;
            var _local_5:XMLList = library.manifest.library.children();

            for each (var _local_6:XML in _local_5)
            {
                _local_3 = xmlList.child(_local_6.name())[0];

                if (!_local_3)
                {
                    xmlList.appendChild(new XML((("<" + _local_6.name()) + "/>")));
                    _local_3 = xmlList.child(_local_6.name())[0];
                };

                _local_4 = _local_6.children();

                for each (var _local_7:XML in _local_4)
                {
                    _local_3.appendChild(_local_7);
                };
            };
        }

    }
}
