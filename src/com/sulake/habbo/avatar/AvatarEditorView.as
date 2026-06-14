package com.sulake.habbo.avatar
{
    import flash.geom.Point;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import com.sulake.habbo.avatar.common.IAvatarEditorGridView;
    import com.sulake.habbo.avatar.view.AvatarEditorNameChangeView;
    import com.sulake.core.assets.XmlAsset;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.IWindow;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.avatar.common.AvatarEditorGridView;
    import com.sulake.habbo.avatar.effects.AvatarEditorGridViewEffects;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IWidgetWindow;

    public class AvatarEditorView 
    {

        private static const SAVE_TIMEOUT_MS:int = 1500;
        private static const DEFAULT_LOCATION:Point = new Point(100, 30);

        public static var THUMB_WINDOW:IWindowContainer;
        public static var COLOUR_WINDOW:IWindowContainer;
        public static var TAB_BACKGROUND_COLOUR:int = 0x666666;

        private var _editor:HabboAvatarEditor;
        private var _editorContent:IWindowContainer;
        private var _currentViewId:String;
        private var _tabContainer:ITabContextWindow;
        private var _frameWindow:IFrameWindow;
        private var _windowContext:IWindowContainer;
        private var _saveTimer:Timer;
        private var _avatarDirection:int = 4;
        private var _currentSideContentType:String;
        private var _showWardrobeOnUpdate:Boolean = true;
        private var _availableCategories:Array = [];
        private var _allCategories:Array = ["generic", "head", "torso", "legs", "hotlooks", "wardrobe"];
        private var _categoryContainers:Dictionary;
        private var _gridView:IAvatarEditorGridView;
        private var _effectsGridView:IAvatarEditorGridView;
        private var _avatarEditorNameChangeView:AvatarEditorNameChangeView;

        public function AvatarEditorView(_arg_1:HabboAvatarEditor, _arg_2:Array)
        {
            _editor = _arg_1;
            _saveTimer = new Timer(1500, 1);
            _saveTimer.addEventListener("timer", onUpdate);

            if (_arg_1.manager.getBoolean("effects.in.avatar.editor"))
            {
                _allCategories.push("effects");
            };

            if (_arg_2 == null)
            {
                _arg_2 = _allCategories;
            };

            for each (var _local_3:String in _arg_2)
            {
                _availableCategories.push(_local_3);
            };

            createWindow();
        }

        public function dispose():void
        {
            var _local_3:IWindowContainer;
            var _local_2:IWindowContainer;
            var _local_1:IWindowContainer;

            if (_saveTimer != null)
            {
                _saveTimer.stop();
                _saveTimer.removeEventListener("timer", onUpdate);
                _saveTimer = null;
            };

            if (_tabContainer)
            {
                _tabContainer.dispose();
                _tabContainer = null;
            };

            if (_editorContent)
            {
                _editorContent.dispose();
                _editorContent = null;
            };

            if (_windowContext != null)
            {
                _windowContext.dispose();
                _windowContext = null;
            };

            if (_frameWindow)
            {
                _frameWindow.dispose();
                _frameWindow = null;
            };

            if (_editorContent != null)
            {
                _local_3 = (_editorContent.findChildByName("figureContainer") as IWindowContainer);

                if (_local_3 != null)
                {
                    while (_local_3.numChildren > 0)
                    {
                        _local_3.removeChildAt(0);
                    };
                };

                _local_2 = (_editorContent.findChildByName("contentArea") as IWindowContainer);

                if (_local_2 != null)
                {
                    while (_local_2.numChildren > 0)
                    {
                        _local_2.removeChildAt(0);
                    };
                };

                _local_1 = (_editorContent.findChildByName("sideContainer") as IWindowContainer);

                if (_local_1 != null)
                {
                    while (_local_1.numChildren > 0)
                    {
                        _local_1.removeChildAt(0);
                    };
                };

                _editor = null;
            };
        }

        public function getFrame(_arg_1:Array, _arg_2:String=null):IFrameWindow
        {
            if (_frameWindow)
            {
                _frameWindow.visible = true;
                _frameWindow.activate();
                return (_frameWindow);
            };

            if (_frameWindow)
            {
                _frameWindow.dispose();
                _frameWindow = null;
            };

            var _local_3:XmlAsset = (_editor.manager.assets.getAssetByName("AvatarEditorFrame") as XmlAsset);

            if (_local_3)
            {
                _frameWindow = (_editor.manager.windowManager.buildFromXML((_local_3.content as XML)) as IFrameWindow);
            };

            if (_frameWindow == null)
            {
                return (null);
            };

            var _local_4:IWindowContainer = (_frameWindow.findChildByName("maincontent") as IWindowContainer);

            if (!embedToContext(_local_4, _arg_1))
            {
                _frameWindow.dispose();
                _frameWindow = null;
                return (null);
            };

            if (((_arg_2) && (!(_frameWindow.header == null))))
            {
                _frameWindow.header.title.text = _arg_2;
            };

            _frameWindow.position = DEFAULT_LOCATION;
            _frameWindow.findChildByName("header_button_close").procedure = windowEventProc;
            return (_frameWindow);
        }

        public function embedToContext(_arg_1:IWindowContainer, _arg_2:Array):Boolean
        {
            var _local_3:int;

            if (!validateAvailableCategories(_arg_2))
            {
                return (false);
            };

            if (_arg_1)
            {
                _local_3 = _arg_1.getChildIndex(_editorContent);

                if (_local_3)
                {
                    _arg_1.removeChildAt(_local_3);
                };

                _arg_1.addChild(_editorContent);
            }

            else
            {
                if (_windowContext == null)
                {
                    _windowContext = (_editor.manager.windowManager.createWindow("avatarEditorContainer", "", 4, 3, (0x020000 | 0x01), new Rectangle(0, 0, 2, 2), null, 0) as IWindowContainer);
                    _windowContext.addChild(_editorContent);
                };

                _local_3 = _windowContext.getChildIndex(_editorContent);

                if (_local_3)
                {
                    _arg_1.removeChildAt(_local_3);
                };

                _windowContext.visible = true;
            };

            return (true);
        }

        public function validateAvailableCategories(_arg_1:Array):Boolean
        {
            if (_arg_1 == null)
            {
                return (validateAvailableCategories(_allCategories));
            };

            if (_arg_1.length != _availableCategories.length)
            {
                return (false);
            };

            for each (var _local_2:String in _arg_1)
            {
                if (_availableCategories.indexOf(_local_2) < 0)
                {
                    return (false);
                };
            };

            return (true);
        }

        private function onUpdate(_arg_1:Event=null):void
        {
            _saveTimer.stop();

            if (_editorContent)
            {
                _editorContent.findChildByName("save").enable();
            };
        }

        public function show():void
        {
            if (_frameWindow)
            {
                _frameWindow.visible = true;
            }

            else
            {
                if (_editorContent)
                {
                    _editorContent.visible = true;
                };
            };
        }

        public function hide():void
        {
            if (_frameWindow)
            {
                _frameWindow.visible = false;
            }

            else
            {
                if (_editorContent)
                {
                    _editorContent.visible = false;
                };
            };
        }

        private function createWindow():void
        {
            var _local_4:int;
            var _local_3:ITabButtonWindow;
            var _local_5:int;
            var _local_7:IWindow;

            if (_editorContent == null)
            {
                _editorContent = (_editor.manager.windowManager.buildFromXML(((_editor.manager.assets.getAssetByName("AvatarEditorContent") as XmlAsset).content as XML)) as IWindowContainer);
            };

            if (THUMB_WINDOW == null)
            {
                THUMB_WINDOW = (_editorContent.findChildByName("thumb_template") as IWindowContainer);

                if (THUMB_WINDOW)
                {
                    _editorContent.removeChild(THUMB_WINDOW);
                };
            };

            if (COLOUR_WINDOW == null)
            {
                COLOUR_WINDOW = (_editorContent.findChildByName("palette_template") as IWindowContainer);

                if (COLOUR_WINDOW)
                {
                    _editorContent.removeChild(COLOUR_WINDOW);
                };
            };

            if (((!(_editor.manager == null)) && (!(_editor.manager.sessionData == null))))
            {
                _editorContent.findChildByName("avatar_name").caption = _editor.manager.sessionData.userName;

                if (_editor.manager.getBoolean("premium.name.change.enabled"))
                {
                    _editorContent.findChildByName("avatar_name_change").visible = true;
                };
            };

            _editorContent.procedure = windowEventProc;
            _tabContainer = (_editorContent.findChildByName("mainTabs") as ITabContextWindow);

            var _local_1:Vector.<String> = new Vector.<String>(0);
            _local_4 = (_tabContainer.numTabItems - 1);

            while (_local_4 >= 0)
            {
                _local_3 = _tabContainer.getTabItemAt(_local_4);
                _local_1.push(_local_3.name);

                if (((!(_local_3 == null)) && (_availableCategories.indexOf(_local_3.name) < 0)))
                {
                    _tabContainer.removeTabItem(_local_3);
                    _local_5 = (_local_4 + 1);

                    while (_local_5 < _tabContainer.numTabItems)
                    {
                        _tabContainer.getTabItemAt(_local_5).x = (_tabContainer.getTabItemAt(_local_5).x - _local_3.width);
                        _local_5++;
                    };
                };

                _local_4--;
            };

            _categoryContainers = new Dictionary();

            var _local_2:IWindowContainer = (_editorContent.findChildByName("contentArea") as IWindowContainer);

            for each (var _local_6:String in _local_1)
            {
                _local_7 = _local_2.findChildByName((_local_6 + "_content"));

                if (_local_7)
                {
                    _categoryContainers[_local_6] = _local_2.removeChild(_local_7);
                };
            };

            _gridView = new AvatarEditorGridView((_editorContent.findChildByName("grid_container") as IWindowContainer));
            _effectsGridView = new AvatarEditorGridViewEffects((_editorContent.findChildByName("grid_container") as IWindowContainer));
            _tabContainer.selector.setSelected(_tabContainer.getTabItemAt(0));
            update();
        }

        public function update():void
        {
            var _local_1:IWindow = (_editorContent.findChildByName("wardrobeButtonContainer") as IWindow);

            if (((_local_1) && (_editor.manager.sessionData)))
            {
                _local_1.visible = ((_editor.manager.sessionData.hasClub) && (_editor.isSideContentEnabled()));
                _local_1.visible = _editor.isSideContentEnabled();
            };

            var _local_2:String = "nothing";

            if (((_currentSideContentType == "wardrobe") || (_showWardrobeOnUpdate)))
            {
                _local_2 = "wardrobe";
            };

            if (!_editor.isSideContentEnabled())
            {
                _local_2 = "nothing";
            };

            if (_editor.hasInvalidClubItems())
            {
                _editor.stripClubItems();
                _editor.disableClubClothing();
            };

            if (_editor.hasInvalidSellableItems())
            {
                _editor.stripInvalidSellableItems();
            };

            setSideContent(_local_2);
            setViewToCategory(_currentViewId);
        }

        public function toggleCategoryView(_arg_1:String, _arg_2:Boolean=false):void
        {
            if (_arg_2)
            {
            };

            setViewToCategory(_arg_1);
        }

        private function toggleWardrobe():void
        {
            if (_currentSideContentType == "wardrobe")
            {
                _showWardrobeOnUpdate = false;
                setSideContent("nothing");
            }

            else
            {
                setSideContent("wardrobe");
            };
        }

        private function setSideContent(_arg_1:String):void
        {
            var _local_5:int;

            if (_currentSideContentType == _arg_1)
            {
                return;
            };

            var _local_2:IWindowContainer = (_editorContent.findChildByName("sideContainer") as IWindowContainer);

            if (!_local_2)
            {
                return;
            };

            var _local_4:IWindow;
            switch (_arg_1)
            {
                case "nothing":
                    break;
                case "wardrobe":
                    _local_4 = _editor.getSideContentWindowContainer("wardrobe");
            };

            var _local_3:IWindow = _local_2.removeChildAt(0);

            if (_local_3)
            {
                _editorContent.width = (_editorContent.width - _local_3.width);
            };

            if (_local_4)
            {
                _local_2.addChild(_local_4);
                _local_4.visible = true;
                _local_2.width = _local_4.width;
            }

            else
            {
                _local_2.width = 0;
            };

            _currentSideContentType = _arg_1;

            if (_frameWindow)
            {
                _local_5 = 8;
                _frameWindow.content.width = (_editorContent.width + _local_5);
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

            var _local_2:IWindowContainer = (_editorContent.findChildByName("contentArea") as IWindowContainer);

            if (_local_2 == null)
            {
                return;
            };

            if (_arg_1 == "effects")
            {
                effectsParamViewContainer.visible = true;
            }

            else
            {
                effectsParamViewContainer.visible = false;
            };

            var _local_4:IWindow = _local_2.getChildAt(0);
            _local_2.removeChild(_local_4);
            _local_2.invalidate();

            var _local_3:IWindow = _editor.getCategoryWindowContainer(_arg_1);

            if (_local_3 == null)
            {
                return;
            };

            _gridView.window.visible = false;
            _local_3.visible = true;
            _local_2.addChild(_local_3);
            _editor.activateCategory(_arg_1);
            _currentViewId = _arg_1;
            _tabContainer.selector.setSelected(_tabContainer.getTabItemByName(_arg_1));
        }

        public function windowEventProc(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:String;

            if (_arg_1.type == "WE_SELECTED")
            {
                _local_3 = (_arg_2 as ITabContextWindow).selector.getSelected().name;

                if (_local_3 != _currentViewId)
                {
                    _editor.toggleAvatarEditorPage(_local_3);
                };
            }

            else
            {
                if (_arg_1.type == "WME_CLICK")
                {
                    switch (_arg_2.name)
                    {
                        case "save":

                            if (((!(_editor.isDevelopmentEditor())) && (_editor.hasInvalidSellableItems())))
                            {
                                startSellablePurchase();
                                _saveTimer.start();
                                _editorContent.findChildByName("save").disable();
                                return;
                            };

                            if (((!(_editor.isDevelopmentEditor())) && (_editor.hasInvalidClubItems())))
                            {
                                _editor.openHabboClubAdWindow();
                                _saveTimer.start();
                                _editorContent.findChildByName("save").disable();
                                return;
                            };

                            _saveTimer.start();
                            _editorContent.findChildByName("save").disable();
                            _editor.saveCurrentSelection();
                            _editor.manager.close(_editor.instanceId);
                            return;
                        case "cancel":
                        case "header_button_close":

                            if (_editor.hasInvalidClubItems())
                            {
                                _editor.stripClubItems();
                                _editor.disableClubClothing();
                            };

                            _editor.manager.close(_editor.instanceId);
                            return;
                        case "rotate_avatar":
                            _avatarDirection++;

                            if (_avatarDirection > 7)
                            {
                                _avatarDirection = 0;
                            };

                            _editor.figureData.direction = _avatarDirection;
                            return;
                        case "wardrobe":
                            toggleWardrobe();
                            return;
                        case "avatar_name_change":

                            if (_avatarEditorNameChangeView != null)
                            {
                                _avatarEditorNameChangeView.focus();
                            }

                            else
                            {
                                _avatarEditorNameChangeView = new AvatarEditorNameChangeView(this, (_editorContent.x + _editorContent.width), _editorContent.y);
                            };

                            return;
                    };
                };
            };
        }

        private function startSellablePurchase():void
        {
            if (_editor.manager.catalog)
            {
                _editor.manager.catalog.openCatalogPage(_editor.manager.getProperty("catalog.clothes.page"));
            };
        }

        public function get effectsParamViewContainer():IWindowContainer
        {
            return (IWindowContainer(_editorContent.findChildByName("effectParamsContainer")));
        }

        public function getCategoryContainer(_arg_1:String):IWindow
        {
            return (_categoryContainers[_arg_1]);
        }

        public function get gridView():IAvatarEditorGridView
        {
            return (_gridView);
        }

        public function getFigureContainer():IWidgetWindow
        {
            return (_editorContent.findChildByName("avatarWidget") as IWidgetWindow);
        }

        public function get effectsGridView():IAvatarEditorGridView
        {
            return (_effectsGridView);
        }

        public function get editor():HabboAvatarEditor
        {
            return (_editor);
        }

        public function get avatarEditorNameChangeView():AvatarEditorNameChangeView
        {
            return (_avatarEditorNameChangeView);
        }

    }
}
