package com.sulake.habbo.ui.widget.roomchat
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IScrollableWindow;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.MouseEvent;

    public class RoomChatHistoryViewer implements IDisposable 
    {

        private static const CHAT_ITEM_HEIGHT:int = 18;
        private static const SCROLLBAR_WIDTH:int = 20;
        public static const MOUSE_HYSTERESIS_TOLERANCE:int = 3;

        private var _historyPulldown:RoomChatHistoryPulldown;
        private var _active:Boolean = false;
        private var _historyViewerDragStartY:Number = -1;
        private var _scrollbarWindow:IScrollbarWindow;
        private var _scrollTarget:Number = 1;
        private var _disabled:Boolean = false;
        private var _widget:RoomChatWidget;
        private var _disposed:Boolean = false;
        private var _forcedResize:Boolean = false;
        private var _hysteresisBlockOn:Boolean = false;

        public function RoomChatHistoryViewer(_arg_1:RoomChatWidget, _arg_2:IHabboWindowManager, _arg_3:IWindowContainer, _arg_4:IAssetLibrary)
        {
            _disposed = false;
            _widget = _arg_1;
            _historyPulldown = new RoomChatHistoryPulldown(_arg_1, _arg_2, _arg_3, _arg_4);
            _historyPulldown.state = 0;

            var _local_5:IItemListWindow = (_arg_3.getChildByName("chat_contentlist") as IItemListWindow);

            if (_local_5 == null)
            {
                return;
            };

            _arg_3.removeChild(_local_5);
            _arg_3.addChild(_local_5);
            _scrollbarWindow = (_arg_2.createWindow("chatscroller", "", 131, 0, (0x10 | 0x00), new Rectangle((_arg_3.right - 20), _arg_3.y, 20, (_arg_3.height - 39)), null, 0) as IScrollbarWindow);
            _arg_3.addChild(_scrollbarWindow);
            _scrollbarWindow.visible = false;
            _scrollbarWindow.scrollable = (_local_5 as IScrollableWindow);
        }

        public function set disabled(_arg_1:Boolean):void
        {
            _disabled = _arg_1;
        }

        public function set visible(_arg_1:Boolean):void
        {
            if (((_historyPulldown == null) || (_disabled)))
            {
                return;
            };

            _historyPulldown.state = ((_arg_1) ? 1 : 0);
        }

        public function get active():Boolean
        {
            return (_active);
        }

        public function get scrollbarWidth():Number
        {
            return ((_active) ? 20 : 0);
        }

        public function get pulldownBarHeight():Number
        {
            return (39);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get visible():Boolean
        {
            if (_historyPulldown == null)
            {
                return (false);
            };

            return ((_historyPulldown.state == 1) || (_historyPulldown.state == 2));
        }

        public function dispose():void
        {
            hideHistoryViewer();

            if (_scrollbarWindow != null)
            {
                _scrollbarWindow.dispose();
                _scrollbarWindow = null;
            };

            if (_historyPulldown != null)
            {
                _historyPulldown.dispose();
                _historyPulldown = null;
            };

            _disposed = true;
        }

        public function update(_arg_1:uint):void
        {
            if (_historyPulldown != null)
            {
                _historyPulldown.update(_arg_1);
            };

            moveHistoryScroll();
        }

        public function toggleHistoryViewer():void
        {
            if (_active)
            {
                hideHistoryViewer();
            }

            else
            {
                showHistoryViewer();
            };
        }

        public function hideHistoryViewer():void
        {
            _scrollTarget = 1;
            cancelDrag();
            _active = false;
            setHistoryViewerScrollbar(false);
            _historyPulldown.state = 0;

            if (_widget != null)
            {
                _widget.resetArea();
                _widget.enableDragTooltips();
                _widget.handler.container.toolbar.extensionView.extraMargin = 0;
            };
        }

        public function showHistoryViewer():void
        {
            var _local_3:int;

            if (((!(_active)) && (!(_disabled))))
            {
                _active = true;
                setHistoryViewerScrollbar(true);
                _historyPulldown.state = 1;

                if (_widget != null)
                {
                    _widget.reAlignItemsToHistoryContent();
                    _widget.disableDragTooltips();
                };
            };
        }

        private function setHistoryViewerScrollbar(_arg_1:Boolean):void
        {
            if (_scrollbarWindow != null)
            {
                _scrollbarWindow.visible = _arg_1;

                if (_arg_1)
                {
                    _scrollbarWindow.scrollV = 1;
                    _scrollTarget = 1;
                }

                else
                {
                    _active = false;
                    _historyViewerDragStartY = -1;
                };
            };
        }

        public function containerResized(_arg_1:Rectangle, _arg_2:Boolean=false):void
        {
            if (_scrollbarWindow != null)
            {
                _scrollbarWindow.x = ((_arg_1.x + _arg_1.width) - _scrollbarWindow.width);
                _scrollbarWindow.y = _arg_1.y;
                _scrollbarWindow.height = (_arg_1.height - 39);

                if (_arg_2)
                {
                    _scrollbarWindow.scrollV = _scrollTarget;
                };
            };

            if (_historyPulldown != null)
            {
                _historyPulldown.containerResized(_arg_1);
            };
        }

        private function processDrag(_arg_1:Number, _arg_2:Boolean=false):void
        {
            var _local_8:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_3:int;
            var _local_6:Boolean;
            var _local_7:Boolean;

            if (((_historyViewerDragStartY > 0) && (_arg_2)))
            {
                if (_hysteresisBlockOn)
                {
                    if (Math.abs((_arg_1 - _historyViewerDragStartY)) > 3)
                    {
                        _hysteresisBlockOn = false;
                    }

                    else
                    {
                        return;
                    };
                };

                if (!_active)
                {
                    _widget.resizeContainerToLowestItem();
                    showHistoryViewer();
                    moveHistoryScroll();
                };

                if (_active)
                {
                    _widget.handler.container.toolbar.extensionView.extraMargin = 20;
                    moveHistoryScroll();
                    _local_4 = (_scrollbarWindow.scrollable.scrollableRegion.height / _scrollbarWindow.scrollable.visibleRegion.height);
                    _local_5 = ((_arg_1 - _historyViewerDragStartY) / _scrollbarWindow.height);
                    _local_8 = (_scrollTarget - (_local_5 / _local_4));
                    _local_8 = Math.max(0, _local_8);
                    _local_8 = Math.min(1, _local_8);
                    _local_3 = (_arg_1 - _historyViewerDragStartY);
                    _local_6 = true;
                    _local_7 = true;

                    if (_scrollbarWindow.scrollV < (1 - (18 / _scrollbarWindow.scrollable.scrollableRegion.height)))
                    {
                        _local_7 = false;
                    };

                    if (((_local_7) || (_forcedResize)))
                    {
                        _widget.stretchAreaBottomBy(_local_3);
                        _local_6 = false;
                        _scrollTarget = 1;
                        _scrollbarWindow.scrollV = 1;
                    };

                    if (_local_6)
                    {
                        _scrollTarget = _local_8;
                    };

                    _historyViewerDragStartY = _arg_1;
                };
            }

            else
            {
                _historyViewerDragStartY = -1;
            };
        }

        public function beginDrag(_arg_1:Number, _arg_2:Boolean=false):void
        {
            var _local_3:DisplayObject;
            var _local_4:Stage;

            if (_disabled)
            {
                return;
            };

            _historyViewerDragStartY = _arg_1;
            _forcedResize = _arg_2;
            _hysteresisBlockOn = true;

            if (_scrollbarWindow != null)
            {
                _scrollTarget = _scrollbarWindow.scrollV;
            };

            if (_scrollbarWindow != null)
            {
                _local_3 = _scrollbarWindow.context.getDesktopWindow().getDisplayObject();

                if (_local_3 != null)
                {
                    _local_4 = _local_3.stage;

                    if (_local_4 != null)
                    {
                        _local_4.addEventListener("mouseMove", onStageMouseMove);
                        _local_4.addEventListener("mouseUp", onStageMouseUp);
                    };
                };
            };
        }

        public function cancelDrag():void
        {
            var _local_1:DisplayObject;
            var _local_2:Stage;
            _historyViewerDragStartY = -1;

            if (_scrollbarWindow != null)
            {
                _local_1 = _scrollbarWindow.context.getDesktopWindow().getDisplayObject();

                if (_local_1 != null)
                {
                    _local_2 = _local_1.stage;

                    if (_local_2 != null)
                    {
                        _local_2.removeEventListener("mouseMove", onStageMouseMove);
                        _local_2.removeEventListener("mouseUp", onStageMouseUp);
                    };
                };
            };
        }

        private function moveHistoryScroll():void
        {
            if (!_active)
            {
                return;
            };

            if (_historyViewerDragStartY < 0)
            {
                return;
            };

            if (_forcedResize)
            {
                return;
            };

            var _local_1:Number = (_scrollTarget - _scrollbarWindow.scrollV);

            if (_local_1 == 0)
            {
                return;
            };

            if (Math.abs(_local_1) < 0.01)
            {
                _scrollbarWindow.scrollV = _scrollTarget;
            }

            else
            {
                _scrollbarWindow.scrollV = (_scrollbarWindow.scrollV + (_local_1 / 2));
            };
        }

        private function onStageMouseUp(_arg_1:MouseEvent):void
        {
            cancelDrag();

            if (_widget != null)
            {
                _widget.mouseUp();
            };
        }

        private function onStageMouseMove(_arg_1:MouseEvent):void
        {
            processDrag(_arg_1.stageY, _arg_1.buttonDown);
        }

    }
}
