package com.sulake.habbo.ui.widget.roomchat
{
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import com.sulake.habbo.ui.widget.events.RoomWidgetChatUpdateEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class RoomChatItem 
    {

        public static const CHAT_ITEM_STACKING_HEIGHT:Number = 18;
        private static const MESSAGE_TEXT_MARGIN_LEFT:int = 6;
        private static const MESSAGE_TEXT_MARGIN_RIGHT:int = 6;
        private static const RESPECT_ICON_MARGIN_RIGHT:int = 35;
        private static const _SafeStr_4251:int = 26;
        private static const NAME:String = "name";
        private static const MESSAGE:String = "message";
        private static const POINTER:String = "pointer";
        private static const BACKGROUND:String = "background";
        private static const TOOLTIP_DRAG_FOR_HISTORY:String = "${chat.history.drag.tooltip}";

        private var _widget:RoomChatWidget;
        private var _windowManager:IHabboWindowManager;
        private var _localizations:IHabboLocalizationManager;
        private var _view:IRegionWindow;
        private var _assetLibrary:IAssetLibrary;
        private var _id:String;
        private var _siteUrl:String;
        private var _aboveLevels:int = 0;
        private var _screenLevel:int = -1;
        private var _chatType:int;
        private var _chatStyle:int;
        private var _senderId:int;
        private var _senderName:String = new String();
        private var _message:String = new String();
        private var _messageLinks:Array;
        private var _messageLinkPositions:Array;
        private var _timeStamp:int;
        private var _senderX:Number;
        private var _senderImage:BitmapData;
        private var _senderColor:uint;
        private var _roomId:int;
        private var _userType:int;
        private var _petType:int;
        private var _senderCategory:int;
        private var _width:Number = 0;
        private var _rendered:Boolean = false;
        private var _topOffset:Number = 0;
        private var _originalBackgroundYOffset:Number = 0;
        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _dragTooltipEnabled:Boolean = false;

        public function RoomChatItem(_arg_1:RoomChatWidget, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:String, _arg_5:IHabboLocalizationManager, _arg_6:String)
        {
            _widget = _arg_1;
            _windowManager = _arg_2;
            _assetLibrary = _arg_3;
            _id = _arg_4;
            _localizations = _arg_5;
            _siteUrl = _arg_6;
        }

        public function dispose():void
        {
            if (_view != null)
            {
                _view.dispose();
                _view = null;
                _widget = null;
                _windowManager = null;
                _localizations = null;
                _senderImage = null;
            };
        }

        public function define(_arg_1:RoomWidgetChatUpdateEvent):void
        {
            _chatType = _arg_1.chatType;
            _chatStyle = _arg_1.styleId;
            _senderId = _arg_1.userId;
            _senderName = _arg_1.userName;
            _senderCategory = _arg_1.userCategory;
            _message = _arg_1.text;
            _messageLinks = _arg_1.links;
            _senderX = _arg_1.userX;
            _senderImage = _arg_1.userImage;
            _senderColor = _arg_1.userColor;
            _roomId = _arg_1.roomId;
            _userType = _arg_1.userType;
            _petType = _arg_1.petType;
            renderView();
        }

        public function set message(_arg_1:String):void
        {
            _message = _arg_1;
        }

        public function set senderName(_arg_1:String):void
        {
            _senderName = _arg_1;
        }

        public function set senderImage(_arg_1:BitmapData):void
        {
            _senderImage = _arg_1;
        }

        public function set senderColor(_arg_1:uint):void
        {
            _senderColor = _arg_1;
        }

        public function set chatType(_arg_1:int):void
        {
            _chatType = _arg_1;
        }

        public function get view():IWindowContainer
        {
            return (_view);
        }

        public function get screenLevel():int
        {
            return (_screenLevel);
        }

        public function get timeStamp():int
        {
            return (_timeStamp);
        }

        public function get senderX():Number
        {
            return (_senderX);
        }

        public function set senderX(_arg_1:Number):void
        {
            _senderX = _arg_1;
        }

        public function get width():Number
        {
            return (_width);
        }

        public function get height():Number
        {
            return (18);
        }

        public function get message():String
        {
            return (_message);
        }

        public function get x():Number
        {
            return (_x);
        }

        public function get y():Number
        {
            return (_y);
        }

        public function get aboveLevels():int
        {
            return (_aboveLevels);
        }

        public function set aboveLevels(_arg_1:int):void
        {
            _aboveLevels = _arg_1;
        }

        public function set screenLevel(_arg_1:int):void
        {
            _screenLevel = _arg_1;
        }

        public function set timeStamp(_arg_1:int):void
        {
            _timeStamp = _arg_1;
        }

        public function set x(_arg_1:Number):void
        {
            _x = _arg_1;

            if (_view != null)
            {
                _view.x = _arg_1;
            };
        }

        public function set y(_arg_1:Number):void
        {
            _y = _arg_1;

            if (_view != null)
            {
                _view.y = ((_arg_1 - _topOffset) + _originalBackgroundYOffset);
            };
        }

        public function hidePointer():void
        {
            var _local_1:IWindow;

            if (_view)
            {
                _local_1 = _view.findChildByName("pointer");

                if (_local_1)
                {
                    _local_1.visible = false;
                };
            };
        }

        public function setPointerOffset(_arg_1:Number):void
        {
            if (((!(_view)) || (_view.disposed)))
            {
                return;
            };

            var _local_3:IBitmapWrapperWindow = (_view.findChildByName("pointer") as IBitmapWrapperWindow);
            var _local_2:IBitmapWrapperWindow = (_view.findChildByName("middle") as IBitmapWrapperWindow);

            if (((_local_2 == null) || (_local_3 == null)))
            {
                return;
            };

            _local_3.visible = true;
            _arg_1 = (_arg_1 + (_view.width / 2));
            _arg_1 = Math.min(_arg_1, (_local_2.rectangle.right - _local_3.width));
            _arg_1 = Math.max(_arg_1, _local_2.rectangle.left);
            _local_3.x = _arg_1;
        }

        public function checkOverlap(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Boolean
        {
            var _local_6:Rectangle = new Rectangle(_x, _y, width, _arg_1);
            var _local_7:Rectangle = new Rectangle(_arg_2, _arg_3, _arg_4, _arg_5);
            return (_local_6.intersects(_local_7));
        }

        public function hideView():void
        {
            if (_view)
            {
                _view.dispose();
            };

            _view = null;
            _rendered = false;
        }

        private function get isNotify():Boolean
        {
            return (_chatStyle == 1);
        }

        public function renderView():void
        {
            var _local_15:IBitmapWrapperWindow;
            var _local_14:int;
            var _local_12:int;
            var _local_16:int;
            var _local_4:int;
            var _local_7:int;
            var _local_17:String;
            var _local_18:String;
            var _local_2:int;
            var _local_20:TextFormat;
            var _local_10:Array;

            if (_rendered)
            {
                return;
            };

            _rendered = true;

            if (_view)
            {
                return;
            };

            _view = RoomChatWidget.chatBubbleFactory.getBubbleWindow(_chatStyle, _chatType);

            if (!_view)
            {
                return;
            };

            _view.toolTipIsDynamic = true;

            var _local_9:IBitmapWrapperWindow = (_view.findChildByName("background") as IBitmapWrapperWindow);
            var _local_13:ILabelWindow = (_view.findChildByName("name") as ILabelWindow);
            var _local_5:ITextWindow = (_view.findChildByName("message") as ITextWindow);
            var _local_3:IBitmapWrapperWindow = (_view.findChildByName("pointer") as IBitmapWrapperWindow);
            var _local_1:Number = _view.height;
            var _local_19:BitmapData = RoomChatWidget.chatBubbleFactory.getPointerBitmapData(_chatStyle);
            _originalBackgroundYOffset = _local_9.y;

            var _local_8:int = ((_local_5.x <= 26) ? 0 : (_local_5.x - 26));

            if (_senderImage != null)
            {
                _topOffset = Math.max(0, ((_senderImage.height - _local_9.height) / 2));
                _local_1 = Math.max(_local_1, _senderImage.height);
                _local_1 = Math.max(_local_1, _local_9.height);
            };

            _width = 0;
            _view.x = _x;
            _view.y = _y;
            _view.width = 0;
            _view.height = _local_1;
            enableDragTooltip();
            addEventListeners(_view);

            if (((_senderImage) && (!(isNotify))))
            {
                _local_15 = (_view.findChildByName("user_image") as IBitmapWrapperWindow);

                if (_local_15)
                {
                    _local_15.width = _senderImage.width;
                    _local_15.height = _senderImage.height;
                    _local_15.bitmap = _senderImage;
                    _local_15.disposesBitmap = false;
                    _local_14 = int((_local_15.x - (_senderImage.width / 2)));
                    _local_12 = int(Math.max(0, ((_local_9.height - _senderImage.height) / 2)));

                    if (_userType == 2)
                    {
                        if (_petType == 15)
                        {
                            if (_senderImage.height > _local_9.height)
                            {
                                _local_12 = int(((_senderImage.height - _local_9.height) / 2));
                            };
                        };
                    };

                    _local_15.x = _local_14;
                    _local_15.y = (_local_15.y + _local_12);
                    _width = (_width + (_local_15.x + _senderImage.width));
                };
            };

            if (_local_13 != null)
            {
                if (!isNotify)
                {
                    _local_13.text = (_senderName + ": ");
                    _local_13.y = (_local_13.y + _topOffset);
                    _local_13.width = (_local_13.textWidth + 6);
                }

                else
                {
                    _local_13.text = "";
                    _local_13.width = 0;
                };

                _width = (_width + _local_13.width);
            };

            if (_chatType == 3)
            {
                _local_5.text = _localizations.registerParameter("widgets.chatbubble.respect", "username", _senderName);
                _width = 35;
            }

            else
            {
                if (_chatType == 4)
                {
                    _local_5.text = _localizations.registerParameter("widget.chatbubble.petrespect", "petname", _senderName);
                    _width = 35;
                }

                else
                {
                    if (_chatType == 6)
                    {
                        _local_5.text = _localizations.registerParameter("widget.chatbubble.pettreat", "petname", _senderName);
                        _width = 35;
                    }

                    else
                    {
                        if (_chatType == 7)
                        {
                            _local_5.text = message;
                            _width = 35;
                        }

                        else
                        {
                            if (_chatType == 8)
                            {
                                _local_5.text = message;
                                _width = 35;
                            }

                            else
                            {
                                if (_chatType == 9)
                                {
                                    _local_5.text = message;
                                    _width = 35;
                                }

                                else
                                {
                                    if (_chatType == 5)
                                    {
                                        _local_5.text = message;
                                        _width = 35;
                                    }

                                    else
                                    {
                                        if (_messageLinks == null)
                                        {
                                            _local_5.text = message;
                                        }

                                        else
                                        {
                                            _messageLinkPositions = [];
                                            _local_7 = -1;
                                            _local_4 = 0;

                                            while (_local_4 < _messageLinks.length)
                                            {
                                                _local_17 = _messageLinks[_local_4][1];
                                                _local_18 = (("{" + _local_4) + "}");
                                                _local_2 = _message.indexOf(_local_18);
                                                _local_7 = (_local_2 + _local_17.length);
                                                _messageLinkPositions.push([_local_2, _local_7]);
                                                _message = _message.replace(_local_18, _local_17);
                                                _local_4++;
                                            };

                                            _local_5.text = message;
                                            _local_5.immediateClickMode = true;
                                            _local_5.setParamFlag(16, false);
                                            _local_5.setParamFlag(0x40000000, true);
                                            _local_20 = _local_5.getTextFormat();
                                            switch (_chatStyle)
                                            {
                                                case 2:
                                                    _local_20.color = 0xDDDDDD;
                                                    break;
                                                default:
                                                    _local_20.color = 2710438;
                                            };

                                            _local_20.underline = true;
                                            _local_4 = 0;

                                            while (_local_4 < _messageLinkPositions.length)
                                            {
                                                _local_10 = _messageLinkPositions[_local_4];
                                                try
                                                {
                                                    _local_5.setTextFormat(_local_20, _local_10[0], _local_10[1]);
                                                }

                                                catch(e:RangeError)
                                                {
                                                    Logger.log("Chat message links were malformed. Could not set TextFormat");
                                                };

                                                _local_4++;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };

            if (_local_5.visible)
            {
                _local_5.x = (_width + _local_8);

                if (_local_13 != null)
                {
                    _local_5.x = (_local_13.x + _local_13.width);

                    if (_local_13.width > 6)
                    {
                        _local_5.x = (_local_5.x - (6 - 1));
                    };
                };

                _local_5.y = (_local_5.y + _topOffset);
                _local_16 = _local_5.textWidth;
                _local_5.width = (_local_16 + 6);
                _width = (_width + _local_5.width);
            };

            if (((!(_local_3 == null)) && (_local_3.visible)))
            {
                _local_3.bitmap = _local_19;
                _local_3.disposesBitmap = false;
                _local_3.x = (_width / 2);
                _local_3.y = (_local_3.y + _topOffset);
            };

            var _local_6:int = _local_5.width;

            if (_local_13)
            {
                _local_6 = (_local_6 + _local_13.width);
            };

            var _local_11:BitmapData = RoomChatWidget.chatBubbleFactory.buildBubbleImage(_chatStyle, _chatType, _local_6, _local_9.height, _senderColor);
            _view.width = _local_11.width;
            _view.y = (_view.y - _topOffset);
            _view.y = (_view.y + _originalBackgroundYOffset);
            _width = _view.width;
            _local_9.bitmap = _local_11;
            _local_9.y = _topOffset;
        }

        public function enableDragTooltip():void
        {
            _dragTooltipEnabled = true;
            refreshTooltip();
        }

        public function disableDragTooltip():void
        {
            _dragTooltipEnabled = false;
            refreshTooltip();
        }

        private function refreshTooltip():void
        {
            if (_view == null)
            {
                return;
            };

            _view.toolTipCaption = "";

            if (_widget.isGameSession)
            {
                return;
            };

            if (_dragTooltipEnabled)
            {
                _view.toolTipCaption = "${chat.history.drag.tooltip}";
            };

            _view.toolTipDelay = 500;
        }

        private function addEventListeners(_arg_1:IWindowContainer):void
        {
            _arg_1.setParamFlag(1, true);
            _arg_1.addEventListener("WME_CLICK", onBubbleMouseClick);
            _arg_1.addEventListener("WME_DOWN", onBubbleMouseDown);
            _arg_1.addEventListener("WME_OVER", onBubbleMouseOver);
            _arg_1.addEventListener("WME_OUT", onBubbleMouseOut);
            _arg_1.addEventListener("WME_UP", onBubbleMouseUp);
        }

        private function testMessageLinkMouseClick(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int;
            var _local_4:ITextWindow = (_view.getChildByName("message") as ITextWindow);
            var _local_5:int = _local_4.getCharIndexAtPoint((_arg_1 - _local_4.x), (_arg_2 - _local_4.y));

            if (_local_5 > -1)
            {
                _local_3 = 0;

                while (_local_3 < _messageLinkPositions.length)
                {
                    if (((_local_5 >= _messageLinkPositions[_local_3][0]) && (_local_5 <= _messageLinkPositions[_local_3][1])))
                    {
                        if (_messageLinks[_local_3][2] == 0)
                        {
                            HabboWebTools.openExternalLinkWarning(_messageLinks[_local_3][0]);
                        }

                        else
                        {
                            if (_messageLinks[_local_3][2] == 1)
                            {
                                HabboWebTools.openWebPage((_siteUrl + _messageLinks[_local_3][0]), "habboMain");
                            }

                            else
                            {
                                HabboWebTools.openWebPage((_siteUrl + _messageLinks[_local_3][0]));
                            };
                        };

                        return (true);
                    };

                    _local_3++;
                };
            };

            return (false);
        }

        private function onBubbleMouseClick(_arg_1:WindowMouseEvent):void
        {
            if (((_messageLinks) && (_messageLinks.length > 0)))
            {
                if (testMessageLinkMouseClick(_arg_1.localX, _arg_1.localY))
                {
                    return;
                };
            };

            _widget.onItemMouseClick(_senderId, _senderName, _senderCategory, _roomId, _arg_1);
        }

        private function onBubbleMouseDown(_arg_1:WindowMouseEvent):void
        {
            _widget.onItemMouseDown(_senderId, _senderCategory, _roomId, _arg_1);
        }

        private function onBubbleMouseOver(_arg_1:WindowMouseEvent):void
        {
            _widget.onItemMouseOver(_senderId, _senderCategory, _roomId, _arg_1);
        }

        private function onBubbleMouseOut(_arg_1:WindowMouseEvent):void
        {
            _widget.onItemMouseOut(_senderId, _senderCategory, _roomId, _arg_1);
        }

        private function onBubbleMouseUp(_arg_1:WindowMouseEvent):void
        {
            _widget.mouseUp();
        }

        public function get chatStyle():int
        {
            return (_chatStyle);
        }

        public function get originalBackgroundYOffset():Number
        {
            return (_originalBackgroundYOffset);
        }

    }
}
