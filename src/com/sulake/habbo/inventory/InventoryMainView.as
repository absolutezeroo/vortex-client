package com.sulake.habbo.inventory
{
    import flash.geom.Point;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import flash.utils.Dictionary;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.utils.WindowToggle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;

    public class InventoryMainView 
    {

        private static const COUNTER_MARGIN:int = 3;

        private const DEFAULT_VIEW_LOCATION:Point = new Point(120, 150);

        private var _windowManager:IHabboWindowManager;
        private var _assetLibrary:IAssetLibrary;
        private var _mainWindow:IFrameWindow;
        private var _lastViewId:String;
        private var _lastView:IWindowContainer;
        private var _lastSubViewId:String;
        private var _lastSubView:IWindowContainer;
        private var _controller:HabboInventory;
        private var _toolbar:IHabboToolbar;
        private var _unseenFurniCounter:IWindowContainer;
        private var _unseenRentedFurniCounter:IWindowContainer;
        private var _unseenBadgeCounter:IWindowContainer;
        private var _unseenPetsCounter:IWindowContainer;
        private var _unseenBotCounter:IWindowContainer;
        private var _inventoryViews:Dictionary;

        public function InventoryMainView(_arg_1:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            _controller = _arg_1;
            _assetLibrary = _arg_3;
            _windowManager = _arg_2;
        }

        public function get isVisible():Boolean
        {
            return ((_mainWindow) ? _mainWindow.visible : false);
        }

        public function get isActive():Boolean
        {
            return ((_mainWindow) ? _mainWindow.getStateFlag(1) : false);
        }

        public function get emptyContainer():IWindowContainer
        {
            if (!_mainWindow)
            {
                return (null);
            };

            return (_mainWindow.findChildByName("empty_container") as IWindowContainer);
        }

        public function get loadingContainer():IWindowContainer
        {
            if (!_mainWindow)
            {
                return (null);
            };

            return (_mainWindow.findChildByName("loading_container") as IWindowContainer);
        }

        public function get mainContainer():IWindowContainer
        {
            if (!_mainWindow)
            {
                return (null);
            };

            return (_mainWindow.findChildByName("contentArea") as IWindowContainer);
        }

        public function dispose():void
        {
            _unseenFurniCounter = null;
            _unseenRentedFurniCounter = null;
            _unseenBotCounter = null;
            _unseenPetsCounter = null;
            _unseenBadgeCounter = null;
            _controller = null;
            _lastView = null;
            _lastSubView = null;

            if (_mainWindow)
            {
                _mainWindow.dispose();
                _mainWindow = null;
            };

            if (_toolbar)
            {
                if (_toolbar.events)
                {
                    _toolbar.events.removeEventListener("HTE_TOOLBAR_CLICK", onHabboToolbarEvent);
                };

                _toolbar = null;
            };

            _windowManager = null;
            _assetLibrary = null;
        }

        private function getWindow():IFrameWindow
        {
            var _local_4:IAsset;
            var _local_1:XmlAsset;
            var _local_2:ITabContextWindow;
            var _local_3:Array;
            var _local_5:ITabButtonWindow;

            if (!_mainWindow)
            {
                _local_4 = _assetLibrary.getAssetByName("inventory_xml");
                _local_1 = XmlAsset(_local_4);
                _inventoryViews = new Dictionary();
                _mainWindow = (_windowManager.buildFromXML(XML(_local_1.content)) as IFrameWindow);

                if (_mainWindow != null)
                {
                    _mainWindow.position = DEFAULT_VIEW_LOCATION;
                    _mainWindow.visible = false;
                    _mainWindow.procedure = windowEventProc;
                    _mainWindow.setParamFlag(0x10000, _controller.getBoolean("inventory.allow.scaling"));
                    extractWindow("furni");
                    extractWindow("pets");
                    extractWindow("bots");
                    extractWindow("badges");
                    _local_2 = (_mainWindow.findChildByName("tabs") as ITabContextWindow);
                    _local_3 = [];

                    while (_local_2.numTabItems > 0)
                    {
                        _local_5 = _local_2.getTabItemAt(0);
                        _local_3.push(_local_5);
                        _local_2.removeTabItem(_local_5);
                    };

                    for each (_local_5 in _local_3)
                    {
                        switch (_local_5.name)
                        {
                            case "bots":

                                if (_controller.getBoolean("inventory.bots.enabled"))
                                {
                                    _local_2.addTabItem(_local_5);
                                };

                                break;
                            case "rentables":

                                if (_controller.getBoolean("duckets.enabled"))
                                {
                                    _local_2.addTabItem(_local_5);
                                };

                                break;
                            default:
                                _local_2.addTabItem(_local_5);
                        };
                    };

                    _controller.preparingInventoryView();
                };

                _controller.updateUnseenItemCounts();
            };

            if (_mainWindow.y < 0)
            {
                _mainWindow.y = 0;
            };

            if (_mainWindow.x < 0)
            {
                _mainWindow.x = 0;
            };

            return (_mainWindow);
        }

        public function getCategoryViewId():String
        {
            return (_lastViewId);
        }

        public function getSubCategoryViewId():String
        {
            return (_lastSubViewId);
        }

        public function hideInventory():void
        {
            _controller.closingInventoryView();

            var _local_1:IWindow = getWindow();

            if (_local_1 == null)
            {
                return;
            };

            _local_1.visible = false;
        }

        public function showInventory():void
        {
            var _local_1:IWindow = getWindow();

            if (_local_1 == null)
            {
                return;
            };

            _local_1.visible = true;
            _controller.inventoryViewOpened((((_lastSubViewId) && (_lastSubViewId.length > 0)) ? _lastSubViewId : _lastViewId));
        }

        public function toggleCategoryView(_arg_1:String, _arg_2:Boolean=true, _arg_3:Boolean=false):Boolean
        {
            var _local_4:IWindow = getWindow();

            if (_local_4 == null)
            {
                return (false);
            };

            if (_local_4.visible)
            {
                if (_lastViewId == _arg_1)
                {
                    if (_arg_2)
                    {
                        if (WindowToggle.isHiddenByOtherWindows(_local_4))
                        {
                            _local_4.activate();
                        }

                        else
                        {
                            hideInventory();
                            return (false);
                        };
                    };
                }

                else
                {
                    setViewToCategory(_arg_1);
                };
            }

            else
            {
                if ((((_arg_3) && (!(_lastViewId == null))) && (!(_lastViewId == _arg_1))))
                {
                    setViewToCategory(_arg_1);
                };

                _local_4.visible = true;
                _local_4.activate();

                if (((!(_arg_1 == _lastViewId)) || (!(_controller.isInventoryCategoryInit(_arg_1)))))
                {
                    setViewToCategory(_arg_1);
                };

                _controller.inventoryViewOpened(_arg_1);
            };

            return (true);
        }

        public function toggleSubCategoryView(_arg_1:String, _arg_2:Boolean=true):void
        {
            var _local_3:IWindow = getWindow();

            if (_local_3 == null)
            {
                return;
            };

            if (_local_3.visible)
            {
                if (_lastSubViewId == _arg_1)
                {
                    if (_arg_2)
                    {
                        _local_3.visible = false;
                    };
                }

                else
                {
                    setSubViewToCategory(_arg_1);
                };
            }

            else
            {
                _local_3.visible = true;

                if (_arg_1 != _lastSubViewId)
                {
                    setSubViewToCategory(_arg_1);
                };
            };
        }

        public function updateSubCategoryView():void
        {
            if (_lastSubViewId == null)
            {
                return;
            };

            setSubViewToCategory(_lastSubViewId);
        }

        public function setToolbar(_arg_1:IHabboToolbar):void
        {
            _toolbar = _arg_1;
            _toolbar.events.addEventListener("HTE_TOOLBAR_CLICK", onHabboToolbarEvent);
        }

        public function windowEventProc(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:String;

            if (_arg_1.type == "WE_SELECTED")
            {
                _local_3 = ITabContextWindow(_arg_2).selector.getSelected().name;

                if (_local_3 != _lastViewId)
                {
                    resetUnseenCounters(_lastViewId);
                    _controller.toggleInventoryPage(_local_3);
                };
            }

            else
            {
                if (_arg_1.type == "WME_CLICK")
                {
                    if (_arg_2.name == "header_button_close")
                    {
                        hideInventory();
                    };

                    if (_arg_2.name == "open_catalog_btn")
                    {
                        _controller.catalog.openCatalog();
                    };
                }

                else
                {
                    if (_arg_1.type == "WME_DOUBLE_CLICK")
                    {
                        if (_arg_2.name == "titlebar")
                        {
                            _mainWindow.height = _mainWindow.limits.minHeight;
                        };
                    };
                };
            };
        }

        public function updateUnseenFurniCount(_arg_1:int):void
        {
            if (!_mainWindow)
            {
                return;
            };

            if (!_unseenFurniCounter)
            {
                _unseenFurniCounter = createCounter("furni");
            };

            updateCounter(_unseenFurniCounter, _arg_1);
            _controller.furniModel.updateView();
        }

        public function updateUnseenRentedFurniCount(_arg_1:int):void
        {
            if (!_mainWindow)
            {
                return;
            };

            if (!_unseenRentedFurniCounter)
            {
                _unseenRentedFurniCounter = createCounter("rentables");
            };

            updateCounter(_unseenRentedFurniCounter, _arg_1);
            _controller.furniModel.updateView();
        }

        public function updateUnseenPetsCount(_arg_1:int):void
        {
            if (!_mainWindow)
            {
                return;
            };

            if (!_unseenPetsCounter)
            {
                _unseenPetsCounter = createCounter("pets");
            };

            updateCounter(_unseenPetsCounter, _arg_1);
            _controller.petsModel.updateView();
        }

        public function updateUnseenBadgeCount(_arg_1:int):void
        {
            if (!_mainWindow)
            {
                return;
            };

            if (!_unseenBadgeCounter)
            {
                _unseenBadgeCounter = createCounter("badges");
            };

            updateCounter(_unseenBadgeCounter, _arg_1);
            _controller.badgesModel.updateView();
        }

        public function updateUnseenBotCount(_arg_1:int):void
        {
            if (!_mainWindow)
            {
                return;
            };

            if (!_unseenBotCounter)
            {
                _unseenBotCounter = createCounter("bots");
            };

            updateCounter(_unseenBotCounter, _arg_1);
            _controller.botsModel.updateView();
        }

        public function getView(_arg_1:String):IWindowContainer
        {
            return (_inventoryViews[_arg_1] as IWindowContainer);
        }

        private function extractWindow(_arg_1:String):void
        {
            var _local_2:IWindow = mainContainer.getChildByName(_arg_1);

            if (_local_2)
            {
                _inventoryViews[_arg_1] = mainContainer.removeChild(_local_2);
            };
        }

        private function resetUnseenCounters(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case "furni":
                    _controller.furniModel.resetUnseenItems();
                    return;
                case "rentables":
                    _controller.furniModel.resetUnseenItems();
                    return;
                case "pets":
                    _controller.petsModel.resetUnseenItems();
                    return;
                case "badges":
                    _controller.badgesModel.resetUnseenItems();
                    return;
                case "bots":
                    _controller.botsModel.resetUnseenItems();
                    return;
            };
        }

        private function setViewToCategory(_arg_1:String):void
        {
            if (_arg_1 == null)
            {
                return;
            };

            if (_arg_1 == "")
            {
                return;
            };

            if (emptyContainer)
            {
                emptyContainer.visible = false;
            };

            if (loadingContainer)
            {
                loadingContainer.visible = false;
            };

            _controller.checkCategoryInitilization(_arg_1);

            if (mainContainer == null)
            {
                return;
            };

            mainContainer.removeChild(_lastView);
            mainContainer.invalidate();

            var _local_2:IWindowContainer = _controller.getCategoryWindowContainer(_arg_1);

            if (_local_2 == null)
            {
                return;
            };

            _local_2.visible = true;
            mainContainer.addChild(_local_2);
            _local_2.height = mainContainer.height;
            _controller.updateView(_arg_1);
            _lastView = _local_2;
            _lastViewId = _arg_1;

            var _local_3:ITabContextWindow = (_mainWindow.findChildByName("tabs") as ITabContextWindow);

            if (_local_3 == null)
            {
                return;
            };

            _local_3.selector.setSelected(_local_3.selector.getSelectableByName(_arg_1));
        }

        private function enableScaling():void
        {
            _mainWindow.height = _mainWindow.limits.minHeight;
            _mainWindow.setParamFlag(0x10000, true);
            _mainWindow.findChildByName("top_content").setParamFlag(0x0800, true);
        }

        private function disableScaling():void
        {
            _mainWindow.height = _mainWindow.limits.minHeight;
            _mainWindow.setParamFlag(0x10000, false);
            _mainWindow.findChildByName("top_content").setParamFlag(0x0800, false);
        }

        private function setSubViewToCategory(_arg_1:String):void
        {
            if (((_arg_1 == null) || (_arg_1 == "")))
            {
                return;
            };

            _controller.checkCategoryInitilization(_arg_1);

            var _local_2:IWindowContainer = (_mainWindow.findChildByName("subContentArea") as IWindowContainer);

            while (_local_2.numChildren > 0)
            {
                _local_2.removeChildAt(0);
            };

            var _local_3:IWindowContainer = _controller.getCategorySubWindowContainer(_arg_1);

            if (_local_3 != null)
            {
                disableScaling();
                _local_2.visible = true;
                _local_3.visible = true;
                _local_2.height = _local_3.height;
                _local_2.addChild(_local_3);
            }

            else
            {
                enableScaling();
                _local_2.visible = false;
                _local_2.height = 0;
            };

            _local_2.y = (_mainWindow.findChildByName("top_content").rectangle.bottom + 5);
            _mainWindow.resizeToFitContent();

            if (_mainWindow.parent != null)
            {
                if ((_mainWindow.x + _mainWindow.width) > _mainWindow.parent.width)
                {
                    _mainWindow.x = (_mainWindow.parent.width - _mainWindow.width);
                };

                if ((_mainWindow.y + _mainWindow.height) > _mainWindow.parent.height)
                {
                    _mainWindow.y = ((_mainWindow.parent.height - _mainWindow.height) * 0.5);
                };

                if (_mainWindow.y < 0)
                {
                    _mainWindow.y = 0;
                };
            };

            _lastSubView = _local_3;
            _lastSubViewId = _arg_1;
        }

        private function createCounter(_arg_1:String):IWindowContainer
        {
            var _local_3:IWindowContainer = _windowManager.createUnseenItemCounter();
            var _local_2:IWindowContainer = (_mainWindow.findChildByName(_arg_1) as IWindowContainer);

            if (_local_2)
            {
                _local_2.addChild(_local_3);
                _local_3.x = ((_local_2.width - _local_3.width) - 3);
                _local_3.y = 3;
            };

            return (_local_3);
        }

        private function updateCounter(_arg_1:IWindowContainer, _arg_2:int):void
        {
            var _local_5:ILabelWindow;
            _arg_1.findChildByName("count").caption = _arg_2.toString();
            _arg_1.visible = (_arg_2 > 0);

            var _local_3:String = "";
            switch (_arg_1)
            {
                case _unseenBotCounter:
                    _local_3 = "bots";
                    break;
                case _unseenPetsCounter:
                    _local_3 = "pets";
                    break;
                case _unseenBadgeCounter:
                    _local_3 = "badges";
                    break;
                case _unseenFurniCounter:
                    _local_3 = "furni";
                    break;
                case _unseenRentedFurniCounter:
                    _local_3 = "rentables";
            };

            var _local_4:IWindowContainer = (_mainWindow.findChildByName(_local_3) as IWindowContainer);

            if (_local_4)
            {
                _local_5 = (_local_4.getChildByTag("TITLE") as ILabelWindow);

                if (_local_5)
                {
                    if (_arg_1.visible)
                    {
                        _local_5.margins.right = (_arg_1.width + (2 * 3));
                    }

                    else
                    {
                        _local_5.margins.right = _local_5.margins.left;
                    };

                    _local_4.width = _local_5.width;
                    _arg_1.x = ((_local_4.width - _arg_1.width) - 3);
                };
            };
        }

        public function onHabboToolbarEvent(_arg_1:HabboToolbarEvent):void
        {
            if (_arg_1.iconId != "HTIE_ICON_INVENTORY")
            {
                return;
            };

            if (_arg_1.type == "HTE_TOOLBAR_CLICK")
            {
                if (_lastViewId == "pets")
                {
                    toggleCategoryView("pets");
                }

                else
                {
                    if (_lastViewId == "furni")
                    {
                        toggleCategoryView("furni");
                    }

                    else
                    {
                        if (_lastViewId == "rentables")
                        {
                            toggleCategoryView("rentables");
                        }

                        else
                        {
                            if (_lastViewId == "badges")
                            {
                                toggleCategoryView("badges");
                            }

                            else
                            {
                                if (_lastViewId == "bots")
                                {
                                    toggleCategoryView("bots");
                                }

                                else
                                {
                                    if (_controller != null)
                                    {
                                        _controller.toggleInventoryPage("furni");
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

    }
}
