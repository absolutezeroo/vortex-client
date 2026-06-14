package com.sulake.core.window.components
{
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.utils.PropertyStruct;

    public class BoxSizerController extends ContainerController implements IBoxSizerWindow
    {

        private var _spacing:int = 5;
        private var _horizontalPadding:int = 8;
        private var _verticalPadding:int = 8;
        private var _vertical:Boolean = false;
        private var _autoArrange:Boolean = true;

        public function BoxSizerController(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:uint, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:Function=null, _arg_9:Array=null, _arg_10:Array=null, _arg_11:uint=0)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function update(_arg_1:WindowController, _arg_2:WindowEvent):Boolean
        {
            switch (_arg_2.type)
            {
                case "WE_CHILD_RELOCATED":
                case "WE_CHILD_REMOVED":
                case "WE_CHILD_ADDED":
                case "WE_CHILD_RESIZED":
                case "WE_RESIZED":
                case "WE_CHILD_VISIBILITY":
                    arrangeChildren();
            };

            return (super.update(_arg_1, _arg_2));
        }

        private function arrangeChildren():void
        {
            var _local_4:IWindow;

            if (!_autoArrange)
            {
                return;
            };

            var _local_1:IWindow;
            var _local_3:int = calculateSpaceForRelatives();
            var _local_2:int = getRelativeValuesSum();

            if (!_vertical)
            {
                for each (_local_4 in _children)
                {
                    if (_local_4.visible)
                    {
                        if (!_local_1)
                        {
                            _local_4.x = _horizontalPadding;
                        }

                        else
                        {
                            _local_4.x = ((_local_1.x + _local_1.width) + _spacing);
                        };

                        _local_4.y = _verticalPadding;

                        if (getRelativeValue(_local_4) > 0)
                        {
                            _local_4.width = ((_local_3 * getRelativeValue(_local_4)) / _local_2);
                        };

                        _local_1 = _local_4;
                    };
                };
            }

            else
            {
                for each (_local_4 in _children)
                {
                    if (_local_4.visible)
                    {
                        if (!_local_1)
                        {
                            _local_4.y = _verticalPadding;
                        }

                        else
                        {
                            _local_4.y = ((_local_1.y + _local_1.height) + _spacing);
                        };

                        _local_4.x = _horizontalPadding;

                        if (getRelativeValue(_local_4) > 0)
                        {
                            _local_4.height = ((_local_3 * getRelativeValue(_local_4)) / _local_2);
                        };

                        _local_1 = _local_4;
                    };
                };
            };
        }

        private function getRelativeValue(_arg_1:IWindow):int
        {
            var _local_3:String;
            var _local_2:int;
            var _local_4:int;
            _local_2 = 0;

            while (_local_2 < _arg_1.tags.length)
            {
                _local_3 = _arg_1.tags[_local_2];

                if (_local_3.indexOf("relative") != -1)
                {
                    _local_4 = int(_local_3.slice((_local_3.indexOf("(") + 1), _local_3.indexOf(")")));

                    if (_local_4 < 0)
                    {
                        _local_4 = 0;
                    };

                    _arg_1.tags.splice(_local_2, 1, (("relative(" + _local_4) + ")"));
                };

                _local_2++;
            };

            return (_local_4);
        }

        private function getRelativeValuesSum():int
        {
            var _local_1:int;

            for each (var _local_2:IWindow in _children)
            {
                if (_local_2.visible)
                {
                    _local_1 = (_local_1 + getRelativeValue(_local_2));
                };
            };

            return (_local_1);
        }

        private function calculateSpaceForRelatives():int
        {
            var _local_1:int = ((_vertical) ? (this.height - (_verticalPadding * 2)) : (this.width - (_horizontalPadding * 2)));

            for each (var _local_2:IWindow in _children)
            {
                if (_local_2.visible != false)
                {
                    if (getRelativeValue(_local_2) == 0)
                    {
                        if (_vertical)
                        {
                            _local_1 = (_local_1 - (_local_2.height + _spacing));
                        }

                        else
                        {
                            _local_1 = (_local_1 - (_local_2.width + _spacing));
                        };
                    }

                    else
                    {
                        _local_1 = (_local_1 - _spacing);
                    };
                };
            };

            return (_local_1 + _spacing);
        }

        override public function get properties():Array
        {
            var _local_1:Array = super.properties;
            _local_1.push(createProperty("spacing", _spacing));
            _local_1.push(createProperty("vertical", _vertical));
            _local_1.push(createProperty("padding_horizontal", _horizontalPadding));
            _local_1.push(createProperty("padding_vertical", _verticalPadding));
            return (_local_1);
        }

        override public function set properties(_arg_1:Array):void
        {
            for each (var _local_2:PropertyStruct in _arg_1)
            {
                switch (_local_2.key)
                {
                    case "spacing":
                        _spacing = (_local_2.value as int);
                        break;
                    case "padding_horizontal":
                        _horizontalPadding = (_local_2.value as int);
                        break;
                    case "padding_vertical":
                        _verticalPadding = (_local_2.value as int);
                        break;
                    case "vertical":
                        _vertical = (_local_2.value as Boolean);
                };
            };

            super.properties = _arg_1;
            arrangeChildren();
        }

        public function setHorizontalPadding(_arg_1:int):void
        {
            _horizontalPadding = _arg_1;
            arrangeChildren();
        }

        public function setVerticalPadding(_arg_1:int):void
        {
            _verticalPadding = _arg_1;
            arrangeChildren();
        }

        public function setSpacing(_arg_1:int):void
        {
            _spacing = _arg_1;
            arrangeChildren();
        }

        public function setVertical(_arg_1:Boolean):void
        {
            _vertical = _arg_1;
            arrangeChildren();
        }

        public function setAutoRearrange(_arg_1:Boolean):void
        {
            _autoArrange = _arg_1;

            if (_arg_1)
            {
                arrangeChildren();
            };
        }

        public function getAutoRearrange():Boolean
        {
            return (_autoArrange);
        }

    }
}