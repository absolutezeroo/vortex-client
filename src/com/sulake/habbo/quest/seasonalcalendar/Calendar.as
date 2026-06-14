package com.sulake.habbo.quest.seasonalcalendar
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.assets.IAsset;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components._SafeStr_124;
    import com.sulake.core.window.components.ITextWindow;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.window.events.WindowEvent;

    public class Calendar implements IDisposable, IUpdateReceiver
    {

        private static const BG_IMAGE_PREFIX:String = "background_";
        private static const ENTITY_IMAGE_PREFIX:String = "day";
        private static const ENTITY_IMAGE_UNCOMPLETE_POSTFIX:String = "_uncomplete";
        private static const ENTITY_IMAGE_COMPLETED_POSTFIX:String = "_completed";
        private static const SHOW_FUTURE_INACTIVE_ENTITIES_COUNT:int = 2;
        private static const _SafeStr_3058:int = 3;
        private static const ENTITY_SPACING:int = 80;
        private static const ENTITIES_LEFT_MARGIN:int = 37;
        private static const _SafeStr_3059:int = 7;
        private static const DAILY_REFRESH_DELAY_MINUTES:int = 5;
        private static const FLASH_PULSE_LENGHT_IN_MS:int = 2000;
        private static const FLASH_MAX_BRIGHTNESS:int = 100;

        private var _questEngine:HabboQuestEngine;
        private var _mainWindow:MainWindow;
        private var _quests:Array;
        private var _backgroundImageCache:Vector.<BitmapData>;
        private var _graphicEntityCache:Vector.<BitmapData>;
        private var _assetNameToIndexMap:Map;
        private var _bgAssetNameArray:Array;
        private var _imageGalleryHost:String;
        private var _bgRenderer:CalendarBackgroundRenderer;
        private var _entityWindows:Vector.<IWindowContainer>;
        private var _states:Array;
        private var _leftArrow:CalendarArrowButton;
        private var _rightArrow:CalendarArrowButton;
        private var _containerWindow:IWindowContainer;
        private var _entityWindowTemplate:IWindowContainer;
        private var _backgroundSlice:IBitmapWrapperWindow;
        private var _viewIndex:int = -1;
        private var _totalEntityCount:int = -1;
        private var _highestAvailableQuestIndex:int = -1;
        private var _maximumEntities:int = 42;
        private var _scrollTimer:Timer;
        private var _scrollOffset:int = 0;
        private var _scrollDelta:int = 0;
        private var _scrollBgStartOffset:int = 0;
        private var _flashingPanelIndex:int = -1;
        private var _flashingOffsetMs:int;
        private var _hoveringIndex:int = -1;
        private var _scrollLeftPressed:Boolean = false;
        private var _scrollRightPressed:Boolean = false;
        private var _dateRefreshTimer:Timer;
        private var _lastDate:int = -1;

        public function Calendar(_arg_1:HabboQuestEngine, _arg_2:MainWindow)
        {
            _questEngine = _arg_1;
            _mainWindow = _arg_2;
        }

        private static function adjustBrightness(_arg_1:uint, _arg_2:int):uint
        {
            var _local_3:int = Math.min(0xFF, Math.max(0, (((_arg_1 >> 16) & 0xFF) + _arg_2)));
            var _local_5:int = Math.min(0xFF, Math.max(0, (((_arg_1 >> 8) & 0xFF) + _arg_2)));
            var _local_4:int = Math.min(0xFF, Math.max(0, ((_arg_1 & 0xFF) + _arg_2)));
            return ((((_local_3 & 0xFF) << 16) + ((_local_5 & 0xFF) << 8)) + (_local_4 & 0xFF));
        }

        private function getImageGalleryHost():String
        {
            return (_imageGalleryHost);
        }

        public function dispose():void
        {
            if (!disposed)
            {
                _questEngine.removeUpdateReceiver(this);
                cleanUpEntityWindows();

                if (_bgRenderer != null)
                {
                    _bgRenderer.dispose();
                    _bgRenderer = null;
                };

                if (_leftArrow != null)
                {
                    _leftArrow.dispose();
                    _leftArrow = null;
                };

                if (_rightArrow != null)
                {
                    _rightArrow.dispose();
                    _rightArrow = null;
                };

                if (_scrollTimer != null)
                {
                    _scrollTimer.stop();
                    _scrollTimer = null;
                };

                if (_dateRefreshTimer != null)
                {
                    _dateRefreshTimer.stop();
                    _dateRefreshTimer = null;
                };

                _backgroundImageCache = null;
                _graphicEntityCache = null;
                _states = null;
                _assetNameToIndexMap = null;
                _bgAssetNameArray = null;
                _questEngine = null;
            };
        }

        public function get disposed():Boolean
        {
            return (_questEngine == null);
        }

        public function onQuests(_arg_1:Array):void
        {
            var _local_4:Date = new Date();
            _lastDate = _local_4.getDate();

            var _local_2:int = _totalEntityCount;
            _quests = [];
            _highestAvailableQuestIndex = 0;

            var _local_3:QuestMessageData;

            for each (_local_3 in _arg_1)
            {
                if (_questEngine.isSeasonalQuest(_local_3))
                {
                    _quests.push(_local_3);

                    if (_highestAvailableQuestIndex < (_local_3.sortOrder - 1))
                    {
                        _highestAvailableQuestIndex = (_local_3.sortOrder - 1);
                    };
                };
            };

            _quests.sortOn(["sortOrder"]);
            _maximumEntities = int(_questEngine.configuration.getProperty("seasonalQuestCalendar.maximum.entities"));
            _totalEntityCount = Math.min(_maximumEntities, ((_highestAvailableQuestIndex + 1) + 2));

            if (((!(_local_2 == -1)) && (_totalEntityCount > _local_2)))
            {
                prepareImages();
            };
        }

        public function prepare(_arg_1:IFrameWindow):void
        {
            var _local_2:IBitmapWrapperWindow;
            _imageGalleryHost = _mainWindow.getCalendarImageGalleryHost();
            _containerWindow = IWindowContainer(_arg_1.findChildByName("calendar_cont"));
            _backgroundSlice = IBitmapWrapperWindow(_arg_1.findChildByName("background_slice"));
            _entityWindowTemplate = IWindowContainer(_arg_1.findChildByName("entity_template"));
            _entityWindowTemplate.visible = false;
            _bgRenderer = new CalendarBackgroundRenderer();
            _leftArrow = new CalendarArrowButton(_questEngine.assets, IBitmapWrapperWindow(_arg_1.findChildByName("button_left")), 0, scrollArrowProcedure);
            _rightArrow = new CalendarArrowButton(_questEngine.assets, IBitmapWrapperWindow(_arg_1.findChildByName("button_right")), 1, scrollArrowProcedure);
            _local_2 = IBitmapWrapperWindow(_arg_1.findChildByName("stripe_mask_left"));
            _local_2.bitmap = BitmapData(IAsset(_questEngine.assets.getAssetByName("stripe_mask_L")).content);
            _local_2 = IBitmapWrapperWindow(_arg_1.findChildByName("stripe_mask_right"));
            _local_2.bitmap = BitmapData(IAsset(_questEngine.assets.getAssetByName("stripe_mask_R")).content);

            if (_viewIndex == -1)
            {
                goToDay(_mainWindow.currentDay);
            };

            prepareImages();

            var _local_3:Date = new Date();
            _lastDate = _local_3.getDate();
            _dateRefreshTimer = new Timer((60000 * 5));
            _dateRefreshTimer.addEventListener("timer", onDateRefreshTimer);
            _dateRefreshTimer.start();
            onDateRefreshTimer(new TimerEvent("timer"));
            _questEngine.registerUpdateReceiver(this, 1);
            _scrollTimer = new Timer(10, 10);
        }

        public function close():void
        {
            cleanUpEntityWindows();

            if (_bgRenderer != null)
            {
                _bgRenderer.initializeImageChain(new Vector.<BitmapData>());
            };
        }

        public function refresh():void
        {
            var _local_1:int;
            var _local_2:int;

            for each (var _local_3:QuestMessageData in _quests)
            {
                _local_1 = (_local_3.sortOrder - 1);
                _local_2 = ((_local_3.completedCampaign) ? 2 : _states[_local_1]);

                if (_local_2 != _states[_local_1])
                {
                    retrieveEntityImageAsset(_local_3.sortOrder, _local_2);
                    updateEntityIndicatorPanel(_local_1, false);

                    if (((_local_2 == 2) && (_flashingPanelIndex == _local_1)))
                    {
                        stopFlashing();
                    };
                };
            };

            initializeBackgroundRendererIfAllImagesInCache();
            initializeEntitiesIfAllImagesInCache();
        }

        public function goToDay(_arg_1:int):void
        {
            scrollToIndex(Math.max(0, Math.min((_arg_1 - 3), maxScrollRightIndex)));
        }

        private function prepareImages():void
        {
            var _local_6:int;
            var _local_4:int;
            var _local_7:int;
            var _local_2:Boolean;
            var _local_3:int;
            var _local_5:int;
            var _local_1:int = int((Math.ceil((_totalEntityCount / 7)) + 1));
            _bgAssetNameArray = new Array(_local_1);
            _backgroundImageCache = new Vector.<BitmapData>(_local_1);
            _graphicEntityCache = new Vector.<BitmapData>(_totalEntityCount);
            _states = new Array(_totalEntityCount);

            var _local_8:Vector.<BitmapData> = new Vector.<BitmapData>();
            _local_6 = 0;

            while (_local_6 < _local_1)
            {
                _local_8.push(new BitmapData(640, 320, false, 0xFFFFFF));
                _local_6++;
            };

            _bgRenderer.initializeImageChain(_local_8);
            _local_4 = firstBgIndex;

            while (_local_4 <= lastBgIndex)
            {
                retrieveBackgroundImageAsset(_local_4);
                _local_4++;
            };

            _assetNameToIndexMap = new Map();

            for each (var _local_9:QuestMessageData in _quests)
            {
                if (_local_9.sortOrder <= _maximumEntities)
                {
                    _local_7 = ((_local_9.completedCampaign) ? 2 : 0);
                    _local_2 = (((_local_9.sortOrder - 1) >= firstVisibleIndex) && ((_local_9.sortOrder - 1) <= lastVisibleIndex));
                    retrieveEntityImageAsset(_local_9.sortOrder, _local_7, (!(_local_2)));
                };
            };

            if (_quests.length < _totalEntityCount)
            {
                _local_3 = (_highestAvailableQuestIndex + 1);

                while (_local_3 < _totalEntityCount)
                {
                    retrieveEntityImageAsset((_local_3 + 1), 1, (_local_3 > lastVisibleIndex));
                    _local_3++;
                };
            };

            _local_5 = 0;

            while (_local_5 < _totalEntityCount)
            {
                if (_states[_local_5] == null)
                {
                    retrieveEntityImageAsset((_local_5 + 1), 3, ((_local_5 < firstVisibleIndex) || (_local_5 > lastVisibleIndex)));
                };

                _local_5++;
            };
        }

        private function initializeBackgroundRendererIfAllImagesInCache():void
        {
            var _local_2:int;
            var _local_1:BitmapData;

            if (!areViewableBackgroundBitmapsInitialized())
            {
                return;
            };

            var _local_4:Array = [];
            var _local_5:Vector.<BitmapData> = new Vector.<BitmapData>();
            _local_2 = 0;

            while (_local_2 < _backgroundImageCache.length)
            {
                _local_1 = _backgroundImageCache[_local_2];

                if (_local_1 != null)
                {
                    _local_5.push(_local_1);
                }

                else
                {
                    _local_5.push(new BitmapData(640, 320, false, 0xFFFFFF));
                    _local_4.push(_local_2);
                };

                _local_2++;
            };

            _bgRenderer.initializeImageChain(_local_5);
            assignCurrentBackgroundSlice();

            for each (var _local_3:int in _local_4)
            {
                retrieveBackgroundImageAsset(_local_3);
            };
        }

        private function cleanUpEntityWindows():void
        {
            if (_entityWindows == null)
            {
                return;
            };

            for each (var _local_1:IWindow in _entityWindows)
            {
                _containerWindow.removeChild(_local_1);
                _local_1.dispose();
            };

            _entityWindows = null;
        }

        private function initializeEntitiesIfAllImagesInCache():void
        {
            var _local_8:IWindowContainer;
            var _local_6:int;
            var _local_9:IBitmapWrapperWindow;
            var _local_2:IWindow;
            var _local_1:IWindow;
            var _local_3:IWindow;

            if (!areViewableEntityBitmapsInitialized())
            {
                return;
            };

            cleanUpEntityWindows();

            if (_entityWindows == null)
            {
                _entityWindows = new Vector.<IWindowContainer>();
            };

            var _local_5:Array = [];

            for each (var _local_4:BitmapData in _graphicEntityCache)
            {
                _local_8 = IWindowContainer(_entityWindowTemplate.clone());
                _local_6 = _entityWindows.length;

                if (_local_4 != null)
                {
                    _local_9 = (_local_8.findChildByName("entity_bitmap") as IBitmapWrapperWindow);
                    _local_9.width = _local_4.width;
                    _local_9.height = _local_4.height;
                    _local_9.bitmap = _local_4.clone();
                }

                else
                {
                    _local_5.push(_local_6);
                };

                _local_2 = _local_8.findChildByName("entity_mouse_region");
                _local_2.procedure = entityMouseRegionWindowProcedure;

                if ((((_states[_local_6] == 1) || (_states[_local_6] == 2)) || (_states[_local_6] == 3)))
                {
                    _local_2.visible = false;
                };

                _local_8.visible = true;
                _containerWindow.addChild(_local_8);
                _entityWindows.push(_local_8);
                updateEntityIndicatorPanel(_local_6, false);
            };

            repositionEntityWrappers();
            updateEntityVisibilities();
            _local_1 = _containerWindow.findChildByName("stripe_mask_left");
            _containerWindow.setChildIndex(_local_1, (_containerWindow.numChildren - 1));
            _local_1 = _containerWindow.findChildByName("stripe_mask_right");
            _containerWindow.setChildIndex(_local_1, (_containerWindow.numChildren - 1));
            _local_3 = _containerWindow.findChildByName("button_left");
            _containerWindow.setChildIndex(_local_3, (_containerWindow.numChildren - 1));
            _local_3 = _containerWindow.findChildByName("button_right");
            _containerWindow.setChildIndex(_local_3, (_containerWindow.numChildren - 1));

            for each (var _local_7:int in _local_5)
            {
                retrieveEntityImageAsset((_local_7 + 1), _states[_local_7]);
            };

            if (_states[(_mainWindow.currentDay - 1)] == 0)
            {
                startFlashingAtIndex((_mainWindow.currentDay - 1));
            };
        }

        private function get firstVisibleIndex():int
        {
            var _local_1:int = (_viewIndex - 1);
            return ((_local_1 < 0) ? 0 : _local_1);
        }

        private function get lastVisibleIndex():int
        {
            var _local_2:int = ((_viewIndex + 7) + 1);
            var _local_1:int = (_totalEntityCount - 1);
            return ((_local_2 > _local_1) ? _local_1 : _local_2);
        }

        private function areViewableEntityBitmapsInitialized():Boolean
        {
            var _local_1:int;

            if (_graphicEntityCache == null)
            {
                return (false);
            };

            _local_1 = firstVisibleIndex;

            while (_local_1 <= lastVisibleIndex)
            {
                if (_graphicEntityCache[_local_1] == null)
                {
                    return (false);
                };

                _local_1++;
            };

            return (true);
        }

        private function get firstBgIndex():int
        {
            var _local_2:int = getBackgroundSliceOffset(_viewIndex);
            var _local_1:int = _bgRenderer.getImageIndexForOffset(_local_2);
            return ((_local_1 < 0) ? 0 : _local_1);
        }

        private function get lastBgIndex():int
        {
            var _local_1:int = getBackgroundSliceOffset(_viewIndex);
            return (_bgRenderer.getImageIndexForOffset((_local_1 + 640)));
        }

        private function areViewableBackgroundBitmapsInitialized():Boolean
        {
            var _local_1:int;

            if (_backgroundImageCache == null)
            {
                return (false);
            };

            var _local_2:int = getBackgroundSliceOffset(_viewIndex);
            _local_1 = firstBgIndex;

            while (_local_1 <= lastBgIndex)
            {
                if (_backgroundImageCache[_local_1] == null)
                {
                    return (false);
                };

                _local_1++;
            };

            return (true);
        }

        private function updateEntityIndicatorPanel(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_6:BitmapData;
            var _local_7:String;

            if (((_entityWindows == null) || (_entityWindows.length < (_arg_1 - 1))))
            {
                return;
            };

            var _local_3:_SafeStr_124 = _SafeStr_124(_entityWindows[_arg_1].findChildByName("entity_indicator"));
            var _local_5:uint = CalendarEntityStateEnums.INDICATOR_COLOR[_states[_arg_1]];

            if (_arg_2)
            {
                _local_5 = (_local_5 + 0x202020);
            };

            if (_flashingPanelIndex != _arg_1)
            {
                _local_3.color = _local_5;
            };

            var _local_9:IBitmapWrapperWindow = IBitmapWrapperWindow(_entityWindows[_arg_1].findChildByName("entity_indicator_status"));

            if (_states[_arg_1] == 2)
            {
                _local_6 = BitmapData(_questEngine.assets.getAssetByName("calendar_quest_complete").content);
                _local_9.width = _local_6.width;
                _local_9.height = _local_6.height;
                _local_9.bitmap = _local_6.clone();
            }

            else
            {
                _local_9.bitmap = null;
            };

            var _local_4:ITextWindow = (_local_3.findChildByName("entity_indicator_text") as ITextWindow);
            var _local_8:QuestMessageData = getQuestByEntityWindowIndex(_arg_1);

            if (_local_8 != null)
            {
                _local_4.text = _questEngine.getCampaignName(_local_8);
            }

            else
            {
                _local_7 = QuestMessageData.getCampaignLocalizationKeyForCode(((_questEngine.getSeasonalCampaignCodePrefix() + "_") + (_arg_1 + 1)));
                _local_4.text = _questEngine.getCampaignNameByCode(_local_7);
            };
        }

        private function retrieveEntityImageAsset(_arg_1:int, _arg_2:int, _arg_3:Boolean=false):void
        {
            var _local_4:String = ("day" + _arg_1);
            switch (_arg_2)
            {
                case 0:
                case 1:
                case 3:
                    _local_4 = (_local_4 + "_uncomplete");
                    break;
                case 2:
                    _local_4 = (_local_4 + "_completed");
                default:
            };

            _states[(_arg_1 - 1)] = _arg_2;
            _assetNameToIndexMap[_local_4] = (_arg_1 - 1);

            var _local_5:IAsset = _questEngine.assets.getAssetByName(_local_4);

            if (_local_5 != null)
            {
                assignEntityBitmapToCacheByAssetName(_local_4);
                initializeEntitiesIfAllImagesInCache();
            }

            else
            {
                if (!_arg_3)
                {
                    loadAssetFromImageGallery(_local_4, onEntityImageAssetDownloaded);
                };
            };
        }

        private function retrieveBackgroundImageAsset(_arg_1:int):void
        {
            var _local_2:String = ("background_" + (_arg_1 + 1));
            _bgAssetNameArray[_arg_1] = _local_2;

            var _local_3:IAsset = _questEngine.assets.getAssetByName(_local_2);

            if (_local_3 != null)
            {
                assignBackgroundBitmapToCacheByAssetName(_local_2);
                initializeBackgroundRendererIfAllImagesInCache();
            }

            else
            {
                loadAssetFromImageGallery(_local_2, onBackgroundImageAssetDownloaded);
            };
        }

        private function loadAssetFromImageGallery(_arg_1:String, _arg_2:Function):void
        {
            var _local_5:String = ((getImageGalleryHost() + _arg_1) + ".png");
            var _local_3:URLRequest = new URLRequest(_local_5);
            var _local_4:AssetLoaderStruct = _questEngine.assets.loadAssetFromFile(_arg_1, _local_3, "image/png");

            if (((_local_4) && (!(_local_4.disposed))))
            {
                _local_4.addEventListener("AssetLoaderEventComplete", _arg_2);
                _local_4.addEventListener("AssetLoaderEventError", _arg_2);
            };
        }

        private function onBackgroundImageAssetDownloaded(_arg_1:AssetLoaderEvent):void
        {
            var _local_2:AssetLoaderStruct = (_arg_1.target as AssetLoaderStruct);

            if (_local_2 != null)
            {
                assignBackgroundBitmapToCacheByAssetName(_local_2.assetName);
            };

            initializeBackgroundRendererIfAllImagesInCache();
        }

        private function onEntityImageAssetDownloaded(_arg_1:AssetLoaderEvent):void
        {
            var _local_2:AssetLoaderStruct = (_arg_1.target as AssetLoaderStruct);

            if (_local_2 != null)
            {
                assignEntityBitmapToCacheByAssetName(_local_2.assetName);
            };

            initializeEntitiesIfAllImagesInCache();
        }

        private function assignBackgroundBitmapToCacheByAssetName(_arg_1:String):void
        {
            var _local_2:int = _bgAssetNameArray.indexOf(_arg_1);

            if (_local_2 == -1)
            {
                return;
            };

            var _local_3:IAsset = _questEngine.assets.getAssetByName(_arg_1);
            _backgroundImageCache[_local_2] = ((_local_3 != null) ? (_local_3.content as BitmapData) : new BitmapData(640, 320));
        }

        private function assignEntityBitmapToCacheByAssetName(_arg_1:String):void
        {
            var _local_3:IAsset = _questEngine.assets.getAssetByName(_arg_1);
            var _local_2:int = _assetNameToIndexMap[_arg_1];

            if (((_local_2 == -1) || (_local_2 >= _graphicEntityCache.length)))
            {
                return;
            };

            _graphicEntityCache[_local_2] = ((_local_3 != null) ? (_local_3.content as BitmapData) : new BitmapData(1, 1, true, 0));
        }

        private function repositionEntityWrappers():void
        {
            var _local_1:int;

            if (_entityWindows == null)
            {
                return;
            };

            _local_1 = 0;

            while (_local_1 < _entityWindows.length)
            {
                _entityWindows[_local_1].x = ((((_local_1 - _viewIndex) * 80) + _scrollOffset) + 37);
                _local_1++;
            };
        }

        private function getBackgroundSliceOffset(_arg_1:int):int
        {
            return (_arg_1 * 80);
        }

        private function assignCurrentBackgroundSlice():void
        {
            var _local_1:BitmapData = _bgRenderer.getSlice(getBackgroundSliceOffset(_viewIndex), _containerWindow.width);
            _backgroundSlice.x = 0;
            _backgroundSlice.width = _local_1.width;
            _backgroundSlice.height = _local_1.height;
            _backgroundSlice.bitmap = _local_1.clone();
        }

        private function assignScrollableBackgroundSlice(_arg_1:int):void
        {
            var _local_3:BitmapData;
            var _local_5:int;
            var _local_4:int;
            var _local_2:int;
            var _local_6:int;

            if (_arg_1 < _viewIndex)
            {
                _local_5 = (_viewIndex - _arg_1);
                _local_4 = getBackgroundSliceOffset(_arg_1);
                _local_3 = _bgRenderer.getSlice(_local_4, (_containerWindow.width + (80 * _local_5)));
                _scrollBgStartOffset = -(80 * _local_5);
            }

            else
            {
                _local_2 = (_arg_1 - _viewIndex);
                _local_6 = ((80 * _local_2) + _containerWindow.width);
                _local_3 = _bgRenderer.getSlice(getBackgroundSliceOffset(_viewIndex), _local_6);
                _scrollBgStartOffset = 0;
            };

            _backgroundSlice.x = _scrollBgStartOffset;

            if (_local_3 != null)
            {
                _backgroundSlice.width = _local_3.width;
                _backgroundSlice.height = _local_3.height;
                _backgroundSlice.bitmap = _local_3.clone();
            };
        }

        private function repositionBackgroundSlice():void
        {
            _backgroundSlice.x = (_scrollBgStartOffset + _scrollOffset);
        }

        private function scrollToIndex(_arg_1:int):void
        {
            if (((_arg_1 < 0) || (_arg_1 >= _totalEntityCount)))
            {
                return;
            };

            if (((!(_scrollTimer == null)) && (_scrollTimer.running)))
            {
                return;
            };

            if (!areViewableEntityBitmapsInitialized())
            {
                _viewIndex = _arg_1;
                enableScrollArrowsByViewIndex();
                return;
            };

            var _local_2:int = _viewIndex;
            _viewIndex = _arg_1;

            if (areViewableBackgroundBitmapsInitialized())
            {
                _viewIndex = _local_2;
                assignScrollableBackgroundSlice(_arg_1);
                updateEntityVisibilities(true, (_arg_1 - _viewIndex));
                _scrollDelta = (-(80 * (_arg_1 - _viewIndex)) / 10);
                _scrollTimer = new Timer(10, 10);
                _scrollTimer.addEventListener("timer", onAnimateScroll);
                _scrollTimer.addEventListener("timerComplete", onAnimateScroll);
                _scrollTimer.start();
            }

            else
            {
                _viewIndex = _local_2;
            };
        }

        private function get maxScrollRightIndex():int
        {
            return (_maximumEntities - 7);
        }

        private function enableScrollArrowsByViewIndex():void
        {
            if (_viewIndex > 0)
            {
                _leftArrow.activate();
            }

            else
            {
                _leftArrow.deactivate();
            };

            if (_viewIndex < Math.min(((_totalEntityCount - 3) - 1), maxScrollRightIndex))
            {
                _rightArrow.activate();
            }

            else
            {
                _rightArrow.deactivate();
            };
        }

        private function updateEntityVisibilities(_arg_1:Boolean=false, _arg_2:int=0):void
        {
            var _local_4:int;
            var _local_3:int;
            var _local_5:int;

            if (_entityWindows != null)
            {
                _local_4 = (_viewIndex - 1);

                if (((_arg_1) && (_arg_2 < 0)))
                {
                    _local_4 = (_local_4 + _arg_2);
                };

                _local_3 = ((_viewIndex + 7) + 1);

                if (((_arg_1) && (_arg_2 > 0)))
                {
                    _local_3 = (_local_3 + _arg_2);
                };

                _local_5 = 0;

                while (_local_5 < _entityWindows.length)
                {
                    if (((_local_5 < _local_4) || (_local_5 > _local_3)))
                    {
                        _entityWindows[_local_5].visible = false;
                    }

                    else
                    {
                        _entityWindows[_local_5].visible = true;

                        if (((_local_5 == _local_4) || (_local_5 == _local_3)))
                        {
                            _entityWindows[_local_5].getChildByName("entity_mouse_region").visible = false;
                        }

                        else
                        {
                            if (_states[_local_5] == 0)
                            {
                                _entityWindows[_local_5].getChildByName("entity_mouse_region").visible = true;
                            };
                        };
                    };

                    _local_5++;
                };
            };
        }

        private function onAnimateScroll(_arg_1:TimerEvent):void
        {
            switch (_arg_1.type)
            {
                case "timer":
                    _scrollOffset = (_scrollOffset + _scrollDelta);
                    repositionBackgroundSlice();
                    repositionEntityWrappers();
                    return;
                case "timerComplete":
                    _scrollOffset = 0;

                    if (_scrollDelta > 0)
                    {
                        _viewIndex = (_viewIndex - 1);
                    }

                    else
                    {
                        _viewIndex = (_viewIndex + 1);
                    };

                    assignCurrentBackgroundSlice();
                    repositionEntityWrappers();
                    enableScrollArrowsByViewIndex();
                    updateEntityVisibilities();
                    _scrollTimer.removeEventListener("timer", onAnimateScroll);
                    _scrollTimer.removeEventListener("timerComplete", onAnimateScroll);
                    return;
            };
        }

        private function scrollArrowProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type == "WME_DOWN")
            {
                switch (_arg_2.name)
                {
                    case "button_left":
                        _scrollLeftPressed = true;
                        break;
                    case "button_right":
                        _scrollRightPressed = true;
                };
            };

            if (((_arg_1.type == "WME_UP") || (_arg_1.type == "WME_UP_OUTSIDE")))
            {
                _scrollLeftPressed = false;
                _scrollRightPressed = false;
            };
        }

        private function entityMouseRegionWindowProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:int;
            var _local_4:QuestMessageData;

            if (_arg_2.name == "entity_mouse_region")
            {
                _local_3 = _entityWindows.indexOf((_arg_2.parent as IWindowContainer));

                if (_arg_1.type == "WME_CLICK")
                {
                    _local_4 = getQuestByEntityWindowIndex(_local_3);

                    if (_local_4 != null)
                    {
                        _questEngine.questController.questDetails.openDetails(_local_4, true);
                    };
                };

                if (_arg_1.type == "WME_OVER")
                {
                    updateEntityIndicatorPanel(_local_3, true);
                    _hoveringIndex = _local_3;
                };

                if (_arg_1.type == "WME_OUT")
                {
                    updateEntityIndicatorPanel(_local_3, false);
                    _hoveringIndex = -1;
                };
            };
        }

        private function getQuestByEntityWindowIndex(_arg_1:int):QuestMessageData
        {
            for each (var _local_2:QuestMessageData in _quests)
            {
                if ((_local_2.sortOrder - 1) == _arg_1)
                {
                    return (_local_2);
                };
            };

            return (null);
        }

        public function update(_arg_1:uint):void
        {
            var _local_5:int;
            var _local_4:Number;
            var _local_2:_SafeStr_124;
            var _local_3:Number;

            if (((!(_entityWindows == null)) && (!(_flashingPanelIndex == -1))))
            {
                _local_5 = CalendarEntityStateEnums.INDICATOR_COLOR[_states[_flashingPanelIndex]];
                _local_4 = ((_flashingOffsetMs % 2000) / 2000);
                _local_4 = Math.abs((2 * ((_local_4 > 0.5) ? _local_4 = (_local_4 - 1) : _local_4)));
                _local_2 = _SafeStr_124(_entityWindows[_flashingPanelIndex].findChildByName("entity_indicator"));

                if (_local_2)
                {
                    _local_3 = (_local_4 * 100);

                    if (_hoveringIndex == _flashingPanelIndex)
                    {
                        _local_3 = (_local_3 + 20);
                    };

                    _local_2.color = adjustBrightness(_local_5, _local_3);
                };

                _flashingOffsetMs = (_flashingOffsetMs + _arg_1);
            };

            if (_scrollTimer != null)
            {
                if ((((_scrollLeftPressed) && (!(_scrollTimer.running))) && (_scrollOffset == 0)))
                {
                    if (((_viewIndex > 0) && (!(_leftArrow.isInactive()))))
                    {
                        scrollToIndex((_viewIndex - 1));
                    };
                };

                if ((((_scrollRightPressed) && (!(_scrollTimer.running))) && (_scrollOffset == 0)))
                {
                    if (((_viewIndex < _highestAvailableQuestIndex) && (!(_rightArrow.isInactive()))))
                    {
                        scrollToIndex((_viewIndex + 1));
                    };
                };
            };
        }

        private function startFlashingAtIndex(_arg_1:int):void
        {
            if (((_arg_1 < 0) || (_arg_1 >= _totalEntityCount)))
            {
                return;
            };

            _flashingPanelIndex = _arg_1;
            _flashingOffsetMs = 0;
        }

        private function stopFlashing():void
        {
            _flashingPanelIndex = -1;
        }

        private function onDateRefreshTimer(_arg_1:TimerEvent):void
        {
            var _local_2:Date = new Date();

            if (_lastDate != _local_2.getDate())
            {
                _questEngine.requestSeasonalQuests();
            };

            _lastDate = _local_2.getDate();
        }

    }
}