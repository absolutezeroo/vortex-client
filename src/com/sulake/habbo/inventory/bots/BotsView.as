package com.sulake.habbo.inventory.bots
{
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.parser.inventory.bots.BotData;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components._SafeStr_101;

    public class BotsView implements IInventoryView, IAvatarImageListener 
    {

        private const STATE_NULL:int = 0;
        private const STATE_INITIALIZING:int = 1;
        private const STATE_EMPTY:int = 2;
        private const STATE_CONTENT:int = 3;

        private var _windowManager:IHabboWindowManager;
        private var _assetLibrary:IAssetLibrary;
        private var _view:IWindowContainer;
        private var _model:BotsModel;
        private var _disposed:Boolean = false;
        private var _grid:IItemGridWindow;
        private var _roomEngine:IRoomEngine;
        private var _avatarRenderer:IAvatarRenderManager;
        private var _gridItems:Map;
        private var _selectedGridItem:BotGridItem;
        private var _currentState:int = 0;
        private var _previewImageDownloadId:int;
        private var _isInitialized:Boolean = false;

        public function BotsView(_arg_1:BotsModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IRoomEngine, _arg_5:IAvatarRenderManager)
        {
            _model = _arg_1;
            _assetLibrary = _arg_3;
            _windowManager = _arg_2;
            _roomEngine = _arg_4;
            _avatarRenderer = _arg_5;
            _gridItems = new Map();
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get isVisible():Boolean
        {
            return (((_view) && (!(_view.parent == null))) && (_view.visible));
        }

        public function dispose():void
        {
            _windowManager = null;
            _avatarRenderer = null;
            _roomEngine = null;
            _assetLibrary = null;
            _model = null;
            _view = null;
            _disposed = true;
        }

        public function update():void
        {
            if (!_isInitialized)
            {
                return;
            };

            updateGrid();
            updatePreview(_selectedGridItem);
            updateContainerVisibility();
        }

        public function removeItem(_arg_1:int):void
        {
            if (!_isInitialized)
            {
                return;
            };

            var _local_2:BotGridItem = (_gridItems.remove(_arg_1) as BotGridItem);

            if (_local_2 == null)
            {
                return;
            };

            _grid.removeGridItem(_local_2.window);

            if (_selectedGridItem == _local_2)
            {
                _selectedGridItem = null;
                selectFirst();
            };
        }

        public function addItem(_arg_1:BotData):void
        {
            if (!_isInitialized)
            {
                return;
            };

            if (_arg_1 == null)
            {
                return;
            };

            if (_gridItems.getValue(_arg_1.id) != null)
            {
                return;
            };

            var _local_2:BotGridItem = new BotGridItem(this, _arg_1, _windowManager, _assetLibrary, _model.isUnseen(_arg_1.id));

            if (_local_2 != null)
            {
                _grid.addGridItem(_local_2.window);
                _gridItems.add(_arg_1.id, _local_2);

                if (_selectedGridItem == null)
                {
                    selectFirst();
                };
            };
        }

        public function placeItemToRoom(_arg_1:int, _arg_2:Boolean=false):void
        {
            _model.placeItemToRoom(_arg_1, _arg_2);
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!_isInitialized)
            {
                init();
            };

            if (_view == null)
            {
                return (null);
            };

            if (_view.disposed)
            {
                return (null);
            };

            return (_view);
        }

        public function setSelectedGridItem(_arg_1:BotGridItem):void
        {
            if (!_isInitialized)
            {
                return;
            };

            if (_selectedGridItem != null)
            {
                _selectedGridItem.setSelected(false);
            };

            _selectedGridItem = _arg_1;

            if (_selectedGridItem != null)
            {
                _selectedGridItem.setSelected(true);
            };

            updatePreview(_arg_1);
        }

        public function updateState():void
        {
            var _local_1:int;

            if (!_isInitialized)
            {
                return;
            };

            var _local_2:Map = _model.items;

            if (!_model.isListInitialized())
            {
                _local_1 = 1;
            }

            else
            {
                if (((!(_local_2)) || (_local_2.length == 0)))
                {
                    _local_1 = 2;
                }

                else
                {
                    _local_1 = 3;
                };
            };

            if (_currentState == _local_1)
            {
                return;
            };

            _currentState = _local_1;
            updateContainerVisibility();

            if (_currentState == 3)
            {
                updateGrid();
                updatePreview();
            };
        }

        public function getGridItemImage(_arg_1:BotData):BitmapData
        {
            var _local_2:int = 3;
            return (getItemImage(_arg_1, _local_2, false, "h"));
        }

        public function getItemImage(_arg_1:BotData, _arg_2:int, _arg_3:Boolean, _arg_4:String):BitmapData
        {
            var _local_5:BitmapData;
            var _local_6:IAvatarImage = _avatarRenderer.createAvatarImage(_arg_1.figure, _arg_4, _arg_1.gender, this);
            _local_6.setDirection("full", _arg_2);

            if (_arg_3)
            {
                _local_5 = _local_6.getCroppedImage("full");
            }

            else
            {
                _local_5 = _local_6.getCroppedImage("head");
            };

            _local_6.dispose();
            return (_local_5);
        }

        public function avatarImageReady(_arg_1:String):void
        {
            if (disposed)
            {
                return;
            };

            for each (var _local_2:BotGridItem in _gridItems)
            {
                if (_local_2.data.figure == _arg_1)
                {
                    _local_2.setImage(getGridItemImage(_local_2.data));
                };
            };
        }

        private function selectFirst():void
        {
            if (((_gridItems == null) || (_gridItems.length == 0)))
            {
                updatePreview();
                return;
            };

            setSelectedGridItem(_gridItems.getWithIndex(0));
        }

        public function selectById(_arg_1:int):void
        {
            setSelectedGridItem(_gridItems.getValue(_arg_1));
        }

        private function updateGrid():void
        {
            var _local_4:int;
            var _local_3:BotGridItem;

            if (_view == null)
            {
                return;
            };

            var _local_1:Array = _gridItems.getKeys();
            var _local_2:Array = ((_model.items) ? _model.items.getKeys() : []);
            _grid.lock();

            for each (_local_4 in _local_1)
            {
                if (_local_2.indexOf(_local_4) == -1)
                {
                    removeItem(_local_4);
                };
            };

            for each (_local_4 in _local_2)
            {
                if (_local_1.indexOf(_local_4) == -1)
                {
                    addItem(_model.items.getValue(_local_4));
                };

                _local_3 = _gridItems.getValue(_local_4);
                _local_3.setUnseen(_model.isUnseen(_local_4));
            };

            _grid.unlock();
        }

        private function startPlacingHandler(_arg_1:WindowMouseEvent):void
        {
            if (_selectedGridItem == null)
            {
                return;
            };

            var _local_2:BotData = _selectedGridItem.data;

            if (_local_2 == null)
            {
                return;
            };

            placeItemToRoom(_local_2.id);
        }

        private function windowEventHandler(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
        }

        private function updateContainerVisibility():void
        {
            if (_model.controller.currentCategoryId != "bots")
            {
                return;
            };

            var _local_1:IWindowContainer = _model.controller.view.loadingContainer;
            var _local_3:IWindowContainer = _model.controller.view.emptyContainer;
            var _local_4:IWindow = _view.findChildByName("grid");
            var _local_2:IWindow = _view.findChildByName("preview_container");
            switch (_currentState)
            {
                case 1:

                    if (_local_1)
                    {
                        _local_1.visible = true;
                    };

                    if (_local_3)
                    {
                        _local_3.visible = false;
                    };

                    _local_4.visible = false;
                    _local_2.visible = false;
                    return;
                case 2:

                    if (_local_1)
                    {
                        _local_1.visible = false;
                    };

                    if (_local_3)
                    {
                        _local_3.visible = true;
                    };

                    _local_4.visible = false;
                    _local_2.visible = false;
                    return;
                case 3:

                    if (_local_1)
                    {
                        _local_1.visible = false;
                    };

                    if (_local_3)
                    {
                        _local_3.visible = false;
                    };

                    _local_4.visible = true;
                    _local_2.visible = true;
                default:
            };
        }

        private function updatePreview(_arg_1:BotGridItem=null):void
        {
            var _local_3:BitmapData;
            var _local_11:String;
            var _local_13:String;
            var _local_10:Boolean;
            var _local_4:BotData;
            var _local_5:BitmapData = null;

            if (_view == null)
            {
                return;
            };

            _previewImageDownloadId = -1;

            if (((_arg_1 == null) || (_arg_1.data == null)))
            {
                _local_3 = new BitmapData(1, 1);
                _local_11 = "";
                _local_13 = "";
                _local_10 = false;
            }

            else
            {
                _local_4 = _arg_1.data;
                _local_11 = _local_4.name;
                _local_13 = _local_4.motto;
                _local_3 = getItemImage(_local_4, 4, true, "h");
                _local_10 = true;
            };

            var _local_9:IBitmapWrapperWindow = (_view.findChildByName("preview_image") as IBitmapWrapperWindow);

            if (_local_9 != null)
            {
                _local_5 = new BitmapData(_local_9.width, _local_9.height);
                _local_5.fillRect(_local_5.rect, 0);
                _local_5.copyPixels(_local_3, _local_3.rect, new Point(((_local_5.width / 2) - (_local_3.width / 2)), ((_local_5.height / 2) - (_local_3.height / 2))));
                _local_9.bitmap = _local_5;
            };

            _local_3.dispose();

            var _local_6:ITextWindow = (_view.findChildByName("bot_name") as ITextWindow);

            if (_local_6 != null)
            {
                _local_6.caption = _local_11;
            };

            _local_6 = (_view.findChildByName("bot_description") as ITextWindow);

            if (_local_6 != null)
            {
                _local_6.caption = _local_13;
            };

            var _local_8:Boolean;
            var _local_12:Boolean;

            if (_model.roomSession != null)
            {
                _local_8 = _model.roomSession.areBotsAllowed;
                _local_12 = _model.roomSession.isRoomOwner;
            };

            var _local_2:String = "";

            if (!_local_12)
            {
                if (_local_8)
                {
                    _local_2 = "${inventory.bots.allowed}";
                }

                else
                {
                    _local_2 = "${inventory.bots.forbidden}";
                };
            };

            _local_6 = (_view.findChildByName("preview_info") as ITextWindow);

            if (_local_6 != null)
            {
                _local_6.caption = _local_2;
            };

            var _local_7:_SafeStr_101 = (_view.findChildByName("place_button") as _SafeStr_101);

            if (_local_7 != null)
            {
                if (((_local_10) && ((_local_12) || (_local_8))))
                {
                    _local_7.enable();
                }

                else
                {
                    _local_7.disable();
                };
            };
        }

        private function addUnseenItemSymbols():void
        {
        }

        private function init():void
        {
            var _local_1:_SafeStr_101;
            _view = _model.controller.view.getView("bots");
            _view.visible = false;
            _view.procedure = windowEventHandler;
            addUnseenItemSymbols();
            _grid = (_view.findChildByName("grid") as IItemGridWindow);
            _local_1 = (_view.findChildByName("place_button") as _SafeStr_101);

            if (_local_1 != null)
            {
                _local_1.addEventListener("WME_CLICK", startPlacingHandler);
            };

            var _local_2:IBitmapWrapperWindow = (_view.findChildByName("preview_image") as IBitmapWrapperWindow);

            if (_local_2 != null)
            {
                _local_2.addEventListener("WME_DOWN", startPlacingHandler);
            };

            updatePreview();
            updateState();
            selectFirst();
            _isInitialized = true;
        }

    }
}
