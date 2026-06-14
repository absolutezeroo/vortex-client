package com.sulake.core.window.utils
{
    import com.sulake.core.window.IWindow;

    public class WindowRectLimits implements IRectLimiter 
    {

        private var _minWidth:int = -2147483648;
        private var _maxWidth:int = 2147483647;
        private var _minHeight:int = -2147483648;
        private var _maxHeight:int = 2147483647;
        private var _target:IWindow;

        public function WindowRectLimits(target:IWindow)
        {
            _target = target;
        }

        public function get minWidth():int
        {
            return (_minWidth);
        }

        public function get maxWidth():int
        {
            return (_maxWidth);
        }

        public function get minHeight():int
        {
            return (_minHeight);
        }

        public function get maxHeight():int
        {
            return (_maxHeight);
        }

        public function set minWidth(minWidth:int):void
        {
            _minWidth = minWidth;

            if ((((_minWidth > -2147483648) && (!(_target.disposed))) && (_target.width < _minWidth)))
            {
                _target.width = _minWidth;
            };
        }

        public function set maxWidth(maxWidth:int):void
        {
            _maxWidth = maxWidth;

            if ((((_maxWidth < 2147483647) && (!(_target.disposed))) && (_target.width > _maxWidth)))
            {
                _target.width = _maxWidth;
            };
        }

        public function set minHeight(minHeight:int):void
        {
            _minHeight = minHeight;

            if ((((_minHeight > -2147483648) && (!(_target.disposed))) && (_target.height < _minHeight)))
            {
                _target.height = _minHeight;
            };
        }

        public function set maxHeight(maxHeight:int):void
        {
            _maxHeight = maxHeight;

            if ((((_maxHeight < 2147483647) && (!(_target.disposed))) && (_target.height > _maxHeight)))
            {
                _target.height = _maxHeight;
            };
        }

        public function get isEmpty():Boolean
        {
            return ((((_minWidth == -2147483648) && (_maxWidth == 2147483647)) && (_minHeight == -2147483648)) && (_maxHeight == 2147483647));
        }

        public function setEmpty():void
        {
            _minWidth = -2147483648;
            _maxWidth = 2147483647;
            _minHeight = -2147483648;
            _maxHeight = 2147483647;
        }

        public function limit():void
        {
            if (((!(isEmpty)) && (_target)))
            {
                if (_target.width < _minWidth)
                {
                    _target.width = _minWidth;
                }

                else
                {
                    if (_target.width > _maxWidth)
                    {
                        _target.width = _maxWidth;
                    };
                };

                if (_target.height < _minHeight)
                {
                    _target.height = _minHeight;
                }

                else
                {
                    if (_target.height > _maxHeight)
                    {
                        _target.height = _maxHeight;
                    };
                };
            };
        }

        public function assign(minWidth:int, maxWidth:int, minHeight:int, maxHeight:int):void
        {
            _minWidth = minWidth;
            _maxWidth = maxWidth;
            _minHeight = minHeight;
            _maxHeight = maxHeight;
            limit();
        }

        public function clone(_arg_1:IWindow):WindowRectLimits
        {
            var _local_2:WindowRectLimits = new WindowRectLimits(_arg_1);
            _local_2._minWidth = _minWidth;
            _local_2._maxWidth = _maxWidth;
            _local_2._minHeight = _minHeight;
            _local_2._maxHeight = _maxHeight;
            return (_local_2);
        }

    }
}
