package com.sulake.habbo.freeflowchat.viewer.visualization
{
    import flash.display.Sprite;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.TextField;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.IChatStyleInternal;
    import com.sulake.habbo.freeflowchat.viewer.enum.ChatBubbleWidth;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.events.TextEvent;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class PooledChatBubble extends Sprite 
    {

        public static const MAX_WIDTH_DEFAULT:uint = 300;

        private const DESKTOP_MARGIN_LEFT:int = 85;
        private const DESKTOP_MARGIN_RIGHT:int = 190;
        private const LINEAR_INTERPOLATION_MS:uint = 150;
        private const MAX_HEIGHT:uint = 108;
        private const _SafeStr_2203:int = 28;
        private const POINTER_MARGIN_RIGHT:int = 15;
        private const POINTER_REPOSITION_INTERVAL_MS:int = 2000;

        private var _component:HabboFreeFlowChat;
        private var _chatItem:ChatItem;
        private var _background:Sprite;
        private var _pointer:Bitmap;
        private var _face:Bitmap;
        private var _faceBitmapData:BitmapData;
        private var _textField:TextField;
        private var _style:IChatStyleInternal;
        private var _timeMs:uint = 0;
        private var _moveBeginMs:uint;
        private var _moveTargetX:int;
        private var _moveTargetY:int;
        private var _moveOriginX:int;
        private var _moveOriginY:int;
        private var _moveDeltaXPerMs:Number;
        private var _moveDeltaYPerMs:Number;
        private var _readyToRecycle:Boolean = false;
        private var _roomPanOffsetX:int = 0;
        private var _proxyX:int;
        private var _useDesktopMargins:Boolean = false;
        private var _hasHitDesktopMargin:Boolean = false;
        private var _clipMask:Sprite;
        private var _timePointerPositionUpdateMs:uint = 0;
        private var _minHeight:int = -1;

        public function PooledChatBubble(_arg_1:HabboFreeFlowChat)
        {
            _component = _arg_1;
            _pointer = new Bitmap();
            _face = new Bitmap();
            _textField = new TextField();
            _clipMask = new Sprite();
            this.addEventListener("addedToStage", onAddedToStage);
            this.addEventListener("removedFromStage", onRemovedFromStage);
        }

        public function set chatItem(_arg_1:ChatItem):void
        {
            _chatItem = _arg_1;
        }

        public function set face(_arg_1:BitmapData):void
        {
            _faceBitmapData = _arg_1;
        }

        public function set style(_arg_1:IChatStyleInternal):void
        {
            _style = _arg_1;
        }

        public function recreate(_arg_1:String, _arg_2:uint, _arg_3:Boolean=false, _arg_4:int=-1):void
        {
            var _local_10:int;
            var _local_14:int;
            var _local_16:Array;
            var _local_15:String;
            var _local_19:String;
            var _local_20:String;
            var _local_8:int;
            var _local_12:BitmapData;
            _background = _style.getNewBackgroundSprite(_arg_2);
            _pointer.bitmapData = _style.pointer;
            _useDesktopMargins = _arg_3;

            var _local_11:int = ((_component.roomChatSettings) ? ChatBubbleWidth.accordingToRoomChatSetting(_component.roomChatSettings.bubbleWidth) : 300);
            var _local_9:int = ((_local_11 - _style.textFieldMargins.x) - _style.textFieldMargins.width);
            _textField.width = _local_9;
            _textField.multiline = true;
            _textField.wordWrap = true;
            _textField.selectable = false;
            _textField.thickness = -15;
            _textField.sharpness = 80;
            _textField.antiAliasType = "advanced";
            _textField.embedFonts = true;
            _textField.gridFitType = "pixel";
            _textField.cacheAsBitmap = (!(_style.allowHTML));
            _textField.styleSheet = null;
            _textField.defaultTextFormat = _style.textFormat;
            _textField.styleSheet = _style.styleSheet;
            _textField.addEventListener("link", onTextLinkEvent);

            var _local_7:Boolean = (_chatItem.chatType == 0);
            var _local_6:Boolean = (_chatItem.chatType == 2);
            var _local_13:Boolean = (((!(_local_7)) && (!(_local_6))) && (!(_style.isAnonymous)));

            if (_local_13)
            {
                _textField.alpha = 0.6;
            }

            else
            {
                _textField.alpha = 1;
            };

            var _local_18:String = (((_local_13) ? "<i>" : "") + ((_style.isAnonymous) ? "" : (("<b>" + _arg_1) + ": </b>")));
            _local_18 = (((_local_18 + ((_local_6) ? "<b>" : "")) + _chatItem.text) + ((_local_6) ? "</b>" : ""));
            _local_18 = (_local_18 + ((_local_13) ? "</i>" : ""));

            if (((_chatItem.links == null) || (_chatItem.links[0] == null)))
            {
                _textField.htmlText = _local_18;
            }

            else
            {
                _local_14 = -1;
                _local_16 = [];
                _local_10 = 0;

                while (_local_10 < _chatItem.links.length)
                {
                    _local_15 = _chatItem.links[_local_10][0][1];
                    _local_19 = (((('<a href="' + _local_15) + '">') + _local_15) + "</a>");
                    _local_20 = (("{" + _local_10) + "}");
                    _local_8 = _chatItem.text.indexOf(_local_20);
                    _local_14 = (_local_8 + _local_19.length);
                    _local_16.push([_local_8, _local_14]);
                    _local_18 = _local_18.replace(_local_20, _local_19);
                    _local_10++;
                };

                _textField.htmlText = _local_18;
            };

            _minHeight = _arg_4;

            var _local_17:int = Math.min(_local_11, ((_textField.textWidth + _style.textFieldMargins.x) + _style.textFieldMargins.width));
            var _local_5:int = ((_textField.textHeight + _style.textFieldMargins.y) + _style.textFieldMargins.height);

            if (!_style.isSystemStyle)
            {
                _local_5 = Math.min(108, _local_5);
            };

            if (_arg_4 != -1)
            {
                _local_5 = Math.max(_arg_4, _local_5);
            };

            _local_17 = Math.max(_local_17, _background.width);
            _local_5 = Math.max(_local_5, _background.height);
            _background.width = _local_17;
            _background.height = _local_5;
            _background.x = 0;
            _background.y = 0;
            _background.cacheAsBitmap = true;
            addChild(_background);

            if (!_style.isAnonymous)
            {
                _pointer.x = Math.max(28, Math.min(15, userRelativePosX));
                _pointer.y = (_local_5 - _style.pointerOffsetToBubbleBottom);
                addChild(_pointer);
            };

            if (((!(_faceBitmapData == null)) && (!(_style.faceOffset == null))))
            {
                if (_faceBitmapData.height > _local_5)
                {
                    _local_12 = new BitmapData(_faceBitmapData.width, _local_5);
                    _local_12.copyPixels(_faceBitmapData, new Rectangle(0, (_faceBitmapData.height - _local_5), _faceBitmapData.width, _local_5), new Point(0, 0));
                }

                else
                {
                    _local_12 = _faceBitmapData;
                };

                _face.bitmapData = _local_12;
                _face.x = (_style.faceOffset.x - (_local_12.width / 2));
                _face.y = Math.max(1, (_style.faceOffset.y - (_local_12.height / 2)));
                addChild(_face);
            };

            _textField.width = Math.min(_local_9, (_textField.textWidth + _style.textFieldMargins.width));
            _textField.height = (_textField.textHeight + _style.textFieldMargins.height);
            _textField.x = _style.textFieldMargins.x;
            _textField.y = _style.textFieldMargins.y;
            addChild(_textField);

            if (((!(_style.isSystemStyle)) && (_textField.textHeight > 108)))
            {
                _clipMask.graphics.clear();
                _clipMask.graphics.beginFill(0xFFFFFF);
                _clipMask.graphics.drawRect(0, 0, (_textField.textWidth + 5), (108 - _style.textFieldMargins.height));
                _clipMask.graphics.endFill();
                _textField.mask = _clipMask;
                addChild(_clipMask);
                _clipMask.x = _textField.x;
                _clipMask.y = _textField.y;
            }

            else
            {
                _clipMask.graphics.clear();
                _textField.mask = null;
            };

            this.cacheAsBitmap = (!(_style.allowHTML));
            _readyToRecycle = false;
            _timeMs = 0;
            _timePointerPositionUpdateMs = 0;
            visible = false;
        }

        public function unregister():void
        {
            this.cacheAsBitmap = false;
            this.removeEventListener("click", onMouseClick);

            if (_clipMask.parent == this)
            {
                safelyRemoveChild(_clipMask);
            };

            safelyRemoveChild(_textField);

            if (((!(_style.faceOffset == null)) && (_face.parent == this)))
            {
                safelyRemoveChild(_face);
                _face.bitmapData = null;
            };

            if (((_pointer) && (_pointer.parent)))
            {
                safelyRemoveChild(_pointer);
            };

            safelyRemoveChild(_background);

            if (_textField)
            {
                _textField.removeEventListener("link", onTextLinkEvent);
            };
        }

        private function onTextLinkEvent(_arg_1:TextEvent):void
        {
            var _local_7:String;
            var _local_4:String;
            var _local_3:TextField;
            var _local_2:Point;
            var _local_5:Rectangle;
            var _local_6:String;

            if (((_arg_1.text) && (_arg_1.text.length > 0)))
            {
                _local_7 = _arg_1.text;
                _local_4 = "highlight/";

                if (_local_7.indexOf(_local_4) > -1)
                {
                    _local_3 = (_arg_1.target as TextField);
                    _local_2 = new Point(_local_3.mouseX, _local_3.mouseY);
                    _local_2 = _local_3.localToGlobal(_local_2);
                    _local_5 = new Rectangle(_local_2.x, _local_2.y);
                    _local_6 = _local_7.substr((_local_7.indexOf(_local_4) + _local_4.length), _local_7.length);
                    _component.windowManager.hideHint();
                    _component.windowManager.showHint(_local_6.toLocaleUpperCase(), _local_5);
                }

                else
                {
                    _component.context.createLinkEvent(_arg_1.text);
                };
            };
        }

        private function safelyRemoveChild(_arg_1:DisplayObject):void
        {
            try
            {
                removeChild(_arg_1);
            }

            catch(error:ArgumentError)
            {
            };
        }

        public function get displayedHeight():Number
        {
            return ((_style.isSystemStyle) ? height : Math.min(108, height));
        }

        private function onAddedToStage(_arg_1:Event):void
        {
            this.addEventListener("click", onMouseClick);
        }

        private function onRemovedFromStage(_arg_1:Event):void
        {
            this.removeEventListener("click", onMouseClick);
        }

        public function moveTo(_arg_1:int, _arg_2:int):void
        {
            if (((!(_moveTargetX == _arg_1)) || (!(_moveTargetY == _arg_2))))
            {
                _moveBeginMs = _timeMs;
                _moveOriginX = proxyX;
                _moveOriginY = y;
                _moveTargetX = _arg_1;
                _moveTargetY = _arg_2;
                _moveDeltaXPerMs = ((_arg_1 - proxyX) / 150);
                _moveDeltaYPerMs = ((_arg_2 - y) / 150);
            };
        }

        public function warpTo(_arg_1:int, _arg_2:int):void
        {
            _moveTargetX = _arg_1;
            _moveTargetY = _arg_2;
            proxyX = _arg_1;
            y = _arg_2;
        }

        public function update(_arg_1:uint):void
        {
            var _local_2:uint;
            _timeMs = (_timeMs + _arg_1);

            if (((!(proxyX == _moveTargetX)) || (!(y == _moveTargetY))))
            {
                _local_2 = (_timeMs - _moveBeginMs);

                if (((_local_2 < 150) && (_local_2 > 0)))
                {
                    proxyX = (_moveOriginX + (_local_2 * _moveDeltaXPerMs));
                    y = (_moveOriginY + (_local_2 * _moveDeltaYPerMs));
                }

                else
                {
                    proxyX = _moveTargetX;
                    y = _moveTargetY;
                };
            };

            if (_timeMs > (_timePointerPositionUpdateMs + 2000))
            {
                repositionPointer();
                _timePointerPositionUpdateMs = _timeMs;
            };

            if (((_timeMs > 150) && (!(visible))))
            {
                visible = true;
            };
        }

        public function get proxyX():int
        {
            return (_proxyX);
        }

        public function set proxyX(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            _proxyX = _arg_1;

            if (((_useDesktopMargins) && (stage)))
            {
                _local_2 = (_proxyX + _roomPanOffsetX);
                _hasHitDesktopMargin = false;
                _local_3 = ((stage.stageWidth - 190) - width);

                if (_local_2 > _local_3)
                {
                    _local_2 = _local_3;
                    _hasHitDesktopMargin = true;
                };

                if (_local_2 < 85)
                {
                    _local_2 = 85;
                    _hasHitDesktopMargin = true;
                };

                x = _local_2;
            }

            else
            {
                x = (_proxyX + _roomPanOffsetX);
            };
        }

        public function repositionPointer():void
        {
            if (((_pointer) && (_pointer.parent)))
            {
                _pointer.x = Math.max(28, Math.min((_background.width - 15), userRelativePosX));
                _pointer.y = (_background.height - _style.pointerOffsetToBubbleBottom);
            };
        }

        public function get readyToRecycle():Boolean
        {
            return (_readyToRecycle);
        }

        public function set readyToRecycle(_arg_1:Boolean):void
        {
            _readyToRecycle = _arg_1;

            if (_arg_1)
            {
                this.removeEventListener("click", onMouseClick);
            };
        }

        public function get timeStamp():uint
        {
            return (_chatItem.timeStamp);
        }

        public function set component(_arg_1:HabboFreeFlowChat):void
        {
            _component = _arg_1;
        }

        private function get userRelativePosX():int
        {
            return (userScreenPos.x - this.x);
        }

        public function get userScreenPos():Point
        {
            if (_chatItem.forcedScreenLocation)
            {
                return (new Point(((_component.displayObject.stage.stageWidth / 2) + _chatItem.forcedScreenLocation), 500));
            };

            return (_component.getScreenPointFromRoomLocation(_chatItem.roomId, _chatItem.userLocation));
        }

        public function get roomId():int
        {
            return (_chatItem.roomId);
        }

        public function set roomPanOffsetX(_arg_1:int):void
        {
            if (_roomPanOffsetX != _arg_1)
            {
                _roomPanOffsetX = _arg_1;
                warpTo(_moveTargetX, _moveTargetY);
            };
        }

        private function onMouseClick(_arg_1:MouseEvent):void
        {
            if (((_style) && (_style.isAnonymous)))
            {
                return;
            };

            if (!_component.clickHasToPropagate(_arg_1))
            {
                _component.selectAvatarWithChatItem(_chatItem);
                _arg_1.stopImmediatePropagation();
            };
        }

        public function get overlap():Rectangle
        {
            return (_style.overlap);
        }

        public function get hasHitDesktopMargin():Boolean
        {
            return (_hasHitDesktopMargin);
        }

        public function get minHeight():int
        {
            return (_minHeight);
        }

    }
}
