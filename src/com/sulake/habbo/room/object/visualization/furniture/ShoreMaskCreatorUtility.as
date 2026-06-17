package com.sulake.habbo.room.object.visualization.furniture
{
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.sulake.room.utils.BitmapDataUtil;

    public class ShoreMaskCreatorUtility 
    {

        public static const _SafeStr_3403:int = 0;
        public static const STRAIGHT_CUT:int = 1;
        public static const INNER_CUT:int = 2;
        private static const CUT_TYPE_COUNT:int = 3;
        private static const MASK_COLOR_TRANSPARENT:uint = 0;
        private static const MASK_COLOR_SOLID:uint = 0xFFFFFFFF;

        public static function createEmptyMask(_arg_width:int, _arg_height:int):BitmapData
        {
            return (new BitmapData(_arg_width, _arg_height, true, 0));
        }

        public static function getInstanceMaskName(_arg_objectId:int, _arg_direction:int):String
        {
            return ((("instance_mask_" + _arg_objectId) + "_") + _arg_direction);
        }

        public static function getBorderType(_arg_outerCorner:int, _arg_innerCorner:int):int
        {
            return (_arg_outerCorner + (_arg_innerCorner * 3));
        }

        public static function getInstanceMask(_arg_objectId:int, _arg_direction:int, _arg_assetCollection:IGraphicAssetCollection, _arg_sourceAsset:IGraphicAsset):IGraphicAsset
        {
            var _local_bitmapDataAsset:BitmapDataAsset;
            var _local_sourceBitmapData:BitmapData;
            var _local_maskName:String = getInstanceMaskName(_arg_objectId, _arg_direction);
            var _local_maskAsset:IGraphicAsset = _arg_assetCollection.getAsset(_local_maskName);

            if (_local_maskAsset == null)
            {
                if (_arg_sourceAsset != null)
                {
                    _local_bitmapDataAsset = (_arg_sourceAsset.asset as BitmapDataAsset);

                    if (_local_bitmapDataAsset != null)
                    {
                        _local_sourceBitmapData = (_local_bitmapDataAsset.content as BitmapData);

                        if (_local_sourceBitmapData != null)
                        {
                            _arg_assetCollection.addAsset(_local_maskName, new BitmapData(_local_sourceBitmapData.width, _local_sourceBitmapData.height, true, 0), false, _arg_sourceAsset.offsetX, _arg_sourceAsset.offsetY);
                            _local_maskAsset = _arg_assetCollection.getAsset(_local_maskName);
                        };
                    };
                };
            };

            return (_local_maskAsset);
        }

        public static function disposeInstanceMask(_arg_objectId:int, _arg_direction:int, _arg_assetCollection:IGraphicAssetCollection):void
        {
            var _local_maskName:String = getInstanceMaskName(_arg_objectId, _arg_direction);
            _arg_assetCollection.disposeAsset(_local_maskName);
        }

        public static function createShoreMask2x2(_arg_targetBitmapData:BitmapData, _arg_objectId:int, _arg_cutFlags:Array, _arg_borderTypes:Array, _arg_assetCollection:IGraphicAssetCollection):BitmapData
        {
            var _local_index:int;
            var _local_maskName:String;
            var _local_maskAsset:IGraphicAsset;
            var _local_maskBitmapData:BitmapData;
            _arg_targetBitmapData.fillRect(_arg_targetBitmapData.rect, 0);
            _local_index = 0;

            while (_local_index < _arg_cutFlags.length)
            {
                if (_arg_cutFlags[_local_index] == true)
                {
                    _local_maskName = ((((("mask_" + _arg_objectId) + "_") + _local_index) + "_") + _arg_borderTypes[_local_index]);
                    _local_maskAsset = _arg_assetCollection.getAsset(_local_maskName);

                    if (((!(_local_maskAsset == null)) && (!(_local_maskAsset.asset == null))))
                    {
                        _local_maskBitmapData = (_local_maskAsset.asset.content as BitmapData);

                        if (_local_maskBitmapData != null)
                        {
                            _arg_targetBitmapData.copyPixels(_local_maskBitmapData, _local_maskBitmapData.rect, new Point(0, 0), _local_maskBitmapData, new Point(0, 0), true);
                        };
                    };
                };

                _local_index++;
            };

            return (_arg_targetBitmapData);
        }

        public static function initializeShoreMasks(_arg_objectId:int, _arg_assetCollection:IGraphicAssetCollection, _arg_sourceAsset:IGraphicAsset):Boolean
        {
            var _local_masksDoneName:String;
            var _local_bitmapDataAsset:BitmapDataAsset;
            var _local_sourceBitmapData:BitmapData;
            var _local_outerCorners:Array;
            var _local_innerCorners:Array;
            var _local_maskBitmapData:BitmapData;
            var _local_index:int;

            if (_arg_assetCollection != null)
            {
                _local_masksDoneName = ("masks_done_" + _arg_objectId);

                if (_arg_assetCollection.getAsset(_local_masksDoneName) == null)
                {
                    if (_arg_sourceAsset != null)
                    {
                        _local_bitmapDataAsset = (_arg_sourceAsset.asset as BitmapDataAsset);

                        if (_local_bitmapDataAsset != null)
                        {
                            _local_sourceBitmapData = (_local_bitmapDataAsset.content as BitmapData);
                            _local_outerCorners = [0, 1, 2, 0, 1, 2];
                            _local_innerCorners = [1, 1, 1, 2, 2, 2];
                            _local_maskBitmapData = null;
                            _local_index = 0;

                            if (_local_sourceBitmapData != null)
                            {
                                _local_index = 0;

                                while (((_local_index < _local_outerCorners.length) && (_local_index < _local_innerCorners.length)))
                                {
                                    _local_maskBitmapData = createMaskLeft(_local_sourceBitmapData.width, _local_sourceBitmapData.height);
                                    cutLeftMask(_local_maskBitmapData, _arg_objectId, _local_outerCorners[_local_index], _local_innerCorners[_local_index]);
                                    storeLeftMask(_arg_assetCollection, _local_maskBitmapData, _arg_objectId, _local_outerCorners[_local_index], _local_innerCorners[_local_index]);
                                    _local_maskBitmapData = createMaskRight(_local_sourceBitmapData.width, _local_sourceBitmapData.height);
                                    cutRightMask(_local_maskBitmapData, _arg_objectId, _local_innerCorners[_local_index], _local_outerCorners[_local_index]);
                                    storeRightMask(_arg_assetCollection, _local_maskBitmapData, _arg_objectId, _local_innerCorners[_local_index], _local_outerCorners[_local_index]);
                                    _local_index++;
                                };
                            };
                        };

                        _arg_assetCollection.addAsset(_local_masksDoneName, new BitmapData(1, 1), false);
                        return (true);
                    };

                    return (false);
                };

                return (true);
            };

            return (false);
        }

        private static function createMaskLeft(_arg_1:int, _arg_2:int):BitmapData
        {
            var _local_3:BitmapData = new BitmapData(_arg_1, _arg_2, true, 0);
            fillTopLeftCorner(_local_3, (_local_3.width / 2), ((_local_3.height / 2) - 1), 1, 0xFFFFFFFF);
            return (_local_3);
        }

        private static function cutLeftMask(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            if (_arg_3 == 1)
            {
                cutLeftMaskOuterCorner(_arg_1, _arg_2, false);
            }

            else
            {
                if (_arg_3 == 2)
                {
                    cutLeftMaskOuterCorner(_arg_1, _arg_2, true);
                };
            };

            if (_arg_4 == 2)
            {
                cutLeftMaskInnerCorner(_arg_1, _arg_2);
            };
        }

        private static function cutLeftMaskOuterCorner(_arg_1:BitmapData, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:int = int(((_arg_1.height / 2) - (_arg_2 / 2)));
            var _local_5:int = int((_arg_1.width / 2));

            if (_arg_3)
            {
                _arg_1.fillRect(new Rectangle(_local_5, 0, _arg_1.width, _local_4), 0);
            }

            else
            {
                fillTopLeftCorner(_arg_1, _local_5, (_local_4 - 1), 1, 0);
            };
        }

        private static function cutLeftMaskInnerCorner(_arg_1:BitmapData, _arg_2:int):void
        {
            var _local_3:int = int(((_arg_1.width / 2) + (_arg_2 / 2)));
            _arg_1.fillRect(new Rectangle(_local_3, 0, _arg_1.width, (_arg_1.height / 2)), 0);
        }

        private static function createMaskRight(_arg_1:int, _arg_2:int):BitmapData
        {
            var _local_3:BitmapData = new BitmapData(_arg_1, _arg_2, true, 0);
            fillBottomRightCorner(_local_3, ((_local_3.width / 2) + 1), ((_local_3.height / 2) - 1), 0xFFFFFFFF);
            return (_local_3);
        }

        private static function cutRightMask(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            if (_arg_4 == 1)
            {
                cutRightMaskOuterCorner(_arg_1, _arg_2, false);
            }

            else
            {
                if (_arg_4 == 2)
                {
                    cutRightMaskOuterCorner(_arg_1, _arg_2, true);
                };
            };

            if (_arg_3 == 2)
            {
                cutRightMaskInnerCorner(_arg_1, _arg_2);
            };
        }

        private static function cutRightMaskInnerCorner(_arg_1:BitmapData, _arg_2:int):void
        {
            var _local_3:int = int(((_arg_1.width / 2) + (_arg_2 / 2)));
            _arg_1.fillRect(new Rectangle(_local_3, 0, _arg_1.width, ((_arg_1.height / 2) - (_arg_2 / 4))), 0);
        }

        private static function cutRightMaskOuterCorner(_arg_1:BitmapData, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:int = int((_arg_1.height / 2));
            var _local_5:int = int(((_arg_1.width / 2) + _arg_2));

            if (_arg_3)
            {
                _arg_1.fillRect(new Rectangle(_local_5, 0, _arg_1.width, _local_4), 0);
            }

            else
            {
                fillBottomRightCorner(_arg_1, (_local_5 + 1), (_local_4 - 1), 0);
            };
        }

        private static function storeLeftMask(_arg_1:IGraphicAssetCollection, _arg_2:BitmapData, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:String;

            if (_arg_1 != null)
            {
                _local_6 = "";
                _local_6 = ((("mask_" + _arg_3) + "_0_") + getBorderType(_arg_4, _arg_5));
                _arg_1.addAsset(_local_6, _arg_2, false);
                _local_6 = ((("mask_" + _arg_3) + "_3_") + getBorderType(_arg_5, _arg_4));
                _arg_1.addAsset(_local_6, BitmapDataUtil.getFlipVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + _arg_3) + "_4_") + getBorderType(_arg_4, _arg_5));
                _arg_1.addAsset(_local_6, BitmapDataUtil.getFlipHVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + _arg_3) + "_7_") + getBorderType(_arg_5, _arg_4));
                _arg_1.addAsset(_local_6, BitmapDataUtil.getFlipHBitmapData(_arg_2), false);
            };
        }

        private static function storeRightMask(_arg_1:IGraphicAssetCollection, _arg_2:BitmapData, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:String;

            if (_arg_1 != null)
            {
                _local_6 = "";
                _local_6 = ((("mask_" + _arg_3) + "_1_") + getBorderType(_arg_4, _arg_5));
                _arg_1.addAsset(_local_6, _arg_2, false);
                _local_6 = ((("mask_" + _arg_3) + "_2_") + getBorderType(_arg_5, _arg_4));
                _arg_1.addAsset(_local_6, BitmapDataUtil.getFlipVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + _arg_3) + "_5_") + getBorderType(_arg_4, _arg_5));
                _arg_1.addAsset(_local_6, BitmapDataUtil.getFlipHVBitmapData(_arg_2), false);
                _local_6 = ((("mask_" + _arg_3) + "_6_") + getBorderType(_arg_5, _arg_4));
                _arg_1.addAsset(_local_6, BitmapDataUtil.getFlipHBitmapData(_arg_2), false);
            };
        }

        private static function fillTopLeftCorner(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:uint):void
        {
            var _local_9:int;
            var _local_6:int = _arg_2;
            var _local_7:int = _arg_3;
            var _local_8:int = _arg_4;

            while (_local_7 >= 0)
            {
                _local_9 = _local_7;

                while (_local_9 >= 0)
                {
                    _arg_1.setPixel32(_local_6, _local_9, _arg_5);
                    _local_9--;
                };

                if (++_local_8 >= 2)
                {
                    _local_7--;
                    _local_8 = 0;
                };

                _local_6++;
            };
        }

        private static function fillBottomRightCorner(_arg_1:BitmapData, _arg_2:int, _arg_3:int, _arg_4:uint):void
        {
            var _local_7:int;
            var _local_5:int = _arg_2;
            var _local_6:int = _arg_3;

            while (_local_5 < _arg_1.width)
            {
                _local_7 = _local_5;

                while (_local_7 < _arg_1.width)
                {
                    _arg_1.setPixel32(_local_7, _local_6, _arg_4);
                    _local_7++;
                };

                _local_6--;
                _local_5 = (_local_5 + 2);
            };
        }

    }
}

