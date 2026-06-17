package onBoardingHcUi
{
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.text.TextField;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;

    public class Button extends LocalizedSprite
    {

        private static const button_png:Class = HabboButton_button_png;
        private static const button_pressed_png:Class = HabboButton_button_pressed_png;
        private static const button_inactive_png:Class = HabboButton_button_inactive_png;

        private var _label:String;
        private var _localizedText:String;
        protected var _rectangle:Rectangle;
        private var _fitWidthToText:Boolean;
        private var _centred:Boolean;
        private var _action:Function;
        private var _glowColour:uint;
        private var _background:Sprite;
        private var _defaultBackground:DisplayObject;
        private var _editingBackground:DisplayObject;
        private var _pressedBackground:DisplayObject;
        private var _inactiveBackground:DisplayObject;
        private var _rolloverBackground:DisplayObject;
        private var _captionElement:TextField;
        private var _pressed:Boolean;
        private var _hover:Boolean;
        private var _active:Boolean;
        private var _selected:Boolean;
        private var _currentlyEditing:Boolean;
        private var _alignRight:Boolean;
        private var _icon:Bitmap;

        public function Button(labelText:String, bounds:Rectangle, fitWidthToText:Boolean, onClick:Function, glowColour:uint = 0xFFFFFF)
        {
            removeOldLocalization(_label);
            _label = labelText;
            _localizedText = labelText;
            checkLocalization(_label);
            _rectangle = bounds;
            _fitWidthToText = fitWidthToText;
            _action = onClick;
            _glowColour = glowColour;
            _icon = icon;
            active = true;
            mouseChildren = false;
            addEventListener("addedToStage", onAddedToStage);
            addEventListener("removedFromStage", onRemovedFromStage);
        }

        private function onRemovedFromStage(_:Event):void
        {
            stage.removeEventListener("mouseUp", onStageMouseUp);
            removeEventListener("mouseDown", onMouseDown);
            removeEventListener("mouseUp", onMouseUp);
            removeEventListener("mouseOver", onMouseOver);
            removeEventListener("mouseOut", onMouseOut);
        }

        protected function onAddedToStage(_:Event = null):void
        {
            x = _rectangle.x;
            y = _rectangle.y;

            if (_label != "")
            {
                _captionElement = LoaderUI.createTextField(_localizedText, 18, textColour, true, false, false, italic, "left", false, underline);

                if (etching)
                {
                    LoaderUI.addEtching(_captionElement);
                };

                if (_fitWidthToText)
                {
                    _rectangle.width = (_captionElement.textWidth + padding);
                };
            };

            _defaultBackground = defaultBackground;
            _defaultBackground.width = _rectangle.width;
            _defaultBackground.height = _rectangle.height;
            _editingBackground = currentlyActive;
            _editingBackground.width = _rectangle.width;
            _editingBackground.height = _rectangle.height;
            _pressedBackground = pressedBackground;
            _pressedBackground.width = _rectangle.width;
            _pressedBackground.height = _rectangle.height;
            _inactiveBackground = inactiveBackground;
            _inactiveBackground.width = _rectangle.width;
            _inactiveBackground.height = _rectangle.height;
            _rolloverBackground = rolloverBackground;

            if (_rolloverBackground != null)
            {
                _rolloverBackground.width = _rectangle.width;
                _rolloverBackground.height = _rectangle.height;
            };

            while (numChildren > 0)
            {
                removeChildAt(0);
            };

            _background = new Sprite();
            _background.addChild(_defaultBackground);
            _background.addChild(_pressedBackground);
            _background.addChild(_inactiveBackground);
            _background.addChild(_editingBackground);

            if (_rolloverBackground != null)
            {
                _background.addChild(_rolloverBackground);
            };

            addChild(_background);

            if (_label != "")
            {
                addChild(_captionElement);
                _captionElement.x = (((_rectangle.width - _captionElement.textWidth) / 2) - 2);
                _captionElement.y = (((_rectangle.height - _captionElement.textHeight) / 2) - 2);
            };

            if (icon != null)
            {
                _background.addChild(icon);
                icon.x = 10;
                _icon.y = ((_background.height - icon.height) / 2);
            };

            refresh();
            width = _rectangle.width;
            height = _rectangle.height;

            if (centred)
            {
                x = int(((parent.width - width) / 2));
            };

            if (_alignRight)
            {
                x = (parent.width - width);
            };

            addEventListener("mouseDown", onMouseDown);
            addEventListener("mouseOver", onMouseOver);
            addEventListener("mouseOut", onMouseOut);
        }

        private function onMouseOut(_:MouseEvent):void
        {
            _hover = false;
            refresh();
        }

        private function onMouseOver(_:MouseEvent):void
        {
            if (!_active)
            {
                return;
            };

            _hover = true;
            refresh();
        }

        private function onMouseDown(_:MouseEvent):void
        {
            if (!_active)
            {
                return;
            };

            stage.addEventListener("mouseUp", onStageMouseUp);
            addEventListener("mouseUp", onMouseUp);
            _pressed = true;
            refresh();
        }

        private function onMouseUp(clickEvent:MouseEvent):void
        {
            clickEvent.stopImmediatePropagation();
            stage.removeEventListener("mouseUp", onStageMouseUp);
            removeEventListener("mouseUp", onMouseUp);
            _pressed = false;
            refresh();
            if (_action != null)
            {
                _action(this);
            }
        }

        private function onStageMouseUp(_:MouseEvent):void
        {
            stage.removeEventListener("mouseUp", onStageMouseUp);
            removeEventListener("mouseUp", onMouseUp);
            _pressed = false;
            refresh();
        }

        private function refresh():void
        {
            var normalState:int = 1;
            var pressedState:int = 2;
            var inactiveState:int = 3;
            var editingState:int = 4;
            var resolvedState:int = normalState;

            if (_background == null)
            {
                return;
            };

            resolvedState = ((_active) ? ((((_pressed) && (_hover)) || (_selected)) ? pressedState : normalState) : inactiveState);

            if (_currentlyEditing)
            {
                resolvedState = editingState;
            };

            _defaultBackground.visible = ((resolvedState == normalState) && ((_rolloverBackground == null) || (!(_hover))));
            _pressedBackground.visible = (resolvedState == pressedState);
            _inactiveBackground.visible = (resolvedState == inactiveState);
            _editingBackground.visible = (resolvedState == editingState);

            if (_rolloverBackground != null)
            {
                _rolloverBackground.visible = ((resolvedState == normalState) && (_hover));
                filters = [];
            }

            else
            {
                filters = ((_hover) ? [new GlowFilter(_glowColour, 0.7, 10, 10)] : []);
            };

            if (_captionElement)
            {
                _captionElement.textColor = ((_active) ? textColour : 0x999999);
            };
        }

        public function get centred():Boolean
        {
            return (_centred);
        }

        public function set centred(isCentred:Boolean):void
        {
            _centred = isCentred;
        }

        override public function set x(xPos:Number):void
        {
            super.x = xPos;
            _rectangle.x = xPos;
        }

        override public function set y(yPos:Number):void
        {
            super.y = yPos;
            _rectangle.y = yPos;
        }

        public function get active():Boolean
        {
            return (_active);
        }

        public function set active(isEnabled:Boolean):void
        {
            _active = isEnabled;
            buttonMode = _active;
            refresh();
        }

        public function unselect():void
        {
            _currentlyEditing = false;
            _selected = false;
            refresh();
        }

        public function currentlyEditing():void
        {
            _currentlyEditing = true;
            refresh();
        }

        public function select():void
        {
            _selected = true;
            refresh();
        }

        public function set alignRight(shouldAlignRight:Boolean):void
        {
            _alignRight = shouldAlignRight;
        }

        protected function get defaultBackground():DisplayObject
        {
            return (LoaderUI.createScale9GridShapeFromImage(Bitmap(new button_png()).bitmapData, new Rectangle(5, 5, 1, 2)));
        }

        protected function get pressedBackground():DisplayObject
        {
            return (LoaderUI.createScale9GridShapeFromImage(Bitmap(new button_pressed_png()).bitmapData, new Rectangle(6, 10, 1, 3)));
        }

        protected function get inactiveBackground():DisplayObject
        {
            return (LoaderUI.createScale9GridShapeFromImage(Bitmap(new button_inactive_png()).bitmapData, new Rectangle(5, 6, 1, 2)));
        }

        protected function get currentlyActive():DisplayObject
        {
            return (LoaderUI.createScale9GridShapeFromImage(Bitmap(new button_png()).bitmapData, new Rectangle(5, 6, 1, 2)));
        }

        protected function get rolloverBackground():DisplayObject
        {
            return (null);
        }

        protected function get icon():Bitmap
        {
            return (_icon);
        }

        protected function get etching():Boolean
        {
            return (true);
        }

        protected function get padding():int
        {
            return (24);
        }

        protected function get textColour():uint
        {
            return (0);
        }

        protected function get italic():Boolean
        {
            return (false);
        }

        protected function get underline():Boolean
        {
            return (false);
        }

        public function get label():String
        {
            return (_label);
        }

        public function get localizedText():String
        {
            return (_localizedText);
        }

        public function set localizedText(value:String):void
        {
            _localizedText = value;

            if (_captionElement)
            {
                _captionElement.text = value;
                onAddedToStage();
            };
        }

    }
}
