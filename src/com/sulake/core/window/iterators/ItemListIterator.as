package com.sulake.core.window.iterators
{
    import flash.utils.Proxy;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.ItemListController;
    import com.sulake.core.window.IWindow;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

    public class ItemListIterator extends Proxy implements IIterator 
    {

        private var _iterable:ItemListController;

        public function ItemListIterator(_arg_1:ItemListController)
        {
            _iterable = _arg_1;
        }

        public function get length():uint
        {
            return (_iterable.numListItems);
        }

        public function indexOf(_arg_1:*):int
        {
            return (_iterable.getListItemIndex(_arg_1));
        }

        override flash_proxy function getProperty(_arg_1:*):*
        {
            return (_iterable.getListItemAt(uint(_arg_1)));
        }

        override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
        {
            var _local_3:IWindow;
            _local_3 = (_arg_2 as IWindow);

            var _local_4:int = _iterable.getListItemIndex(_local_3);

            if (_local_4 == _arg_1)
            {
                return;
            };

            if (_local_4 > -1)
            {
                _iterable.removeListItem(_local_3);
            };

            _iterable.addListItemAt(_local_3, _arg_1);
        }

        override flash_proxy function nextNameIndex(_arg_1:int):int
        {
            return ((_arg_1 < _iterable.numListItems) ? (_arg_1 + 1) : 0);
        }

        override flash_proxy function nextValue(_arg_1:int):*
        {
            return (_iterable.getListItemAt((_arg_1 - 1)));
        }

    }
}
