package com.sulake.core.window.iterators
{
    import flash.utils.Proxy;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.ItemGridController;
    import com.sulake.core.window.IWindow;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

    public class ItemGridIterator extends Proxy implements IIterator 
    {

        private var _iterable:ItemGridController;

        public function ItemGridIterator(_arg_1:ItemGridController)
        {
            _iterable = _arg_1;
        }

        public function get length():uint
        {
            return (_iterable.numGridItems);
        }

        public function indexOf(_arg_1:*):int
        {
            return (_iterable.getGridItemIndex(_arg_1));
        }

        override flash_proxy function getProperty(_arg_1:*):*
        {
            return (_iterable.getGridItemAt(uint(_arg_1)));
        }

        override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
        {
            var _local_3:IWindow;
            _local_3 = (_arg_2 as IWindow);

            var _local_4:int = _iterable.getGridItemIndex(_local_3);

            if (_local_4 == _arg_1)
            {
                return;
            };

            if (_local_4 > -1)
            {
                _iterable.removeGridItem(_local_3);
            };

            _iterable.addGridItemAt(_local_3, _arg_1);
        }

        override flash_proxy function nextNameIndex(_arg_1:int):int
        {
            return ((_arg_1 < _iterable.numGridItems) ? (_arg_1 + 1) : 0);
        }

        override flash_proxy function nextValue(_arg_1:int):*
        {
            return (_iterable.getGridItemAt((_arg_1 - 1)));
        }

    }
}
