package com.sulake.habbo.avatar
{
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import flash.utils.Dictionary;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.utils.Timer;
    import flash.net.URLRequest;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import flash.events.Event;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.avatar.events.LibraryLoadedEvent;

    public class EffectAssetDownloadManager extends EventDispatcherWrapper 
    {

        public static const LIBRARY_LOADED:String = "LIBRARY_LOADED";

        private const DOWNLOAD_TIMEOUT:int = 100;
        private const MAX_SIMULTANEOUS_DOWNLOADS:int = 2;

        private var _missingMandatoryLibs:Array = ["dance.1", "dance.2", "dance.3", "dance.4"];
        private var _map:Dictionary;
        private var _mapDownloadTriesLeft:int = 3;
        private var _mapLoader:AssetLoaderStruct;
        private var _assets:IAssetLibrary;
        private var _isInitReady:Boolean;
        private var _configurationURL:String;
        private var _assetDownloadUrl:String;
        private var _assetLibraryNameTemplate:String;
        private var _structure:AvatarStructure;
        private var _listeners:Dictionary;
        private var _incompleteEffects:Dictionary;
        private var _downloadShiftTimer:Timer;
        private var _initDownloadBuffer:Array;
        private var _pendingDownloadQueue:Array;
        private var _currentDownloads:Array;

        public function EffectAssetDownloadManager(_arg_1:IAssetLibrary, _arg_2:String, _arg_3:String, _arg_4:AvatarStructure, _arg_5:String)
        {
            super();

            var _local_9:XmlAsset = null;
            var _local_7:XML = null;
            _map = new Dictionary();
            _assets = _arg_1;
            _structure = _arg_4;
            _configurationURL = _arg_2;
            _assetDownloadUrl = _arg_3;
            _assetLibraryNameTemplate = _arg_5;
            _listeners = new Dictionary();
            _incompleteEffects = new Dictionary();
            _initDownloadBuffer = [];
            _pendingDownloadQueue = [];
            _currentDownloads = [];

            var _local_6:URLRequest = new URLRequest(_configurationURL);
            var _local_8:IAsset = _assets.getAssetByName("effectmap");

            if (_local_8 == null)
            {
                _mapLoader = _assets.loadAssetFromFile("effectmap", _local_6, "text/xml");
                addMapLoaderEventListeners();
            }

            else
            {
                _local_9 = (_assets.getAssetByName("effectmap") as XmlAsset);
                _local_7 = (_local_9.content as XML).copy();
                loadEffectMapData(_local_7);
            };

            _downloadShiftTimer = new Timer(100, 1);
            _downloadShiftTimer.addEventListener("timerComplete", onNextDownloadTimeout);
            _structure.renderManager.events.addEventListener("AVATAR_RENDER_READY", purgeInitDownloadBuffer);
        }

        public function loadMandatoryLibs():void
        {
            var _local_4:Array;
            var _local_1:Array = _missingMandatoryLibs.slice();

            for each (var _local_3:String in _local_1)
            {
                _local_4 = _map[_local_3];

                if (_local_4 != null)
                {
                    for each (var _local_2:EffectAssetDownloadLibrary in _local_4)
                    {
                        addToQueue(_local_2);
                    };
                };
            };
        }

        private function addMapLoaderEventListeners():void
        {
            if (_mapLoader)
            {
                _mapLoader.addEventListener("AssetLoaderEventComplete", onConfigurationComplete);
                _mapLoader.addEventListener("AssetLoaderEventError", onConfigurationError);
            };
        }

        private function removeMapLoaderEventListeners():void
        {
            if (_mapLoader)
            {
                _mapLoader.removeEventListener("AssetLoaderEventComplete", onConfigurationComplete);
                _mapLoader.removeEventListener("AssetLoaderEventError", onConfigurationError);
            };
        }

        private function onConfigurationComplete(event:Event):void
        {
            var _local_2:XML;

            if (disposed)
            {
                return;
            };

            var _local_3:AssetLoaderStruct = (event.target as AssetLoaderStruct);

            if (_local_3 == null)
            {
                return;
            };

            try
            {
                _local_2 = new XML((_local_3.assetLoader.content as String));
            }

            catch(e:Error)
            {
                return;
            };

            loadEffectMapData(_local_2);
        }

        private function onConfigurationError(_arg_1:Event):void
        {
            var _local_2:String;
            var _local_3:URLRequest;

            if (disposed)
            {
                return;
            };

            _mapDownloadTriesLeft--;

            if (_mapDownloadTriesLeft <= 0)
            {
                HabboWebTools.logEventLog(("Effect download error " + _configurationURL));
            }

            else
            {
                if (_configurationURL.indexOf("?") > 0)
                {
                    _local_2 = ((_configurationURL + "&retry=") + _mapDownloadTriesLeft);
                }

                else
                {
                    _local_2 = ((_configurationURL + "?retry=") + _mapDownloadTriesLeft);
                };

                removeMapLoaderEventListeners();
                _local_3 = new URLRequest(_local_2);
                _mapLoader = _assets.loadAssetFromFile("effectmap", _local_3, "text/xml");
                addMapLoaderEventListeners();
            };
        }

        private function loadEffectMapData(_arg_1:XML):void
        {
            if (_arg_1 == null)
            {
                return;
            };

            if (_arg_1.toString() == "")
            {
                return;
            };

            generateMap(_arg_1);
            loadMandatoryLibs();
            _isInitReady = true;
            dispatchEvent(new Event("complete"));
        }

        private function generateMap(_arg_1:XML):void
        {
            var _local_2:EffectAssetDownloadLibrary;
            var _local_3:String;
            var _local_5:Array;

            for each (var _local_4:XML in _arg_1.effect)
            {
                _local_2 = new EffectAssetDownloadLibrary(_local_4.@lib, "0", _assetDownloadUrl, _assets, _assetLibraryNameTemplate);
                _local_2.addEventListener("complete", libraryComplete);
                _local_3 = _local_4.@id;
                _local_5 = _map[_local_3];

                if (_local_5 == null)
                {
                    _local_5 = [];
                };

                _local_5.push(_local_2);
                _map[_local_3] = _local_5;
            };
        }

        private function libraryComplete(_arg_1:Event):void
        {
            var _local_2:String;
            var _local_11:Array;
            var _local_10:Boolean;
            var _local_5:Array;
            var _local_7:EffectAssetDownloadLibrary;
            var _local_8:int;

            if (disposed)
            {
                return;
            };

            var _local_4:Array = [];
            var _local_9:EffectAssetDownloadLibrary = (_arg_1.target as EffectAssetDownloadLibrary);
            _structure.registerAnimation(_local_9.animation);

            for (_local_2 in _incompleteEffects)
            {
                _local_10 = true;
                _local_11 = _incompleteEffects[_local_2];

                for each (var _local_3:EffectAssetDownloadLibrary in _local_11)
                {
                    if (!_local_3.isReady)
                    {
                        _local_10 = false;
                        break;
                    };
                };

                if (_local_10)
                {
                    _local_4.push(_local_2);
                    _local_5 = _listeners[_local_2];

                    for each (var _local_6:IAvatarEffectListener in _local_5)
                    {
                        if (((!(_local_6 == null)) && (!(_local_6.disposed))))
                        {
                            _local_6.avatarEffectReady(parseInt(_local_2));
                        };
                    };

                    delete _listeners[_local_2];
                };
            };

            for each (_local_2 in _local_4)
            {
                delete _incompleteEffects[_local_2];
            };

            while (_local_8 < _currentDownloads.length)
            {
                _local_7 = _currentDownloads[_local_8];

                if (_local_7.name == _local_9.name)
                {
                    _currentDownloads.splice(_local_8, 1);
                };

                _local_8++;
            };

            if (_local_4.length > 0)
            {
                dispatchEvent(new LibraryLoadedEvent("LIBRARY_LOADED", _local_9.name));
            };

            _downloadShiftTimer.start();
        }

        public function isReady(_arg_1:int):Boolean
        {
            if (((!(_isInitReady)) || (!(_structure.renderManager.isReady))))
            {
                return (false);
            };

            var _local_2:Array = getLibsToDownload(_arg_1);
            return (_local_2.length == 0);
        }

        public function loadEffectData(_arg_1:int, _arg_2:IAvatarEffectListener):void
        {
            var _local_5:Array;

            if (((!(_isInitReady)) || (!(_structure.renderManager.isReady))))
            {
                _initDownloadBuffer.push([_arg_1, _arg_2]);
                return;
            };

            var _local_4:Array = getLibsToDownload(_arg_1);

            if (_local_4.length > 0)
            {
                if (((_arg_2) && (!(_arg_2.disposed))))
                {
                    _local_5 = _listeners[String(_arg_1)];

                    if (_local_5 == null)
                    {
                        _local_5 = [];
                    };

                    _local_5.push(_arg_2);
                    _listeners[String(_arg_1)] = _local_5;
                };

                _incompleteEffects[String(_arg_1)] = _local_4;

                for each (var _local_3:EffectAssetDownloadLibrary in _local_4)
                {
                    addToQueue(_local_3);
                };
            }

            else
            {
                if (((!(_arg_2 == null)) && (!(_arg_2.disposed))))
                {
                    _arg_2.avatarEffectReady(_arg_1);
                    Logger.log(("Effect ready to use: " + _arg_1));
                };
            };
        }

        private function getLibsToDownload(_arg_1:int):Array
        {
            var _local_3:Array = [];

            if (!_structure)
            {
                return (_local_3);
            };

            var _local_4:Array = _map[String(_arg_1)];

            if (_local_4 != null)
            {
                for each (var _local_2:EffectAssetDownloadLibrary in _local_4)
                {
                    if (_local_2 != null)
                    {
                        if (!_local_2.isReady)
                        {
                            if (_local_3.indexOf(_local_2) == -1)
                            {
                                _local_3.push(_local_2);
                            };
                        };
                    };
                };
            };

            return (_local_3);
        }

        private function processPending():void
        {
            var _local_1:EffectAssetDownloadLibrary;

            while (((_pendingDownloadQueue.length > 0) && (_currentDownloads.length < 2)))
            {
                _local_1 = _pendingDownloadQueue.shift();
                _local_1.startDownloading();
                _currentDownloads.push(_local_1);
            };
        }

        private function addToQueue(_arg_1:EffectAssetDownloadLibrary):void
        {
            if ((((!(_arg_1.isReady)) && (_pendingDownloadQueue.indexOf(_arg_1) == -1)) && (_currentDownloads.indexOf(_arg_1) == -1)))
            {
                _pendingDownloadQueue.push(_arg_1);
                processPending();
            };
        }

        private function onNextDownloadTimeout(_arg_1:Event=null):void
        {
            processPending();
        }

        private function purgeInitDownloadBuffer(_arg_1:Event):void
        {
            var _local_2:Array;

            for each (_local_2 in _initDownloadBuffer)
            {
                loadEffectData(_local_2[0], _local_2[1]);
            };

            _initDownloadBuffer = [];
        }

        public function get map():Dictionary
        {
            return (_map);
        }

    }
}
