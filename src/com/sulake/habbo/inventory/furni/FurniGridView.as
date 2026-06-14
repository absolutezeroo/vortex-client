package com.sulake.habbo.inventory.furni
{
    import com.sulake.core.window.components.IItemGridWindow;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class FurniGridView 
    {

        private static const PLACEMENT_ANYWHERE:int = 0;
        private static const PLACEMENT_IN_ROOM:int = 1;
        private static const PLACEMENT_NOT_IN_ROOM:int = 2;

        private var _grid:IItemGridWindow;
        private var _items:Vector.<GroupItem>;
        private var _showFloorItems:Boolean = true;
        private var _showWallItems:Boolean = true;
        private var _placement:int;
        private var _showingRentedItems:Boolean = false;
        private var _passedItems:Vector.<GroupItem>;
        private var _pages:IItemListWindow;
        private var _pageTemplate:IRegionWindow;
        private var _itemsPerPage:int = 200;
        private var _currentPage:int = -1;
        private var _currentPageItems:Vector.<GroupItem>;
        private var _filter:String = "";

        public function FurniGridView(_arg_1:IItemGridWindow, _arg_2:IItemListWindow)
        {
            _grid = _arg_1;
            _grid.shouldRebuildGridOnResize = false;
            _items = new Vector.<GroupItem>(0);
            _passedItems = new Vector.<GroupItem>(0);
            _pages = _arg_2;

            if (_pages)
            {
                _pageTemplate = (_pages.removeListItemAt(0) as IRegionWindow);
            };
        }

        public function get visibleCount():int
        {
            return (_grid.numGridItems);
        }

        public function get currentPageItems():Vector.<GroupItem>
        {
            return (_currentPageItems);
        }

        private function get pageCount():int
        {
            return ((_passedItems.length / _itemsPerPage) + 1);
        }

        public function dispose():void
        {
            _grid = null;
            _items = null;
        }

        public function clearGrid():void
        {
            if (_grid != null)
            {
                _grid.removeGridItems();
            };

            _grid.destroyGridItems();
        }

        public function setFilter(_arg_1:int, _arg_2:String, _arg_3:Boolean, _arg_4:String, _arg_5:int):void
        {
            _showFloorItems = ((_arg_1 == 0) || (_arg_1 == 1));
            _showWallItems = ((_arg_1 == 0) || (_arg_1 == 2));
            _showingRentedItems = _arg_3;
            _placement = _arg_5;
            _filter = _arg_4.toLowerCase();
            update();
        }

        public function itemWasUpdated(_arg_1:GroupItem):void
        {
            if (passFilter(_arg_1))
            {
                update();
            };
        }

        public function getFirstThumb():IWindowContainer
        {
            if (_grid.numGridItems == 0)
            {
                return (null);
            };

            return (_grid.getGridItemAt(0) as IWindowContainer);
        }

        public function setItems(_arg_1:Vector.<GroupItem>):void
        {
            _items = _arg_1;
            update();
        }

        private function update():void
        {
            var currentItems:Vector.<GroupItem> = new Vector.<GroupItem>(0);

            for each (var item:GroupItem in _items)
            {
                if (passFilter(item))
                {
                    currentItems.push(item);
                };
            };

            if (_showingRentedItems)
            {
                currentItems = currentItems.sort(function (_arg_1:GroupItem, _arg_2:GroupItem):Number
                {
                    var _local_5:FurnitureItem = _arg_1.peek();
                    var _local_4:FurnitureItem = _arg_2.peek();
                    var _local_3:int = (int(_local_4.hasRentPeriodStarted) - int(_local_5.hasRentPeriodStarted));
                    return ((_local_3 != 0) ? _local_3 : (_local_5.secondsToExpiration - _local_4.secondsToExpiration));
                });
            };

            if (currentItems.length == _passedItems.length)
            {
                var changes:Boolean = false;
                var i:int = 0;

                while (i < currentItems.length)
                {
                    if (currentItems[i] != _passedItems[i])
                    {
                        changes = true;
                        break;
                    };

                    i++;
                };

                if (!changes)
                {
                    return;
                };
            };

            _passedItems = currentItems;
            changeToPage(_currentPage, true);
            updatePaging();
        }

        private function changeToPage(_arg_1:int, _arg_2:Boolean=false):void
        {
            var _local_5:int;

            if (_arg_1 > -1)
            {
                if (((_currentPage == _arg_1) && (!(_arg_2))))
                {
                    return;
                };
            }

            else
            {
                _arg_1 = 0;
            };

            _currentPage = _arg_1;

            if (_currentPage >= pageCount)
            {
                _currentPage = (pageCount - 1);
            };

            _currentPage = Math.max(_currentPage, 0);
            _currentPageItems = new Vector.<GroupItem>(0);
            clearGrid();

            var _local_3:int = (_currentPage * _itemsPerPage);
            var _local_4:int = (_local_3 + _itemsPerPage);
            _local_4 = Math.min(_local_4, _passedItems.length);
            _local_5 = _local_3;

            while (_local_5 < _local_4)
            {
                _grid.addGridItem(_passedItems[_local_5].window);
                _currentPageItems.push(_passedItems[_local_5]);
                _local_5++;
            };
        }

        private function updatePassedItems(_arg_1:GroupItem):void
        {
        }

        private function updatePaging():void
        {
            var _local_4:IRegionWindow;
            var _local_3:int;
            var _local_2:ITextWindow;

            if (!_pages)
            {
                return;
            };

            var _local_1:int = pageCount;
            _pages.visible = (_local_1 > 1);

            if (_currentPage >= _local_1)
            {
                _currentPage = (_local_1 - 1);
            };

            _currentPage = Math.max(_currentPage, 0);

            if (pageCount != _pages.numListItems)
            {
                for each (_local_4 in _pages)
                {
                    _local_4.removeEventListener("WME_CLICK", onPageEventProc);
                };

                _pages.destroyListItems();
                _local_3 = 0;

                while (_local_3 < _local_1)
                {
                    _local_4 = (_pageTemplate.clone() as IRegionWindow);
                    _local_4.addEventListener("WME_CLICK", onPageEventProc);
                    _local_4.addEventListener("WME_OVER", onPageEventProc);
                    _local_4.addEventListener("WME_OUT", onPageEventProc);
                    _local_4.id = _local_3;
                    _local_4.name = ("page_" + _local_3);
                    _pages.addListItem(_local_4);
                    _local_3++;
                };
            };

            _local_3 = 0;

            while (_local_3 < _local_1)
            {
                _local_4 = (_pages.getListItemAt(_local_3) as IRegionWindow);
                _local_2 = (_local_4.findChildByTag("PAGE") as ITextWindow);
                _local_2.caption = _local_3.toString();

                if (_local_3 == _currentPage)
                {
                    _local_2.underline = true;
                    _local_2.textColor = 0xFF0000;
                }

                else
                {
                    _local_2.underline = false;
                    _local_2.textColor = 0;
                };

                _local_3++;
            };
        }

        private function onPageEventProc(_arg_1:WindowMouseEvent):void
        {
            var _local_3:int = _arg_1.window.id;
            var _local_2:ITextWindow = ((_arg_1.target as IWindowContainer).findChildByTag("PAGE") as ITextWindow);
            switch (_arg_1.type)
            {
                case "WME_CLICK":
                    changeToPage(_local_3);
                    updatePaging();
                    return;
                case "WME_OVER":
                    _local_2.textColor = 0xFF0000;
                    return;
                case "WME_OUT":

                    if (_local_3 != _currentPage)
                    {
                        _local_2.textColor = 0;
                    };

                    return;
            };
        }

        private function passFilter(_arg_1:GroupItem):Boolean
        {
            var _local_2:String;
            var _local_3:String;

            if (((!(_showFloorItems)) && (!(_arg_1.isWallItem))))
            {
                return (false);
            };

            if (((!(_showWallItems)) && (_arg_1.isWallItem)))
            {
                return (false);
            };

            if (_showingRentedItems != _arg_1.isRented)
            {
                return (false);
            };

            if (((_placement == 1) && (_arg_1.flatId == -1)))
            {
                return (false);
            };

            if (((_placement == 2) && (_arg_1.flatId > -1)))
            {
                return (false);
            };

            if (_filter.length > 0)
            {
                _local_2 = _arg_1.name.toLowerCase();
                _local_3 = _arg_1.description.toLowerCase();

                if (((_local_2.indexOf(_filter) == -1) && (_local_3.indexOf(_filter) == -1)))
                {
                    return (false);
                };
            };

            return (true);
        }

    }
}
