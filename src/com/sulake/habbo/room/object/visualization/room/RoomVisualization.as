package com.sulake.habbo.room.object.visualization.room
{
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.room.object.visualization.IPlaneVisualization;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import flash.geom.Rectangle;
    import com.sulake.habbo.room.object.RoomPlaneBitmapMaskParser;
    import com.sulake.core.assets.IAsset;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object.enum.RoomObjectSpriteType;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import com.sulake.room.object.visualization.IRoomPlane;

    public class RoomVisualization extends RoomObjectSpriteVisualization implements IPlaneVisualization
    {

        public static const _SafeStr_3465:int = 0xFFFFFF;
        public static const _SafeStr_3466:int = 0xDDDDDD;
        public static const FLOOR_COLOR_RIGHT:int = 0xBBBBBB;
        private static const _SafeStr_3467:int = 0xFFFFFF;
        private static const WALL_COLOR_SIDE:int = 0xCCCCCC;
        private static const WALL_COLOR_BOTTOM:int = 0x999999;
        private static const WALL_COLOR_BORDER:int = 0x999999;
        public static const LANDSCAPE_COLOR_TOP:int = 0xFFFFFF;
        public static const LANDSCAPE_COLOR_SIDE:int = 0xCCCCCC;
        public static const LANDSCAPE_COLOR_BOTTOM:int = 0x999999;
        private static const ROOM_DEPTH_OFFSET:Number = 1000;

        private const _SafeStr_3243:int = 250;

        protected var _SafeStr_690:RoomVisualizationData = null;
        private var _assetLibrary:AssetLibrary = null;
        private var _roomPlaneParser:RoomPlaneParser = null;
        private var _planes:Array = [];
        private var _planesInitialized:Boolean = false;
        private var _visiblePlanes:Array = [];
        private var _visiblePlaneSpriteNumbers:Array = [];
        private var _boundingRectangle:Rectangle = null;
        private var _roomPlaneBitmapMaskParser:RoomPlaneBitmapMaskParser = null;
        private var _wallType:String = null;
        private var _floorType:String = null;
        private var _landscapeType:String = null;
        private var _floorThicknessMultiplier:Number = NaN;
        private var _wallThicknessMultiplier:Number = NaN;
        private var _floorHoleUpdateTime:Number = NaN;
        private var _planeMaskData:String = null;
        private var _backgroundColor:uint = 0xFFFFFF;
        private var _backgroundRed:int = 0xFF;
        private var _backgroundGreen:int = 0xFF;
        private var _backgroundBlue:int = 0xFF;
        private var _colorizeBgOnly:Boolean = true;
        private var _assetUpdateCounter:int = 0;
        private var _lastUpdateTime:int = -1000;
        private var FLOOR_COLOR:int = -1;
        private var _geometryDirX:Number = 0;
        private var _geometryDirY:Number = 0;
        private var _geometryDirZ:Number = 0;
        private var _geometryScale:Number = 0;
        private var _planeTypeVisibilities:Array = [];

        public function RoomVisualization()
        {
            _assetLibrary = new AssetLibrary("room visualization");
            _roomPlaneParser = new RoomPlaneParser();
            _roomPlaneBitmapMaskParser = new RoomPlaneBitmapMaskParser();
            _planeTypeVisibilities[0] = false;
            _planeTypeVisibilities[2] = true;
            _planeTypeVisibilities[1] = true;
            _planeTypeVisibilities[3] = true;
        }

        public function get floorRelativeDepth():Number
        {
            return (1000 + 0.1);
        }

        public function get wallRelativeDepth():Number
        {
            return (1000 + 0.5);
        }

        public function get wallAdRelativeDepth():Number
        {
            return (1000 + 0.49);
        }

        public function get planeCount():int
        {
            return (_planes.length);
        }

        override public function dispose():void
        {
            var _local_1:int;
            var _local_2:IAsset;
            super.dispose();

            if (_assetLibrary != null)
            {
                _local_1 = 0;

                while (_local_1 < _assetLibrary.numAssets)
                {
                    _local_2 = _assetLibrary.getAssetByIndex(_local_1);

                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    };

                    _local_1++;
                };

                _assetLibrary.dispose();
                _assetLibrary = null;
            };

            resetRoomPlanes();
            _planes = null;
            _visiblePlanes = null;
            _visiblePlaneSpriteNumbers = null;

            if (_roomPlaneParser != null)
            {
                _roomPlaneParser.dispose();
                _roomPlaneParser = null;
            };

            if (_roomPlaneBitmapMaskParser != null)
            {
                _roomPlaneBitmapMaskParser.dispose();
                _roomPlaneBitmapMaskParser = null;
            };

            if (_SafeStr_690 != null)
            {
                _SafeStr_690.clearCache();
                _SafeStr_690 = null;
            };
        }

        private function resetRoomPlanes():void
        {
            var _local_2:int;
            var _local_1:RoomPlane;

            if (_planes != null)
            {
                _local_2 = 0;

                while (_local_2 < _planes.length)
                {
                    _local_1 = (_planes[_local_2] as RoomPlane);

                    if (_local_1 != null)
                    {
                        _local_1.dispose();
                    };

                    _local_2++;
                };

                _planes = [];
            };

            _planesInitialized = false;
            _assetUpdateCounter = (_assetUpdateCounter + 1);
            reset();
        }

        override protected function reset():void
        {
            super.reset();
            _wallType = null;
            _floorType = null;
            _landscapeType = null;
            _planeMaskData = null;
            FLOOR_COLOR = -1;
            _geometryScale = 0;
        }

        override public function get boundingRectangle():Rectangle
        {
            if (_boundingRectangle == null)
            {
                _boundingRectangle = super.boundingRectangle;
            };

            return (new Rectangle(_boundingRectangle.x, _boundingRectangle.y, _boundingRectangle.width, _boundingRectangle.height));
        }

        override public function initialize(_arg_1:IRoomObjectVisualizationData):Boolean
        {
            reset();

            if (((_arg_1 == null) || (!(_arg_1 is RoomVisualizationData))))
            {
                return (false);
            };

            _SafeStr_690 = (_arg_1 as RoomVisualizationData);
            _SafeStr_690.initializeAssetCollection(assetCollection);
            return (true);
        }

        protected function defineSprites():void
        {
            var _local_3:int;
            var _local_1:RoomPlane;
            var _local_2:IRoomObjectSprite;
            var _local_4:int = _planes.length;
            createSprites(_local_4);
            _local_3 = 0;

            while (_local_3 < _local_4)
            {
                _local_1 = (_planes[_local_3] as RoomPlane);
                _local_2 = getSprite(_local_3);

                if (((((!(_local_2 == null)) && (!(_local_1 == null))) && (!(_local_1.leftSide == null))) && (!(_local_1.rightSide == null))))
                {
                    if (((_local_1.type == 1) && ((_local_1.leftSide.length < 1) || (_local_1.rightSide.length < 1))))
                    {
                        _local_2.alphaTolerance = 0x0100;
                    }

                    else
                    {
                        _local_2.alphaTolerance = 128;
                    };

                    if (_local_1.type == 1)
                    {
                        _local_2.tag = ("plane.wall@" + (_local_3 + 1));
                    }

                    else
                    {
                        if (_local_1.type == 2)
                        {
                            _local_2.tag = ("plane.floor@" + (_local_3 + 1));
                        }

                        else
                        {
                            _local_2.tag = ("plane@" + (_local_3 + 1));
                        };
                    };

                    _local_2.spriteType = RoomObjectSpriteType.ROOM_PLANE;
                };

                _local_3++;
            };
        }

        protected function initializeRoomPlanes():void
        {
            var _local_8:int;
            var _local_3:IVector3d;
            var _local_18:IVector3d;
            var _local_11:IVector3d;
            var _local_6:Array;
            var _local_12:int;
            var _local_1:RoomPlane;
            var _local_4:IVector3d;
            var _local_19:Number;
            var _local_21:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_10:int;
            var _local_5:Number;
            var _local_2:Number;
            var _local_15:Number;
            var _local_9:Number;

            if (_planesInitialized)
            {
                return;
            };

            var _local_20:IRoomObject = object;

            if (_local_20 == null)
            {
                return;
            };

            if (!isNaN(_floorThicknessMultiplier))
            {
                _roomPlaneParser.floorThicknessMultiplier = _floorThicknessMultiplier;
            };

            if (!isNaN(_wallThicknessMultiplier))
            {
                _roomPlaneParser.wallThicknessMultiplier = _wallThicknessMultiplier;
            };

            var _local_7:String = _local_20.getModel().getString("room_plane_xml");

            if (!_roomPlaneParser.initializeFromXML(new XML(_local_7)))
            {
                return;
            };

            var _local_23:Number = getLandscapeWidth();
            var _local_17:Number = getLandscapeHeight();
            var _local_22:Number = 0;
            var _local_16:Number = _local_20.getModel().getNumber("room_random_seed");
            _local_8 = 0;

            while (_local_8 < _roomPlaneParser.planeCount)
            {
                _local_3 = _roomPlaneParser.getPlaneLocation(_local_8);
                _local_18 = _roomPlaneParser.getPlaneLeftSide(_local_8);
                _local_11 = _roomPlaneParser.getPlaneRightSide(_local_8);
                _local_6 = _roomPlaneParser.getPlaneSecondaryNormals(_local_8);
                _local_12 = _roomPlaneParser.getPlaneType(_local_8);
                _local_1 = null;

                if ((((!(_local_3 == null)) && (!(_local_18 == null))) && (!(_local_11 == null))))
                {
                    _local_4 = Vector3d.crossProduct(_local_18, _local_11);
                    _local_16 = ((_local_16 * 7613) + 517);
                    _local_1 = null;

                    if (_local_12 == 1)
                    {
                        _local_19 = ((_local_3.x + _local_18.x) + 0.5);
                        _local_21 = ((_local_3.y + _local_11.y) + 0.5);
                        _local_13 = (_local_19 - _local_19);
                        _local_14 = (_local_21 - _local_21);
                        _local_1 = new RoomPlane(_local_20.getLocation(), _local_3, _local_18, _local_11, 2, true, _local_6, _local_16, -(_local_13), -(_local_14));

                        if (_local_4.z != 0)
                        {
                            _local_1.color = 0xFFFFFF;
                        }

                        else
                        {
                            _local_1.color = ((_local_4.x != 0) ? 0xBBBBBB : 0xDDDDDD);
                        };

                        if (_SafeStr_690 != null)
                        {
                            _local_1.rasterizer = _SafeStr_690.floorRasterizer;
                        };
                    }

                    else
                    {
                        if (_local_12 == 2)
                        {
                            _local_1 = new RoomPlane(_local_20.getLocation(), _local_3, _local_18, _local_11, 1, true, _local_6, _local_16);

                            if (((_local_18.length < 1) || (_local_11.length < 1)))
                            {
                                _local_1.hasTexture = false;
                            };

                            if (((_local_4.x == 0) && (_local_4.y == 0)))
                            {
                                _local_1.color = 0x999999;
                            }

                            else
                            {
                                if (_local_4.y > 0)
                                {
                                    _local_1.color = 0xFFFFFF;
                                }

                                else
                                {
                                    if (_local_4.y == 0)
                                    {
                                        _local_1.color = 0xCCCCCC;
                                    }

                                    else
                                    {
                                        _local_1.color = 0x999999;
                                    };
                                };
                            };

                            if (_SafeStr_690 != null)
                            {
                                _local_1.rasterizer = _SafeStr_690.wallRasterizer;
                            };
                        }

                        else
                        {
                            if (_local_12 == 3)
                            {
                                _local_1 = new RoomPlane(_local_20.getLocation(), _local_3, _local_18, _local_11, 3, true, _local_6, _local_16, _local_22, 0, _local_23, _local_17);

                                if (_local_4.y > 0)
                                {
                                    _local_1.color = 0xFFFFFF;
                                }

                                else
                                {
                                    if (_local_4.y == 0)
                                    {
                                        _local_1.color = 0xCCCCCC;
                                    }

                                    else
                                    {
                                        _local_1.color = 0x999999;
                                    };
                                };

                                if (_SafeStr_690 != null)
                                {
                                    _local_1.rasterizer = _SafeStr_690.landscapeRasterizer;
                                };

                                _local_22 = (_local_22 + _local_18.length);
                            }

                            else
                            {
                                if (_local_12 == 4)
                                {
                                    _local_1 = new RoomPlane(_local_20.getLocation(), _local_3, _local_18, _local_11, 1, true, _local_6, _local_16);

                                    if (((_local_18.length < 1) || (_local_11.length < 1)))
                                    {
                                        _local_1.hasTexture = false;
                                    };

                                    if (((_local_4.x == 0) && (_local_4.y == 0)))
                                    {
                                        _local_1.color = 0x999999;
                                    }

                                    else
                                    {
                                        if (_local_4.y > 0)
                                        {
                                            _local_1.color = 0xFFFFFF;
                                        }

                                        else
                                        {
                                            if (_local_4.y == 0)
                                            {
                                                _local_1.color = 0xCCCCCC;
                                            }

                                            else
                                            {
                                                _local_1.color = 0x999999;
                                            };
                                        };
                                    };

                                    if (_SafeStr_690 != null)
                                    {
                                        _local_1.rasterizer = _SafeStr_690.wallAdRasterizr;
                                    };
                                };
                            };
                        };
                    };

                    if (_local_1 != null)
                    {
                        _local_1.maskManager = _SafeStr_690.maskManager;
                        _local_10 = 0;

                        while (_local_10 < _roomPlaneParser.getPlaneMaskCount(_local_8))
                        {
                            _local_5 = _roomPlaneParser.getPlaneMaskLeftSideLoc(_local_8, _local_10);
                            _local_2 = _roomPlaneParser.getPlaneMaskRightSideLoc(_local_8, _local_10);
                            _local_15 = _roomPlaneParser.getPlaneMaskLeftSideLength(_local_8, _local_10);
                            _local_9 = _roomPlaneParser.getPlaneMaskRightSideLength(_local_8, _local_10);
                            _local_1.addRectangleMask(_local_5, _local_2, _local_15, _local_9);
                            _local_10++;
                        };

                        _planes.push(_local_1);
                    };
                }

                else
                {
                    return;
                };

                _local_8++;
            };

            _planesInitialized = true;
            defineSprites();
        }

        private function getLandscapeWidth():Number
        {
            var _local_2:int;
            var _local_3:int;
            var _local_1:IVector3d;
            var _local_4:Number = 0;
            _local_2 = 0;

            while (_local_2 < _roomPlaneParser.planeCount)
            {
                _local_3 = _roomPlaneParser.getPlaneType(_local_2);

                if (_local_3 == 3)
                {
                    _local_1 = _roomPlaneParser.getPlaneLeftSide(_local_2);
                    _local_4 = (_local_4 + _local_1.length);
                };

                _local_2++;
            };

            return (_local_4);
        }

        private function getLandscapeHeight():Number
        {
            var _local_2:int;
            var _local_4:int;
            var _local_3:IVector3d;
            var _local_1:Number = 0;
            _local_2 = 0;

            while (_local_2 < _roomPlaneParser.planeCount)
            {
                _local_4 = _roomPlaneParser.getPlaneType(_local_2);

                if (_local_4 == 3)
                {
                    _local_3 = _roomPlaneParser.getPlaneRightSide(_local_2);

                    if (_local_3.length > _local_1)
                    {
                        _local_1 = _local_3.length;
                    };
                };

                _local_2++;
            };

            if (_local_1 > 5)
            {
                _local_1 = 5;
            };

            return (_local_1);
        }

        override public function update(_arg_1:IRoomGeometry, _arg_2:int, _arg_3:Boolean, _arg_4:Boolean):void
        {
            var _local_8:int;
            var _local_16:int;
            var _local_14:IRoomObjectSprite;
            var _local_5:RoomPlane;
            var _local_7:uint;
            var _local_11:uint;
            var _local_6:uint;
            var _local_10:uint;
            var _local_13:uint;
            var _local_12:IRoomObject = object;

            if (_local_12 == null)
            {
                return;
            };

            if (_arg_1 == null)
            {
                return;
            };

            var _local_9:Boolean = updateGeometry(_arg_1);
            var _local_15:IRoomObjectModel = _local_12.getModel();
            var _local_18:Boolean;

            if (updatePlaneThicknesses(_local_15))
            {
                _local_18 = true;
            };

            if (updateFloorHoles(_local_15))
            {
                _local_18 = true;
            };

            initializeRoomPlanes();
            _local_18 = updateMasksAndColors(_local_15);

            var _local_17:int = _arg_2;

            if ((((_local_17 < (_lastUpdateTime + 250)) && (!(_local_9))) && (!(_local_18))))
            {
                return;
            };

            if (updatePlaneTexturesAndVisibilities(_local_15))
            {
                _local_18 = true;
            };

            if (updatePlanes(_arg_1, _local_9, _arg_2))
            {
                _local_18 = true;
            };

            if (_local_18)
            {
                _local_8 = 0;

                while (_local_8 < _visiblePlanes.length)
                {
                    _local_16 = _visiblePlaneSpriteNumbers[_local_8];
                    _local_14 = getSprite(_local_16);
                    _local_5 = (_visiblePlanes[_local_8] as RoomPlane);

                    if ((((!(_local_14 == null)) && (!(_local_5 == null))) && (!(_local_5.type == 3))))
                    {
                        if (_colorizeBgOnly)
                        {
                            _local_7 = _local_5.color;
                            _local_11 = uint((((_local_7 & 0xFF) * _backgroundBlue) / 0xFF));
                            _local_6 = uint(((((_local_7 >> 8) & 0xFF) * _backgroundGreen) / 0xFF));
                            _local_10 = uint(((((_local_7 >> 16) & 0xFF) * _backgroundRed) / 0xFF));
                            _local_13 = (_local_7 >> 24);
                            _local_7 = ((((_local_13 << 24) + (_local_10 << 16)) + (_local_6 << 8)) + _local_11);
                            _local_14.color = _local_7;
                        }

                        else
                        {
                            _local_14.color = _local_5.color;
                        };
                    };

                    _local_8++;
                };

                increaseUpdateId();
            };

            _SafeStr_3270 = _local_15.getUpdateID();
            _lastUpdateTime = _local_17;
        }

        private function updateGeometry(_arg_1:IRoomGeometry):Boolean
        {
            var _local_2:IVector3d;
            var _local_3:Boolean;

            if (_arg_1.updateId != FLOOR_COLOR)
            {
                FLOOR_COLOR = _arg_1.updateId;
                _boundingRectangle = null;
                _local_2 = _arg_1.direction;

                if (((!(_local_2 == null)) && ((((!(_local_2.x == _geometryDirX)) || (!(_local_2.y == _geometryDirY))) || (!(_local_2.z == _geometryDirZ))) || (!(_arg_1.scale == _geometryScale)))))
                {
                    _geometryDirX = _local_2.x;
                    _geometryDirY = _local_2.y;
                    _geometryDirZ = _local_2.z;
                    _geometryScale = _arg_1.scale;
                    _local_3 = true;
                };
            };

            return (_local_3);
        }

        private function updateMasksAndColors(_arg_1:IRoomObjectModel):Boolean
        {
            var _local_2:String;
            var _local_3:uint;
            var _local_4:Boolean;
            var _local_5:Boolean;

            if (_SafeStr_3270 != _arg_1.getUpdateID())
            {
                _local_2 = _arg_1.getString("room_plane_mask_xml");

                if (_local_2 != _planeMaskData)
                {
                    updatePlaneMasks(_local_2);
                    _planeMaskData = _local_2;
                    _local_5 = true;
                };

                _local_3 = _arg_1.getNumber("room_background_color");

                if (_local_3 != _backgroundColor)
                {
                    _backgroundColor = _local_3;
                    _backgroundBlue = (_backgroundColor & 0xFF);
                    _backgroundGreen = ((_backgroundColor >> 8) & 0xFF);
                    _backgroundRed = ((_backgroundColor >> 16) & 0xFF);
                    _local_5 = true;
                };

                _local_4 = !!_arg_1.getNumber("room_colorize_bg_only");

                if (_local_4 != _colorizeBgOnly)
                {
                    _colorizeBgOnly = _local_4;
                    _local_5 = true;
                };
            };

            return (_local_5);
        }

        private function updatePlaneTexturesAndVisibilities(_arg_1:IRoomObjectModel):Boolean
        {
            var _local_5:String;
            var _local_6:String;
            var _local_2:String;
            var _local_3:Boolean;
            var _local_7:Boolean;
            var _local_4:Boolean;

            if (_SafeStr_3270 != _arg_1.getUpdateID())
            {
                _local_5 = _arg_1.getString("room_wall_type");
                _local_6 = _arg_1.getString("room_floor_type");
                _local_2 = _arg_1.getString("room_landscape_type");
                updatePlaneTextureTypes(_local_6, _local_5, _local_2);
                _local_3 = !!_arg_1.getNumber("room_floor_visibility");
                _local_7 = !!_arg_1.getNumber("room_wall_visibility");
                _local_4 = !!_arg_1.getNumber("room_landscape_visibility");
                updatePlaneTypeVisibilities(_local_3, _local_7, _local_4);
                return (true);
            };

            return (false);
        }

        private function updatePlaneThicknesses(_arg_1:IRoomObjectModel):Boolean
        {
            var _local_3:Number;
            var _local_2:Number;

            if (_SafeStr_3270 != _arg_1.getUpdateID())
            {
                _local_3 = _arg_1.getNumber("room_floor_thickness");
                _local_2 = _arg_1.getNumber("room_wall_thickness");

                if ((((!(isNaN(_local_3))) && (!(isNaN(_local_2)))) && ((!(_local_3 == _floorThicknessMultiplier)) || (!(_local_2 == _wallThicknessMultiplier)))))
                {
                    _floorThicknessMultiplier = _local_3;
                    _wallThicknessMultiplier = _local_2;
                    resetRoomPlanes();
                    return (true);
                };
            };

            return (false);
        }

        private function updateFloorHoles(_arg_1:IRoomObjectModel):Boolean
        {
            var _local_2:Number;

            if (_SafeStr_3270 != _arg_1.getUpdateID())
            {
                _local_2 = _arg_1.getNumber("room_floor_hole_update_time");

                if (((!(isNaN(_local_2))) && (!(_local_2 == _floorHoleUpdateTime))))
                {
                    _floorHoleUpdateTime = _local_2;
                    resetRoomPlanes();
                    return (true);
                };
            };

            return (false);
        }

        protected function updatePlaneTextureTypes(_arg_1:String, _arg_2:String, _arg_3:String):Boolean
        {
            var _local_5:int;
            var _local_4:RoomPlane;

            if (_arg_1 != _floorType)
            {
                _floorType = _arg_1;
            }

            else
            {
                _arg_1 = null;
            };

            if (_arg_2 != _wallType)
            {
                _wallType = _arg_2;
            }

            else
            {
                _arg_2 = null;
            };

            if (_arg_3 != _landscapeType)
            {
                _landscapeType = _arg_3;
            }

            else
            {
                _arg_3 = null;
            };

            if ((((_arg_1 == null) && (_arg_2 == null)) && (_arg_3 == null)))
            {
                return (false);
            };

            _local_5 = 0;

            while (_local_5 < _planes.length)
            {
                _local_4 = (_planes[_local_5] as RoomPlane);

                if (_local_4 != null)
                {
                    if (((_local_4.type == 2) && (!(_arg_1 == null))))
                    {
                        _local_4.id = _arg_1;
                    }

                    else
                    {
                        if (((_local_4.type == 1) && (!(_arg_2 == null))))
                        {
                            _local_4.id = _arg_2;
                        }

                        else
                        {
                            if (((_local_4.type == 3) && (!(_arg_3 == null))))
                            {
                                _local_4.id = _arg_3;
                            };
                        };
                    };
                };

                _local_5++;
            };

            return (true);
        }

        private function updatePlaneTypeVisibilities(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean):void
        {
            if ((((!(_arg_1 == _planeTypeVisibilities[2])) || (!(_arg_2 == _planeTypeVisibilities[1]))) || (!(_arg_3 == _planeTypeVisibilities[3]))))
            {
                _planeTypeVisibilities[2] = _arg_1;
                _planeTypeVisibilities[1] = _arg_2;
                _planeTypeVisibilities[3] = _arg_3;
                _visiblePlanes = [];
                _visiblePlaneSpriteNumbers = [];
            };
        }

        protected function updatePlanes(_arg_1:IRoomGeometry, _arg_2:Boolean, _arg_3:int):Boolean
        {
            var _local_8:int;
            var _local_9:int;
            var _local_12:IRoomObjectSprite;
            var _local_4:RoomPlane;
            var _local_10:Number;
            var _local_13:String;
            var _local_11:IRoomObject = object;

            if (_local_11 == null)
            {
                return (false);
            };

            if (_arg_1 == null)
            {
                return (false);
            };

            _assetUpdateCounter++;

            if (_arg_2)
            {
                _visiblePlanes = [];
                _visiblePlaneSpriteNumbers = [];
            };

            var _local_5:int = _arg_3;
            var _local_6:Array = _visiblePlanes;

            if (_visiblePlanes.length == 0)
            {
                _local_6 = _planes;
            };

            var _local_14:Boolean;
            var _local_7:Boolean = (_visiblePlanes.length > 0);
            _local_8 = 0;

            while (_local_8 < _local_6.length)
            {
                _local_9 = _local_8;

                if (_local_7)
                {
                    _local_9 = _visiblePlaneSpriteNumbers[_local_8];
                };

                _local_12 = getSprite(_local_9);

                if (_local_12 != null)
                {
                    _local_4 = (_local_6[_local_8] as RoomPlane);

                    if (_local_4 != null)
                    {
                        _local_12.planeId = _local_4.uniqueId;

                        if (_local_4.update(_arg_1, _local_5))
                        {
                            if (_local_4.visible)
                            {
                                _local_10 = ((_local_4.relativeDepth + floorRelativeDepth) + (_local_9 / 1000));

                                if (_local_4.type != 2)
                                {
                                    _local_10 = ((_local_4.relativeDepth + wallRelativeDepth) + (_local_9 / 1000));

                                    if (((_local_4.leftSide.length < 1) || (_local_4.rightSide.length < 1)))
                                    {
                                        _local_10 = (_local_10 + (1000 * 0.5));
                                    };
                                };

                                _local_13 = ((("plane " + _local_9) + " ") + _arg_1.scale);
                                updateSprite(_local_12, _local_4, _local_13, _local_10);
                            };

                            _local_14 = true;
                        };

                        if (_local_12.visible != ((_local_4.visible) && (_planeTypeVisibilities[_local_4.type])))
                        {
                            _local_12.visible = (!(_local_12.visible));
                            _local_14 = true;
                        };

                        if (_local_12.visible)
                        {
                            if (!_local_7)
                            {
                                _visiblePlanes.push(_local_4);
                                _visiblePlaneSpriteNumbers.push(_local_8);
                            };
                        };
                    }

                    else
                    {
                        _local_12.planeId = 0;

                        if (_local_12.visible)
                        {
                            _local_12.visible = false;
                            _local_14 = true;
                        };
                    };
                };

                _local_8++;
            };

            return (_local_14);
        }

        private function updateSprite(_arg_1:IRoomObjectSprite, _arg_2:RoomPlane, _arg_3:String, _arg_4:Number):void
        {
            var _local_5:Point = _arg_2.offset;
            _arg_1.offsetX = -(_local_5.x);
            _arg_1.offsetY = -(_local_5.y);
            _arg_1.relativeDepth = _arg_4;
            _arg_1.color = _arg_2.color;
            _arg_1.asset = getPlaneBitmap(_arg_2, _arg_3);
            _arg_1.assetName = ((_arg_3 + "_") + _assetUpdateCounter);
        }

        private function getPlaneBitmap(_arg_1:RoomPlane, _arg_2:String):BitmapData
        {
            var _local_4:BitmapDataAsset = (_assetLibrary.getAssetByName(_arg_2) as BitmapDataAsset);

            if (_local_4 == null)
            {
                _local_4 = new BitmapDataAsset(_assetLibrary.getAssetTypeDeclarationByClass(BitmapDataAsset));
                _assetLibrary.setAsset(_arg_2, _local_4);
            };

            var _local_5:BitmapData = (_local_4.content as BitmapData);
            var _local_3:BitmapData = _arg_1.copyBitmapData(_local_5);

            if (_local_3 == null)
            {
                _local_3 = _arg_1.bitmapData;

                if (_local_3 != null)
                {
                    if (_local_5 != _local_3)
                    {
                        if (_local_5 != null)
                        {
                            _local_5.dispose();
                        };

                        _local_4.setUnknownContent(_local_3);
                    };
                };
            };

            return (_local_3);
        }

        protected function updatePlaneMasks(_arg_1:String):void
        {
            var _local_10:int;
            var _local_11:int;
            var _local_7:String;
            var _local_9:IVector3d;
            var _local_12:String;
            var _local_13:int;
            var _local_18:IVector3d;
            var _local_8:Number;
            var _local_5:Number;
            var _local_3:Number;
            var _local_15:int;
            var _local_4:int;

            if (_arg_1 == null)
            {
                return;
            };

            var _local_17:XML = XML(_arg_1);
            _roomPlaneBitmapMaskParser.initialize(_local_17);

            var _local_2:RoomPlane;
            var _local_14:Array = [];
            var _local_16:Array = [];
            var _local_6:Boolean;
            _local_10 = 0;

            while (_local_10 < _planes.length)
            {
                _local_2 = (_planes[_local_10] as RoomPlane);

                if (_local_2 != null)
                {
                    _local_2.resetBitmapMasks();

                    if (_local_2.type == 3)
                    {
                        _local_14.push(_local_10);
                    };
                };

                _local_10++;
            };

            _local_11 = 0;

            while (_local_11 < _roomPlaneBitmapMaskParser.maskCount)
            {
                _local_7 = _roomPlaneBitmapMaskParser.getMaskType(_local_11);
                _local_9 = _roomPlaneBitmapMaskParser.getMaskLocation(_local_11);
                _local_12 = _roomPlaneBitmapMaskParser.getMaskCategory(_local_11);

                if (_local_9 != null)
                {
                    _local_13 = 0;

                    while (_local_13 < _planes.length)
                    {
                        _local_2 = (_planes[_local_13] as RoomPlane);

                        if (((_local_2.type == 1) || (_local_2.type == 3)))
                        {
                            if ((((!(_local_2 == null)) && (!(_local_2.location == null))) && (!(_local_2.normal == null))))
                            {
                                _local_18 = Vector3d.dif(_local_9, _local_2.location);
                                _local_8 = Math.abs(Vector3d.scalarProjection(_local_18, _local_2.normal));

                                if (_local_8 < 0.01)
                                {
                                    if (((!(_local_2.leftSide == null)) && (!(_local_2.rightSide == null))))
                                    {
                                        _local_5 = Vector3d.scalarProjection(_local_18, _local_2.leftSide);
                                        _local_3 = Vector3d.scalarProjection(_local_18, _local_2.rightSide);

                                        if (((_local_2.type == 1) || ((_local_2.type == 3) && (_local_12 == "hole"))))
                                        {
                                            _local_2.addBitmapMask(_local_7, _local_5, _local_3);
                                        }

                                        else
                                        {
                                            if (_local_2.type == 3)
                                            {
                                                if (!_local_2.canBeVisible)
                                                {
                                                    _local_6 = true;
                                                };

                                                _local_2.canBeVisible = true;
                                                _local_16.push(_local_13);
                                            };
                                        };
                                    };
                                };
                            };
                        };

                        _local_13++;
                    };
                };

                _local_11++;
            };

            _local_15 = 0;

            while (_local_15 < _local_14.length)
            {
                _local_4 = _local_14[_local_15];

                if (_local_16.indexOf(_local_4) < 0)
                {
                    _local_2 = (_planes[_local_4] as RoomPlane);
                    _local_2.canBeVisible = false;
                    _local_6 = true;
                };

                _local_15++;
            };

            if (_local_6)
            {
                _visiblePlanes = [];
                _visiblePlaneSpriteNumbers = [];
            };
        }

        public function get planes():Vector.<IRoomPlane>
        {
            var _local_2:Vector.<IRoomPlane> = new Vector.<IRoomPlane>(0);

            for each (var _local_1:RoomPlane in _visiblePlanes)
            {
                _local_2.push(_local_1);
            };

            return (_local_2);
        }

    }
}