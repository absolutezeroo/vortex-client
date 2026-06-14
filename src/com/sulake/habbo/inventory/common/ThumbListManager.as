package com.sulake.habbo.inventory.common
{
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.inventory.IThumbListDrawableItem;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class ThumbListManager 
    {

        private var _dataProvider:IThumbListDataProvider;
        private var _columnsMax:int;
        private var _rowCount:int = 1;
        private var _listImage:BitmapData;
        private var _listItemHeight:int;
        private var _listItemWidth:int;
        private var _viewWidth:int;
        private var _viewHeight:int;
        private var _thumbWidth:int;
        private var _thumbHeight:int;
        private var _itemBgImage:BitmapData;
        private var _itemBgImageSelected:BitmapData;

        public function ThumbListManager(_arg_1:IAssetLibrary, _arg_2:IThumbListDataProvider, _arg_3:String, _arg_4:String, _arg_5:int, _arg_6:int)
        {
            _dataProvider = _arg_2;

            var _local_7:BitmapDataAsset = BitmapDataAsset(_arg_1.getAssetByName(_arg_3));

            if (_local_7 != null)
            {
                _itemBgImage = BitmapData(_local_7.content);
            };

            var _local_8:BitmapDataAsset = BitmapDataAsset(_arg_1.getAssetByName(_arg_4));

            if (_local_8 != null)
            {
                _itemBgImageSelected = BitmapData(_local_8.content);
            };

            _thumbWidth = _itemBgImage.width;
            _thumbHeight = _itemBgImage.height;
            _viewWidth = _arg_5;
            _viewHeight = _arg_6;
            _columnsMax = Math.floor((_viewWidth / _thumbWidth));
            _listImage = new BitmapData(_viewWidth, _viewHeight);
        }

        public function dispose():void
        {
            _dataProvider = null;
            _listImage = null;
        }

        public function updateImageFromList():void
        {
            var _local_5:int;
            var _local_3:int;
            var _local_1:IThumbListDrawableItem;
            var _local_2:BitmapData;
            _rowCount = resolveRowCountFromList();

            if (_rowCount == 0)
            {
                _listImage = new BitmapData(_viewWidth, _viewHeight);
                return;
            };

            _listImage = new BitmapData(Math.max((_columnsMax * _thumbWidth), _viewWidth), Math.max((_rowCount * _thumbHeight), _viewHeight), true, 0xFFFFFF);
            _listImage.fillRect(_listImage.rect, 0xFFFFFFFF);

            var _local_6:int;
            var _local_4:Array = getList();
            _local_5 = 0;

            while (_local_5 < _rowCount)
            {
                _local_3 = 0;

                while (_local_3 < _columnsMax)
                {
                    if (_local_6 < _local_4.length)
                    {
                        _local_1 = _local_4[_local_6];

                        if (_local_1 != null)
                        {
                            _local_2 = createThumbImage(_local_1.iconImage, _local_1.isSelected);
                            _listImage.copyPixels(_local_2, _local_2.rect, new Point((_local_3 * _thumbWidth), (_local_5 * _thumbHeight)), null, null, true);
                        };

                        _local_6++;
                    };

                    _local_3++;
                };

                _local_5++;
            };
        }

        public function addItemAsFirst(_arg_1:IThumbListDrawableItem):void
        {
            var _local_2:BitmapData;
            var _local_4:Rectangle;

            if (_arg_1 == null)
            {
                return;
            };

            var _local_5:Point = resolveLastItemGridLoc();

            if (((_local_5.x == _columnsMax) && (_listImage.height < (_local_5.y * _thumbHeight))))
            {
                _local_2 = new BitmapData(_listImage.width, (_listImage.height + _thumbHeight));
            }

            else
            {
                _local_2 = new BitmapData(_listImage.width, _listImage.height);
            };

            var _local_3:BitmapData = createThumbImage(_arg_1.iconImage, _arg_1.isSelected);
            _local_2.copyPixels(_local_3, _local_3.rect, new Point(0, 0), null, null, true);
            _local_4 = new Rectangle(0, 0, (_thumbWidth * (_columnsMax - 1)), _thumbHeight);
            _local_2.copyPixels(_listImage, _local_4, new Point(_thumbWidth, 0), null, null, true);
            _local_4 = new Rectangle((_thumbWidth * (_columnsMax - 1)), 0, _thumbWidth, _listImage.height);
            _local_2.copyPixels(_listImage, _local_4, new Point(0, _thumbHeight), null, null, true);
            _local_4 = new Rectangle(0, _thumbHeight, (_thumbWidth * (_columnsMax - 1)), (_listImage.height - _thumbHeight));
            _local_2.copyPixels(_listImage, _local_4, new Point(_thumbWidth, _thumbHeight), null, null, true);
            _listImage = _local_2;
        }

        public function replaceItemImage(_arg_1:int, _arg_2:IThumbListDrawableItem):void
        {
            if (_arg_2 == null)
            {
                return;
            };

            var _local_4:Point = resolveGridLocationFromIndex(_arg_1);
            var _local_5:Point = new Point((_local_4.x * _thumbWidth), (_local_4.y * _thumbHeight));
            var _local_3:BitmapData = createThumbImage(_arg_2.iconImage, _arg_2.isSelected);
            _listImage.copyPixels(_local_3, _local_3.rect, _local_5, null, null, true);
        }

        public function getListImage():BitmapData
        {
            return (_listImage);
        }

        public function removeItemInIndex(_arg_1:int):void
        {
            var _local_2:Point = resolveGridLocationFromIndex(_arg_1);
            removeItemInImage(_local_2);
        }

        public function removeItemInLocation(_arg_1:Point):void
        {
            var _local_2:Point = resolveGridLocationFromImage(_arg_1);
            removeItemInImage(_local_2);
        }

        public function updateListItem(_arg_1:int):void
        {
            var _local_2:IThumbListDrawableItem = getDrawableItem(_arg_1);
            replaceItemImage(_arg_1, _local_2);
        }

        private function getList():Array
        {
            var _local_1:Array;

            if (_dataProvider != null)
            {
                _local_1 = _dataProvider.getDrawableList();
            };

            return ((_local_1) ? _local_1 : []);
        }

        private function getDrawableItem(_arg_1:int):IThumbListDrawableItem
        {
            var _local_2:Array = getList();

            if (((_arg_1 >= 0) && (_arg_1 < _local_2.length)))
            {
                return (_local_2[_arg_1] as IThumbListDrawableItem);
            };

            return (null);
        }

        private function resolveRowCountFromList():int
        {
            var _local_1:Array = getList();
            return (int(Math.ceil((_local_1.length / _columnsMax))));
        }

        private function resolveLastItemGridLoc():Point
        {
            var _local_2:Array = getList();
            return (resolveGridLocationFromIndex((_local_2.length - 1)));
        }

        public function resolveIndexFromImageLocation(_arg_1:Point):int
        {
            var _local_3:Point = resolveGridLocationFromImage(_arg_1);
            return ((_local_3.y * _columnsMax) + _local_3.x);
        }

        private function resolveGridLocationFromImage(_arg_1:Point):Point
        {
            var _local_2:int = int(Math.floor((_arg_1.y / _thumbHeight)));
            var _local_3:int = int(Math.floor((_arg_1.x / _thumbWidth)));
            return (new Point(_local_3, _local_2));
        }

        private function resolveGridLocationFromIndex(_arg_1:int):Point
        {
            var _local_2:int = int(Math.floor((_arg_1 / _columnsMax)));
            var _local_3:int = (_arg_1 % _columnsMax);
            return (new Point(_local_3, _local_2));
        }

        private function removeItemInImage(_arg_1:Point):void
        {
            var _local_7:Rectangle;
            var _local_3:Point;
            var _local_6:int;
            var _local_8:int;
            var _local_2:BitmapData;
            var _local_9:BitmapData;
            var _local_5:BitmapData;
            var _local_12:BitmapData = null;

            if (_arg_1.x >= _columnsMax)
            {
                return;
            };

            if (_arg_1.y >= _rowCount)
            {
                return;
            };

            var _local_11:int = ((_columnsMax - _arg_1.x) - 1);
            _local_7 = new Rectangle(((_arg_1.x + 1) * _thumbWidth), (_arg_1.y * _thumbHeight), (_local_11 * _thumbWidth), _thumbHeight);
            _local_3 = new Point((_arg_1.x * _thumbWidth), (_arg_1.y * _thumbHeight));

            var _local_4:BitmapData = new BitmapData((_local_7.width + _thumbWidth), _local_7.height);
            _local_4.fillRect(_local_4.rect, 0xFFFFFFFF);
            _local_4.copyPixels(_listImage, _local_7, new Point(0, 0), null, null, true);
            _listImage.copyPixels(_local_4, _local_4.rect, _local_3, null, null, true);

            if (_arg_1.y < (_rowCount - 1))
            {
                _local_6 = (_listImage.width - _thumbWidth);
                _local_8 = (_listImage.height - ((_arg_1.y + 1) * _thumbHeight));
                _local_2 = new BitmapData(_local_6, _local_8);
                _local_7 = new Rectangle(_thumbWidth, ((_arg_1.y + 1) * _thumbHeight), _local_2.width, _local_2.height);
                _local_2.copyPixels(_listImage, _local_7, new Point(0, 0), null, null, true);
                _local_9 = new BitmapData(_thumbWidth, _local_7.height);
                _local_7.x = 0;
                _local_7.width = _thumbWidth;
                _local_9.copyPixels(_listImage, _local_7, new Point(0, 0), null, null, true);
                _listImage.fillRect(new Rectangle(0, (_listImage.height - _thumbHeight), _listImage.width, _thumbHeight), 0xFFFFFFFF);
                _local_3 = new Point((_listImage.width - _thumbWidth), (_local_7.y - _thumbHeight));
                _listImage.copyPixels(_local_9, _local_9.rect, _local_3, null, null, true);
                _local_3 = new Point(0, _local_7.y);
                _listImage.copyPixels(_local_2, _local_2.rect, _local_3, null, null, true);
            };

            var _local_10:int = (getList().length - 1);

            if (_local_10 > 0)
            {
                _arg_1 = resolveGridLocationFromIndex(_local_10);

                if (_arg_1.x == (_columnsMax - 1))
                {
                    _local_5 = new BitmapData(_listImage.width, (_listImage.height - _thumbHeight));
                    _local_7 = new Rectangle(0, 0, _listImage.width, (_listImage.height - _thumbHeight));
                    _local_5.copyPixels(_listImage, _local_7, new Point(0, 0), null, null, true);
                    _listImage = _local_5;
                    _rowCount--;
                };
            };

            if (_listImage.height < _viewHeight)
            {
                _local_12 = new BitmapData(_listImage.width, _viewHeight);
                _local_12.fillRect(_local_12.rect, 0xFFFFFFFF);
                _local_12.copyPixels(_listImage, _listImage.rect, new Point(0, 0), null, null, true);
                _listImage = _local_12;
            };
        }

        private function createThumbImage(_arg_1:BitmapData=null, _arg_2:Boolean=false):BitmapData
        {
            var _local_3:Point;
            var _local_4:BitmapData = new BitmapData(_itemBgImage.width, _itemBgImage.height);

            if (_arg_2)
            {
                _local_4.copyPixels(_itemBgImageSelected, _itemBgImage.rect, new Point(0, 0), null, null, false);
            }

            else
            {
                _local_4.copyPixels(_itemBgImage, _itemBgImage.rect, new Point(0, 0), null, null, false);
            };

            if (_arg_1 != null)
            {
                _local_3 = new Point(((_local_4.width - _arg_1.width) / 2), ((_local_4.height - _arg_1.height) / 2));
                _local_4.copyPixels(_arg_1, _arg_1.rect, _local_3, null, null, true);
            };

            return (_local_4);
        }

    }
}
