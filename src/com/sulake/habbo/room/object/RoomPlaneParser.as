package com.sulake.habbo.room.object
{
    import com.sulake.core.utils.Map;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.XmlUtil;

    public class RoomPlaneParser 
    {

        private static const FLOOR_THICKNESS:Number = 0.25;
        private static const WALL_THICKNESS:Number = 0.25;
        private static const MAX_WALL_ADDITIONAL_HEIGHT:Number = 20;
        public static const HEIGHTMAP_PADDING_VALUE:int = -110;
        public static const FLOOR_HOLE_BORDER_VALUE:int = -100;

        private var _tileMatrix:Array = [];
        private var _tileMatrixOriginal:Array = [];
        private var _tileMapWidth:int = 0;
        private var _tileMapHeight:int = 0;
        private var _minX:int = 0;
        private var _maxX:int = 0;
        private var _minY:int = 0;
        private var _maxY:int = 0;
        private var _planes:Array = [];
        private var _wallHeight:Number = 0;
        private var _wallThicknessMultiplier:Number = 1;
        private var _floorThicknessMultiplier:Number = 1;
        private var _fixedWallHeight:int = -1;
        private var _floorHeight:Number = 0;
        private var _floorHoles:Map = null;
        private var _floorHoleMatrix:Array = [];

        public function RoomPlaneParser()
        {
            _wallHeight = 3.6;
            _wallThicknessMultiplier = 1;
            _floorThicknessMultiplier = 1;
            _floorHoles = new Map();
        }

        private static function getFloorHeight(heightMap:Array):Number
        {
            var local1:int;
            var local2:int;
            var local3:int;
            var local4:Array;
            var local5:int = heightMap.length;
            var local6:int;

            if (local5 == 0)
            {
                return (0);
            };

            var local7:int = 0;
            local3 = 0;

            while (local3 < local5)
            {
                local4 = (heightMap[local3] as Array);
                local2 = 0;

                while (local2 < local4.length)
                {
                    local1 = local4[local2];

                    if (local1 > local7)
                    {
                        local7 = local1;
                    };

                    local2++;
                };

                local3++;
            };

            return (local7);
        }

        private static function findEntranceTile(heightMap:Array):Point
        {
            if (heightMap == null)
            {
                return (null);
            };

            var local1:int;
            var local2:int;
            var local3:Array;
            var local4:int = heightMap.length;

            if (local4 == 0)
            {
                return (null);
            };

            var local5:Array = [];
            local2 = 0;

            while (local2 < local4)
            {
                local3 = (heightMap[local2] as Array);

                if (((local3 == null) || (local3.length == 0)))
                {
                    return (null);
                };

                local1 = 0;

                while (local1 < local3.length)
                {
                    if (local3[local1] >= 0)
                    {
                        local5.push(local1);
                        break;
                    };

                    local1++;
                };

                if (local5.length < (local2 + 1))
                {
                    local5.push((local3.length + 1));
                };

                local2++;
            };

            local2 = 1;

            while (local2 < (local5.length - 1))
            {
                if (((local5[local2] <= (local5[(local2 - 1)] - 1)) && (local5[local2] <= (local5[(local2 + 1)] - 1))))
                {
                    return (new Point(local5[local2], local2));
                };

                local2++;
            };

            return (null);
        }

        private static function expandFloorTiles(tileMap:Vector.<Vector.<int>>):Vector.<Vector.<int>>
        {
            var local1:int;
            var local2:int;
            var local3:int;
            var local4:int;
            var local5:int;
            var local6:int;
            var local7:int;
            var local8:int;
            var local9:int;
            var local10:int;
            var local11:int;
            var local12:int;
            var local13:uint = tileMap.length;
            var local14:uint = tileMap[0].length;
            var local15:Vector.<Vector.<int>> = new Vector.<Vector.<int>>((local13 * 4));
            local2 = 0;

            while (local2 < (local13 * 4))
            {
                local15[local2] = new Vector.<int>((local14 * 4));
                local2++;
            };

            var local16:int;
            local2 = 0;

            while (local2 < local13)
            {
                local5 = 0;
                local1 = 0;

                while (local1 < local14)
                {
                    local6 = tileMap[local2][local1];

                    if (((local6 < 0) || (local6 <= 0xFF)))
                    {
                        local4 = 0;

                        while (local4 < 4)
                        {
                            local3 = 0;

                            while (local3 < 4)
                            {
                                local15[(local16 + local4)][(local5 + local3)] = ((local6 < 0) ? local6 : (local6 * 4));
                                local3++;
                            };

                            local4++;
                        };
                    }

                    else
                    {
                        local7 = ((local6 & 0xFF) * 4);
                        local8 = (local7 + (((local6 >> 11) & 0x01) * 3));
                        local9 = (local7 + (((local6 >> 10) & 0x01) * 3));
                        local10 = (local7 + (((local6 >> 9) & 0x01) * 3));
                        local11 = (local7 + (((local6 >> 8) & 0x01) * 3));
                        local3 = 0;

                        while (local3 < 3)
                        {
                            local12 = (local3 + 1);
                            local15[local16][(local5 + local3)] = (((local8 * (3 - local3)) + (local9 * local3)) / 3);
                            local15[(local16 + 3)][(local5 + local12)] = (((local10 * (3 - local12)) + (local11 * local12)) / 3);
                            local15[(local16 + local12)][local5] = (((local8 * (3 - local12)) + (local10 * local12)) / 3);
                            local15[(local16 + local3)][(local5 + 3)] = (((local9 * (3 - local3)) + (local11 * local3)) / 3);
                            local3++;
                        };

                        local15[(local16 + 1)][(local5 + 1)] = ((local8 > local7) ? (local7 + 2) : (local7 + 1));
                        local15[(local16 + 1)][(local5 + 2)] = ((local9 > local7) ? (local7 + 2) : (local7 + 1));
                        local15[(local16 + 2)][(local5 + 1)] = ((local10 > local7) ? (local7 + 2) : (local7 + 1));
                        local15[(local16 + 2)][(local5 + 2)] = ((local11 > local7) ? (local7 + 2) : (local7 + 1));
                    };

                    local5 = (local5 + 4);
                    local1++;
                };

                local16 = (local16 + 4);
                local2++;
            };

            return (local15);
        }

        private static function addTileTypes(tileMap:Vector.<Vector.<int>>):void
        {
            var local1:int;
            var local2:int;
            var local3:int;
            var local4:int;
            var local5:int;
            var local6:int;
            var local7:int;
            var local8:int;
            var local9:int;
            var local10:int;
            var local11:int;
            var local12:int;
            var local13:int;
            var local14:int;
            var local15:uint = (tileMap.length - 1);
            var local16:uint = (tileMap[0].length - 1);
            local2 = 1;

            while (local2 < local15)
            {
                local1 = 1;

                while (local1 < local16)
                {
                    local3 = tileMap[local2][local1];

                    if (local3 >= 0)
                    {
                        local4 = (tileMap[(local2 - 1)][(local1 - 1)] & 0xFF);
                        local5 = (tileMap[(local2 - 1)][local1] & 0xFF);
                        local6 = (tileMap[(local2 - 1)][(local1 + 1)] & 0xFF);
                        local7 = (tileMap[local2][(local1 - 1)] & 0xFF);
                        local8 = (tileMap[local2][(local1 + 1)] & 0xFF);
                        local9 = (tileMap[(local2 + 1)][(local1 - 1)] & 0xFF);
                        local10 = (tileMap[(local2 + 1)][local1] & 0xFF);
                        local11 = (tileMap[(local2 + 1)][(local1 + 1)] & 0xFF);
                        local12 = (local3 + 1);
                        local13 = (local3 - 1);
                        local14 = (((((((local4 == local12) || (local5 == local12)) || (local7 == local12)) ? 8 : 0) | ((((local6 == local12) || (local5 == local12)) || (local8 == local12)) ? 4 : 0)) | ((((local9 == local12) || (local10 == local12)) || (local7 == local12)) ? 2 : 0)) | ((((local11 == local12) || (local10 == local12)) || (local8 == local12)) ? 1 : 0));

                        if (local14 == 15)
                        {
                            local14 = 0;
                        };

                        tileMap[local2][local1] = (local3 | (local14 << 8));
                    };

                    local1++;
                };

                local2++;
            };
        }

        private static function unpadHeightMap(tileMap:Vector.<Vector.<int>>):void
        {
            tileMap.shift();
            tileMap.pop();

            for each (var local1:Vector.<int> in tileMap)
            {
                local1.shift();
                local1.pop();
            };
        }

        private static function padHeightMap(tileMap:Vector.<Vector.<int>>):void
        {
            var local1:Vector.<int> = new Vector.<int>(0);
            var local2:Vector.<int> = new Vector.<int>(0);

            for each (var local3:Vector.<int> in tileMap)
            {
                local3.push(-110);
                local3.unshift(-110);
            };

            for each (var local4:int in tileMap[0])
            {
                local1.push(-110);
                local2.push(-110);
            };

            tileMap.push(local2);
            tileMap.unshift(local1);
        }

        public function get minX():int
        {
            return (_minX);
        }

        public function get maxX():int
        {
            return (_maxX);
        }

        public function get minY():int
        {
            return (_minY);
        }

        public function get maxY():int
        {
            return (_maxY);
        }

        public function get tileMapWidth():int
        {
            return (_tileMapWidth);
        }

        public function get tileMapHeight():int
        {
            return (_tileMapHeight);
        }

        public function get planeCount():int
        {
            return (_planes.length);
        }

        public function get floorHeight():Number
        {
            if (_fixedWallHeight != -1)
            {
                return (_fixedWallHeight);
            };

            return (_floorHeight);
        }

        public function get wallHeight():Number
        {
            if (_fixedWallHeight != -1)
            {
                return (_fixedWallHeight + 3.6);
            };

            return (_wallHeight);
        }

        public function set wallHeight(tileMap:Number):void
        {
            if (tileMap < 0)
            {
                tileMap = 0;
            };

            _wallHeight = tileMap;
        }

        public function get wallThicknessMultiplier():Number
        {
            return (_wallThicknessMultiplier);
        }

        public function set wallThicknessMultiplier(tileMap:Number):void
        {
            if (tileMap < 0)
            {
                tileMap = 0;
            };

            _wallThicknessMultiplier = tileMap;
        }

        public function get floorThicknessMultiplier():Number
        {
            return (_floorThicknessMultiplier);
        }

        public function set floorThicknessMultiplier(tileMap:Number):void
        {
            if (tileMap < 0)
            {
                tileMap = 0;
            };

            _floorThicknessMultiplier = tileMap;
        }

        public function dispose():void
        {
            _planes = null;
            _tileMatrix = null;
            _tileMatrixOriginal = null;
            _floorHoleMatrix = null;

            if (_floorHoles != null)
            {
                _floorHoles.dispose();
                _floorHoles = null;
            };
        }

        public function reset():void
        {
            _planes = [];
            _tileMatrix = [];
            _tileMatrixOriginal = [];
            _tileMatrix = [];
            _tileMatrixOriginal = [];
            _tileMapWidth = 0;
            _tileMapHeight = 0;
            _minX = 0;
            _maxX = 0;
            _minY = 0;
            _maxY = 0;
            _floorHeight = 0;
            _floorHoleMatrix = [];
        }

        public function initializeTileMap(width:int, height:int):Boolean
        {
            var local1:int;
            var local2:Array;
            var local3:Array;
            var local4:Array;
            var local5:int;

            if (width < 0)
            {
                width = 0;
            };

            if (height < 0)
            {
                height = 0;
            };

            _tileMatrix = [];
            _tileMatrixOriginal = [];
            _floorHoleMatrix = [];
            local1 = 0;

            while (local1 < height)
            {
                local2 = [];
                local3 = [];
                local4 = [];
                local5 = 0;

                while (local5 < width)
                {
                    local2[local5] = -110;
                    local3[local5] = -110;
                    local4[local5] = false;
                    local5++;
                };

                _tileMatrix.push(local2);
                _tileMatrixOriginal.push(local3);
                _floorHoleMatrix.push(local4);
                local1++;
            };

            _tileMapWidth = width;
            _tileMapHeight = height;
            _minX = _tileMapWidth;
            _maxX = -1;
            _minY = _tileMapHeight;
            _maxY = -1;
            return (true);
        }

        public function setTileHeight(x:int, y:int, height:Number):Boolean
        {
            var local1:Array;
            var local2:Boolean;
            var local3:int;
            var local4:Boolean;
            var local5:int;

            if (((((x >= 0) && (x < _tileMapWidth)) && (y >= 0)) && (y < _tileMapHeight)))
            {
                local1 = (_tileMatrix[y] as Array);
                local1[x] = height;

                if (height >= 0)
                {
                    if (x < _minX)
                    {
                        _minX = x;
                    };

                    if (x > _maxX)
                    {
                        _maxX = x;
                    };

                    if (y < _minY)
                    {
                        _minY = y;
                    };

                    if (y > _maxY)
                    {
                        _maxY = y;
                    };
                }

                else
                {
                    if (((x == _minX) || (x == _maxX)))
                    {
                        local2 = false;
                        local3 = _minY;

                        while (local3 < _maxY)
                        {
                            if (getTileHeightInternal(x, local3) >= 0)
                            {
                                local2 = true;
                                break;
                            };

                            local3++;
                        };

                        if (!local2)
                        {
                            if (x == _minX)
                            {
                                _minX++;
                            };

                            if (x == _maxX)
                            {
                                _maxX--;
                            };
                        };
                    };

                    if (((y == _minY) || (y == _maxY)))
                    {
                        local4 = false;
                        local5 = _minX;

                        while (local5 < _maxX)
                        {
                            if (getTileHeight(local5, y) >= 0)
                            {
                                local4 = true;
                                break;
                            };

                            local5++;
                        };

                        if (!local4)
                        {
                            if (y == _minY)
                            {
                                _minY++;
                            };

                            if (y == _maxY)
                            {
                                _maxY--;
                            };
                        };
                    };
                };

                return (true);
            };

            return (false);
        }

        public function getTileHeight(x:int, y:int):Number
        {
            if (((((x < 0) || (x >= _tileMapWidth)) || (y < 0)) || (y >= _tileMapHeight)))
            {
                return (-110);
            };

            var local1:Array = (_tileMatrix[y] as Array);
            return (Math.abs((local1[x] as Number)));
        }

        private function getTileHeightOriginal(x:int, y:int):Number
        {
            if (((((x < 0) || (x >= _tileMapWidth)) || (y < 0)) || (y >= _tileMapHeight)))
            {
                return (-110);
            };

            if (_floorHoleMatrix[y][x])
            {
                return (-100);
            };

            var local1:Array = (_tileMatrixOriginal[y] as Array);
            return (local1[x] as Number);
        }

        private function getTileHeightInternal(x:int, y:int):Number
        {
            if (((((x < 0) || (x >= _tileMapWidth)) || (y < 0)) || (y >= _tileMapHeight)))
            {
                return (-110);
            };

            var local1:Array = (_tileMatrix[y] as Array);
            return (local1[x] as Number);
        }

        public function initializeFromTileData(fixedWallHeight:int=-1):Boolean
        {
            var local1:int;
            var local2:int;
            _fixedWallHeight = fixedWallHeight;
            local2 = 0;

            while (local2 < _tileMapHeight)
            {
                local1 = 0;

                while (local1 < _tileMapWidth)
                {
                    _tileMatrixOriginal[local2][local1] = _tileMatrix[local2][local1];
                    local1++;
                };

                local2++;
            };

            var local3:Point = findEntranceTile(_tileMatrix);
            local2 = 0;

            while (local2 < _tileMapHeight)
            {
                local1 = 0;

                while (local1 < _tileMapWidth)
                {
                    if (_floorHoleMatrix[local2][local1])
                    {
                        setTileHeight(local1, local2, -100);
                    };

                    local1++;
                };

                local2++;
            };

            return (initialize(local3));
        }

        private function initialize(wallEntrance:Point):Boolean
        {
            var local1:int;

            if (wallEntrance != null)
            {
                local1 = getTileHeight(wallEntrance.x, wallEntrance.y);
                setTileHeight(wallEntrance.x, wallEntrance.y, -110);
            };

            _floorHeight = getFloorHeight(_tileMatrix);
            createWallPlanes();

            var local2:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(0);

            for each (var local3:Array in _tileMatrix)
            {
                local2.push(Vector.<int>(local3));
            };

            padHeightMap(local2);
            addTileTypes(local2);
            unpadHeightMap(local2);

            var local4:Vector.<Vector.<int>> = expandFloorTiles(local2);
            extractPlanes(local4);

            if (wallEntrance != null)
            {
                setTileHeight(wallEntrance.x, wallEntrance.y, local1);
                addFloor(new Vector3d((wallEntrance.x + 0.5), (wallEntrance.y + 0.5), local1), new Vector3d(-1, 0, 0), new Vector3d(0, -1, 0), false, false, false, false);
            };

            return (true);
        }

        private function generateWallData(entrance:Point, includeOuterWalls:Boolean):RoomWallData
        {
            var local1:Boolean;
            var local2:Boolean;
            var local3:int;
            var local4:Point;
            var local5:int;
            var local6:RoomWallData = new RoomWallData();
            var local7:Array = [extractTopWall, extractRightWall, extractBottomWall, extractLeftWall];
            var local8:int;
            var local9:Point = new Point(entrance.x, entrance.y);
            var local10:int;

            while (local10++ < 1000)
            {
                local1 = false;
                local2 = false;
                local3 = local8;

                if (((((local9.x < minX) || (local9.x > maxX)) || (local9.y < minY)) || (local9.y > maxY)))
                {
                    local1 = true;
                };

                local4 = local7[local8](local9, includeOuterWalls);

                if (local4 == null)
                {
                    return (null);
                };

                local5 = (Math.abs((local4.x - local9.x)) + Math.abs((local4.y - local9.y)));

                if (((local9.x == local4.x) || (local9.y == local4.y)))
                {
                    local8 = (((local8 - 1) + local7.length) % local7.length);
                    local5 = (local5 + 1);
                    local2 = true;
                }

                else
                {
                    local8 = ((local8 + 1) % local7.length);
                    local5 = (local5 - 1);
                };

                local6.addWall(local9, local3, local5, local1, local2);

                if ((((local4.x == entrance.x) && (local4.y == entrance.y)) && ((!(local4.x == local9.x)) || (!(local4.y == local9.y))))) break;
                local9 = local4;
            };

            if (local6.count == 0)
            {
                return (null);
            };

            return (local6);
        }

        private function hidePeninsulaWallChains(wallData:RoomWallData):void
        {
            var local1:int;
            var local2:int;
            var local3:int;
            var local4:Boolean;
            var local5:int;
            var local6:int;
            var local7:int = wallData.count;

            while (local6 < local7)
            {
                local1 = local6;
                local2 = local6;
                local3 = 0;
                local4 = false;

                while (((!(wallData.getBorder(local6))) && (local6 < local7)))
                {
                    if (wallData.getLeftTurn(local6))
                    {
                        local3++;
                    }

                    else
                    {
                        if (local3 > 0)
                        {
                            local3--;
                        };
                    };

                    if (local3 > 1)
                    {
                        local4 = true;
                    };

                    local2 = local6;
                    local6++;
                };

                if (local4)
                {
                    local5 = local1;

                    while (local5 <= local2)
                    {
                        wallData.setHideWall(local5, true);
                        local5++;
                    };
                };

                local6++;
            };
        }

        private function updateWallsNextToHoles(wallData:RoomWallData):void
        {
            var local1:int;
            var local2:Point;
            var local3:int;
            var local4:int;
            var local5:IVector3d;
            var local6:IVector3d;
            var local7:int;
            var local8:int;
            var local9:int = wallData.count;
            local1 = 0;

            while (local1 < local9)
            {
                if (!wallData.getHideWall(local1))
                {
                    local2 = wallData.getCorner(local1);
                    local3 = wallData.getDirection(local1);
                    local4 = wallData.getLength(local1);
                    local5 = RoomWallData.WALL_DIRECTION_VECTORS[local3];
                    local6 = RoomWallData.WALL_NORMAL_VECTORS[local3];
                    local7 = 0;
                    local8 = 0;

                    while (local8 < local4)
                    {
                        if (getTileHeightInternal(((local2.x + (local8 * local5.x)) - local6.x), ((local2.y + (local8 * local5.y)) - local6.y)) == -100)
                        {
                            if (((local8 > 0) && (local7 == 0)))
                            {
                                wallData.setLength(local1, local8);
                                break;
                            };

                            local7++;
                        }

                        else
                        {
                            if (local7 > 0)
                            {
                                wallData.moveCorner(local1, local7);
                                break;
                            };
                        };

                        local8++;
                    };

                    if (local7 == local4)
                    {
                        wallData.setHideWall(local1, true);
                    };
                };

                local1++;
            };
        }

        private function resolveOriginalWallIndex(entrance:Point, position:Point, wallData:RoomWallData):int
        {
            var local1:int;
            var local2:Point;
            var local3:Point;
            var local4:int;
            var local5:int;
            var local6:int;
            var local7:int;
            var local8:int = Math.min(entrance.y, position.y);
            var local9:int = Math.max(entrance.y, position.y);
            var local10:int = Math.min(entrance.x, position.x);
            var local11:int = Math.max(entrance.x, position.x);
            var local12:int = wallData.count;
            local1 = 0;

            while (local1 < local12)
            {
                local2 = wallData.getCorner(local1);
                local3 = wallData.getEndPoint(local1);

                if (entrance.x == position.x)
                {
                    if (((local2.x == entrance.x) && (local3.x == entrance.x)))
                    {
                        local4 = Math.min(local2.y, local3.y);
                        local5 = Math.max(local2.y, local3.y);

                        if (((local4 <= local8) && (local9 <= local5)))
                        {
                            return (local1);
                        };
                    };
                }

                else
                {
                    if (entrance.y == position.y)
                    {
                        if (((local2.y == entrance.y) && (local3.y == entrance.y)))
                        {
                            local6 = Math.min(local2.x, local3.x);
                            local7 = Math.max(local2.x, local3.x);

                            if (((local6 <= local10) && (local11 <= local7)))
                            {
                                return (local1);
                            };
                        };
                    };
                };

                local1++;
            };

            return (-1);
        }

        private function hideOriginallyHiddenWalls(sourceWallData:RoomWallData, previousWallData:RoomWallData):void
        {
            var local1:int;
            var local2:Point;
            var local3:Point;
            var local4:IVector3d;
            var local5:int;
            var local6:int;
            var local7:int = sourceWallData.count;
            local1 = 0;

            while (local1 < local7)
            {
                if (!sourceWallData.getHideWall(local1))
                {
                    local2 = sourceWallData.getCorner(local1);
                    local3 = new Point(local2.x, local2.y);
                    local4 = RoomWallData.WALL_DIRECTION_VECTORS[sourceWallData.getDirection(local1)];
                    local5 = sourceWallData.getLength(local1);
                    local3.x = (local3.x + (local4.x * local5));
                    local3.y = (local3.y + (local4.y * local5));
                    local6 = resolveOriginalWallIndex(local2, local3, previousWallData);

                    if (local6 >= 0)
                    {
                        if (previousWallData.getHideWall(local6))
                        {
                            sourceWallData.setHideWall(local1, true);
                        };
                    }

                    else
                    {
                        sourceWallData.setHideWall(local1, true);
                    };
                };

                local1++;
            };
        }

        private function checkWallHiding(currentWallData:RoomWallData, previousWallData:RoomWallData):void
        {
            hidePeninsulaWallChains(previousWallData);
            updateWallsNextToHoles(currentWallData);
            hideOriginallyHiddenWalls(currentWallData, previousWallData);
        }

        private function addWalls(currentWallData:RoomWallData, previousWallData:RoomWallData):void
        {
            var local1:int;
            var local2:int;
            var local3:int;
            var local4:Point;
            var local5:int;
            var local6:int;
            var local7:IVector3d;
            var local8:IVector3d;
            var local9:Number;
            var local10:int;
            var local11:Number;
            var local12:Number;
            var local13:Vector3d;
            var local14:Number;
            var local15:Vector3d;
            var local16:Vector3d;
            var local17:int;
            var local18:Vector3d;
            var local19:Boolean;
            var local20:Boolean;
            var local21:Boolean;
            var local22:Boolean;
            var local23:Boolean;
            var local24:int = currentWallData.count;
            var local25:int = previousWallData.count;
            local3 = 0;

            while (local3 < local24)
            {
                if (!currentWallData.getHideWall(local3))
                {
                    local4 = currentWallData.getCorner(local3);
                    local5 = currentWallData.getDirection(local3);
                    local6 = currentWallData.getLength(local3);
                    local7 = RoomWallData.WALL_DIRECTION_VECTORS[local5];
                    local8 = RoomWallData.WALL_NORMAL_VECTORS[local5];
                    local9 = -1;
                    local10 = 0;

                    while (local10 < local6)
                    {
                        local11 = getTileHeightInternal(((local4.x + (local10 * local7.x)) + local8.x), ((local4.y + (local10 * local7.y)) + local8.y));

                        if (((local11 >= 0) && ((local11 < local9) || (local9 < 0))))
                        {
                            local9 = local11;
                        };

                        local10++;
                    };

                    local12 = local9;
                    local13 = new Vector3d(local4.x, local4.y, local12);
                    local13 = Vector3d.sum(local13, Vector3d.product(local8, 0.5));
                    local13 = Vector3d.sum(local13, Vector3d.product(local7, -0.5));
                    local14 = ((wallHeight + Math.min(20, floorHeight)) - local9);
                    local15 = Vector3d.product(local7, -(local6));
                    local16 = new Vector3d(0, 0, local14);
                    local13 = Vector3d.dif(local13, local15);
                    local17 = resolveOriginalWallIndex(local4, currentWallData.getEndPoint(local3), previousWallData);

                    if (local17 >= 0)
                    {
                        local1 = previousWallData.getDirection(((local17 + 1) % local25));
                        local2 = previousWallData.getDirection((((local17 - 1) + local25) % local25));
                    }

                    else
                    {
                        local1 = currentWallData.getDirection(((local3 + 1) % local24));
                        local2 = currentWallData.getDirection((((local3 - 1) + local24) % local24));
                    };

                    local18 = null;

                    if ((((local1 - local5) + 4) % 4) == 3)
                    {
                        local18 = RoomWallData.WALL_NORMAL_VECTORS[local1];
                    }

                    else
                    {
                        if ((((local5 - local2) + 4) % 4) == 3)
                        {
                            local18 = RoomWallData.WALL_NORMAL_VECTORS[local2];
                        };
                    };

                    local19 = currentWallData.getLeftTurn(local3);
                    local20 = currentWallData.getLeftTurn((((local3 - 1) + local24) % local24));
                    local21 = currentWallData.getHideWall(((local3 + 1) % local24));
                    local22 = currentWallData.getManuallyLeftCut(local3);
                    local23 = currentWallData.getManuallyRightCut(local3);
                    addWall(local13, local15, local16, local18, ((!(local20)) || (local22)), ((!(local19)) || (local23)), (!(local21)));
                };

                local3++;
            };
        }

        private function createWallPlanes():Boolean
        {
            var local1:int;
            var local2:int;
            var local3:Array = _tileMatrix;

            if (local3 == null)
            {
                return (false);
            };

            var local4:int;
            var local5:int;
            var local6:Array;
            var local7:int = local3.length;
            var local8:int;

            if (local7 == 0)
            {
                return (false);
            };

            local4 = 0;

            while (local4 < local7)
            {
                local6 = (local3[local4] as Array);

                if (((local6 == null) || (local6.length == 0)))
                {
                    return (false);
                };

                if (local8 > 0)
                {
                    local8 = Math.min(local8, local6.length);
                }

                else
                {
                    local8 = local6.length;
                };

                local4++;
            };

            var local9:Number = Math.min(20, ((_fixedWallHeight != -1) ? _fixedWallHeight : getFloorHeight(local3)));
            var local10:int = minX;
            var local11:int = minY;
            local11 = minY;

            while (local11 <= maxY)
            {
                if (getTileHeightInternal(local10, local11) > -100)
                {
                    local11--;
                    break;
                };

                local11++;
            };

            if (local11 > maxY)
            {
                return (false);
            };

            var local12:Point = new Point(local10, local11);
            var local13:RoomWallData = generateWallData(local12, true);
            var local14:RoomWallData = generateWallData(local12, false);

            if (local13 != null)
            {
                local1 = local13.count;
                local2 = local14.count;
                checkWallHiding(local13, local14);
                addWalls(local13, local14);
            };

            local5 = 0;

            while (local5 < tileMapHeight)
            {
                local4 = 0;

                while (local4 < tileMapWidth)
                {
                    if (getTileHeightInternal(local4, local5) < 0)
                    {
                        setTileHeight(local4, local5, -(local9 + wallHeight));
                    };

                    local4++;
                };

                local5++;
            };

            return (true);
        }

        private function extractTopWall(startPoint:Point, skip:Boolean):Point
        {
            if (startPoint == null)
            {
                return (null);
            };

            var local1:int = 1;
            var local2:int = -100;

            if (!skip)
            {
                local2 = -110;
            };

            while (local1 < 1000)
            {
                if (getTileHeightInternal((startPoint.x + local1), startPoint.y) > local2)
                {
                    return (new Point(((startPoint.x + local1) - 1), startPoint.y));
                };

                if (getTileHeightInternal((startPoint.x + local1), (startPoint.y + 1)) <= local2)
                {
                    return (new Point((startPoint.x + local1), (startPoint.y + 1)));
                };

                local1++;
            };

            return (null);
        }

        private function extractRightWall(startPoint:Point, skip:Boolean):Point
        {
            if (startPoint == null)
            {
                return (null);
            };

            var local1:int = 1;
            var local2:int = -100;

            if (!skip)
            {
                local2 = -110;
            };

            while (local1 < 1000)
            {
                if (getTileHeightInternal(startPoint.x, (startPoint.y + local1)) > local2)
                {
                    return (new Point(startPoint.x, (startPoint.y + (local1 - 1))));
                };

                if (getTileHeightInternal((startPoint.x - 1), (startPoint.y + local1)) <= local2)
                {
                    return (new Point((startPoint.x - 1), (startPoint.y + local1)));
                };

                local1++;
            };

            return (null);
        }

        private function extractBottomWall(startPoint:Point, skip:Boolean):Point
        {
            if (startPoint == null)
            {
                return (null);
            };

            var local1:int = 1;
            var local2:int = -100;

            if (!skip)
            {
                local2 = -110;
            };

            while (local1 < 1000)
            {
                if (getTileHeightInternal((startPoint.x - local1), startPoint.y) > local2)
                {
                    return (new Point((startPoint.x - (local1 - 1)), startPoint.y));
                };

                if (getTileHeightInternal((startPoint.x - local1), (startPoint.y - 1)) <= local2)
                {
                    return (new Point((startPoint.x - local1), (startPoint.y - 1)));
                };

                local1++;
            };

            return (null);
        }

        private function extractLeftWall(startPoint:Point, skip:Boolean):Point
        {
            if (startPoint == null)
            {
                return (null);
            };

            var local1:int = 1;
            var local2:int = -100;

            if (!skip)
            {
                local2 = -110;
            };

            while (local1 < 1000)
            {
                if (getTileHeightInternal(startPoint.x, (startPoint.y - local1)) > local2)
                {
                    return (new Point(startPoint.x, (startPoint.y - (local1 - 1))));
                };

                if (getTileHeightInternal((startPoint.x + 1), (startPoint.y - local1)) <= local2)
                {
                    return (new Point((startPoint.x + 1), (startPoint.y - local1)));
                };

                local1++;
            };

            return (null);
        }

        private function addWall(origin:IVector3d, leftSide:IVector3d, rightSide:IVector3d, normalDirection:IVector3d, keepLeft:Boolean, keepRight:Boolean, keepBottom:Boolean):void
        {
            var local1:Vector3d;
            addPlane(2, origin, leftSide, rightSide, [normalDirection]);
            addPlane(3, origin, leftSide, rightSide, [normalDirection]);

            var local2:Number = (0.25 * _wallThicknessMultiplier);
            var local3:Number = (0.25 * _floorThicknessMultiplier);
            var local4:Vector3d = Vector3d.crossProduct(leftSide, rightSide);
            var local5:Vector3d = Vector3d.product(local4, ((1 / local4.length) * -(local2)));
            addPlane(2, Vector3d.sum(origin, rightSide), leftSide, local5, [local4, normalDirection]);

            if (keepLeft)
            {
                addPlane(2, Vector3d.sum(Vector3d.sum(origin, leftSide), rightSide), Vector3d.product(rightSide, (-(rightSide.length + local3) / rightSide.length)), local5, [local4, normalDirection]);
            };

            if (keepRight)
            {
                addPlane(2, Vector3d.sum(origin, Vector3d.product(rightSide, (-(local3) / rightSide.length))), Vector3d.product(rightSide, ((rightSide.length + local3) / rightSide.length)), local5, [local4, normalDirection]);

                if (keepBottom)
                {
                    local1 = Vector3d.product(leftSide, (local2 / leftSide.length));
                    addPlane(2, Vector3d.sum(Vector3d.sum(origin, rightSide), Vector3d.product(local1, -1)), local1, local5, [local4, leftSide, normalDirection]);
                };
            };
        }

        private function addFloor(origin:IVector3d, leftSide:IVector3d, rightSide:IVector3d, addTop:Boolean, addRight:Boolean, addBottom:Boolean, addLeft:Boolean):void
        {
            var local1:Number;
            var local2:Vector3d;
            var local3:Vector3d;
            var local4:RoomPlaneData = addPlane(1, origin, leftSide, rightSide);

            if (local4 != null)
            {
                local1 = (0.25 * _floorThicknessMultiplier);
                local2 = new Vector3d(0, 0, local1);
                local3 = Vector3d.dif(origin, local2);

                if (addBottom)
                {
                    addPlane(1, local3, leftSide, local2);
                };

                if (addLeft)
                {
                    addPlane(1, Vector3d.sum(local3, Vector3d.sum(leftSide, rightSide)), Vector3d.product(leftSide, -1), local2);
                };

                if (addTop)
                {
                    addPlane(1, Vector3d.sum(local3, rightSide), Vector3d.product(rightSide, -1), local2);
                };

                if (addRight)
                {
                    addPlane(1, Vector3d.sum(local3, leftSide), rightSide, local2);
                };
            };
        }

        public function initializeFromXML(xml:XML):Boolean
        {
            var local1:int;
            var local2:XML;
            var local3:XMLList;
            var local4:int;
            var local5:XML;
            var local6:Number;
            var local7:XML;
            var local8:XMLList;
            var local9:int;
            var local10:XML;

            if (xml == null)
            {
                return (false);
            };

            reset();
            resetFloorHoles();

            if (!XmlUtil.checkRequiredAttributes(xml.tileMap[0], ["width", "height", "wallHeight"]))
            {
                return (false);
            };

            var local11:int = parseInt(xml.tileMap.@width);
            var local12:int = parseInt(xml.tileMap.@height);
            var local13:Number = parseFloat(xml.tileMap.@wallHeight);
            var local14:int = parseInt(xml.tileMap.@fixedWallsHeight);
            initializeTileMap(local11, local12);

            var local15:XMLList = xml.tileMap.tileRow;
            local1 = 0;

            while (local1 < local15.length())
            {
                local2 = local15[local1];
                local3 = local2.tile;
                local4 = 0;

                while (local4 < local3.length())
                {
                    local5 = local3[local4];
                    local6 = parseFloat(local5.@height);
                    setTileHeight(local4, local1, local6);
                    local4++;
                };

                local1++;
            };

            if (xml.holeMap.length() > 0)
            {
                local7 = xml.holeMap[0];
                local8 = local7.hole;
                local9 = 0;

                while (local9 < local8.length())
                {
                    local10 = local8[local9];

                    if (XmlUtil.checkRequiredAttributes(local10, ["id", "x", "y", "width", "height"]))
                    {
                        addFloorHole(local10.@id, local10.@x, local10.@y, local10.@width, local10.@height);
                    };

                    local9++;
                };

                initializeHoleMap();
            };

            this.wallHeight = local13;
            initializeFromTileData(local14);
            return (true);
        }

        private function addPlane(type:int, origin:IVector3d, leftSide:IVector3d, rightSide:IVector3d, secondaryNormals:Array=null):RoomPlaneData
        {
            if (((leftSide.length == 0) || (rightSide.length == 0)))
            {
                return (null);
            };

            var local1:RoomPlaneData = new RoomPlaneData(type, origin, leftSide, rightSide, secondaryNormals);
            _planes.push(local1);
            return (local1);
        }

        public function getXML():XML
        {
            var local1:int;
            var local2:XML;
            var local3:Array;
            var local4:int;
            var local5:Number;
            var local6:XML;
            var local7:int;
            var local8:RoomFloorHole;
            var local9:int;
            var local10:XML;
            var local11:XML = new XML((((((((("<tileMap width=" + (('"' + _tileMapWidth) + '"')) + " height=") + (('"' + _tileMapHeight) + '"')) + " wallHeight=") + (('"' + _wallHeight) + '"')) + " fixedWallsHeight=") + (('"' + _fixedWallHeight) + '"')) + "/>\r\n\t\t\t"));
            local1 = 0;

            while (local1 < _tileMapHeight)
            {
                local2 = <tileRow/>
				
                ;
                local3 = _tileMatrixOriginal[local1];
                local4 = 0;

                while (local4 < _tileMapWidth)
                {
                    local5 = local3[local4];
                    local6 = new XML((("<tile height=" + (('"' + local5) + '"')) + "/>\r\n\t\t\t\t\t"));
                    local2.appendChild(local6);
                    local4++;
                };

                local11.appendChild(local2);
                local1++;
            };

            var local12:XML = <holeMap/>
			
            ;
            local7 = 0;

            while (local7 < _floorHoles.length)
            {
                local8 = _floorHoles.getWithIndex(local7);

                if (local8 != null)
                {
                    local9 = _floorHoles.getKey(local7);
                    local10 = new XML((((((((((("<hole id=" + (('"' + local9) + '"')) + " x=") + (('"' + local8.x) + '"')) + " y=") + (('"' + local8.y) + '"')) + " width=") + (('"' + local8.width) + '"')) + " height=") + (('"' + local8.height) + '"')) + "/>\r\n\t\t\t\t\t"));
                    local12.appendChild(local10);
                };

                local7++;
            };

            var local13:XML = <roomData/>
			
            ;
            local13.appendChild(local11);
            local13.appendChild(local12);

            var local14:XML = new XML((((((((("<dimensions minX=" + (('"' + minX) + '"')) + " maxX=") + (('"' + maxX) + '"')) + " minY=") + (('"' + minY) + '"')) + " maxY=") + (('"' + maxY) + '"')) + " />\r\n\t\t\t"));
            local13.appendChild(local14);
            return (local13);
        }

        public function getPlaneLocation(planeIndex:int):IVector3d
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (null);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.loc);
            };

            return (null);
        }

        public function getPlaneNormal(planeIndex:int):IVector3d
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (null);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.normal);
            };

            return (null);
        }

        public function getPlaneLeftSide(planeIndex:int):IVector3d
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (null);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.leftSide);
            };

            return (null);
        }

        public function getPlaneRightSide(planeIndex:int):IVector3d
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (null);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.rightSide);
            };

            return (null);
        }

        public function getPlaneNormalDirection(planeIndex:int):IVector3d
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (null);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.normalDirection);
            };

            return (null);
        }

        public function getPlaneSecondaryNormals(planeIndex:int):Array
        {
            var local1:Array;
            var local2:int;

            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (null);
            };

            var local3:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local3 != null)
            {
                local1 = [];
                local2 = 0;

                while (local2 < local3.secondaryNormalCount)
                {
                    local1.push(local3.getSecondaryNormal(local2));
                    local2++;
                };

                return (local1);
            };

            return (null);
        }

        public function getPlaneType(planeIndex:int):int
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (0);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.type);
            };

            return (0);
        }

        public function getPlaneMaskCount(planeIndex:int):int
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (0);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.maskCount);
            };

            return (0);
        }

        public function getPlaneMaskLeftSideLoc(planeIndex:int, maskIndex:int):Number
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (-1);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.getMaskLeftSideLoc(maskIndex));
            };

            return (-1);
        }

        public function getPlaneMaskRightSideLoc(planeIndex:int, maskIndex:int):Number
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (-1);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.getMaskRightSideLoc(maskIndex));
            };

            return (-1);
        }

        public function getPlaneMaskLeftSideLength(planeIndex:int, maskIndex:int):Number
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (-1);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.getMaskLeftSideLength(maskIndex));
            };

            return (-1);
        }

        public function getPlaneMaskRightSideLength(planeIndex:int, maskIndex:int):Number
        {
            if (((planeIndex < 0) || (planeIndex >= planeCount)))
            {
                return (-1);
            };

            var local1:RoomPlaneData = (_planes[planeIndex] as RoomPlaneData);

            if (local1 != null)
            {
                return (local1.getMaskRightSideLength(maskIndex));
            };

            return (-1);
        }

        public function addFloorHole(holeId:int, x:int, y:int, width:int, height:int):void
        {
            removeFloorHole(holeId);

            var local1:RoomFloorHole = new RoomFloorHole(x, y, width, height);
            _floorHoles.add(holeId, local1);
        }

        public function removeFloorHole(holeId:int):void
        {
            _floorHoles.remove(holeId);
        }

        public function resetFloorHoles():void
        {
            _floorHoles.reset();
        }

        private function initializeHoleMap():void
        {
            var local1:int;
            var local2:int;
            var local3:Array;
            var local4:int;
            var local5:RoomFloorHole;
            var local6:int;
            var local7:int;
            var local8:int;
            var local9:int;
            local2 = 0;

            while (local2 < _tileMapHeight)
            {
                local3 = _floorHoleMatrix[local2];
                local1 = 0;

                while (local1 < _tileMapWidth)
                {
                    local3[local1] = false;
                    local1++;
                };

                local2++;
            };

            local4 = 0;

            while (local4 < _floorHoles.length)
            {
                local5 = _floorHoles.getWithIndex(local4);

                if (local5 != null)
                {
                    local6 = local5.x;
                    local7 = ((local5.x + local5.width) - 1);
                    local8 = local5.y;
                    local9 = ((local5.y + local5.height) - 1);
                    local6 = ((local6 < 0) ? 0 : local6);
                    local7 = ((local7 >= _tileMapWidth) ? (_tileMapWidth - 1) : local7);
                    local8 = ((local8 < 0) ? 0 : local8);
                    local9 = ((local9 >= _tileMapHeight) ? (_tileMapHeight - 1) : local9);
                    local2 = local8;

                    while (local2 <= local9)
                    {
                        local3 = _floorHoleMatrix[local2];
                        local1 = local6;

                        while (local1 <= local7)
                        {
                            local3[local1] = true;
                            local1++;
                        };

                        local2++;
                    };
                };

                local4++;
            };
        }

        private function extractPlanes(tileMap:Vector.<Vector.<int>>):void
        {
            var local1:int;
            var local2:int;
            var local3:int;
            var local4:int;
            var local5:int;
            var local6:int;
            var local7:Boolean;
            var local8:Boolean;
            var local9:Boolean;
            var local10:Boolean;
            var local11:int;
            var local12:int;
            var local13:Boolean;
            var local14:Number;
            var local15:Number;
            var local16:Number;
            var local17:Number;
            var local18:uint = tileMap.length;
            var local19:uint = tileMap[0].length;
            var local20:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>(local18);
            local1 = 0;

            while (local1 < local18)
            {
                local20[local1] = new Vector.<Boolean>(local19);
                local1++;
            };

            local2 = 0;

            while (local2 < local18)
            {
                local3 = 0;

                while (local3 < local19)
                {
                    local4 = tileMap[local2][local3];

                    if (!((local4 < 0) || (local20[local2][local3])))
                    {
                        local7 = ((local3 == 0) || (!(tileMap[local2][(local3 - 1)] == local4)));
                        local8 = ((local2 == 0) || (!(tileMap[(local2 - 1)][local3] == local4)));
                        local5 = (local3 + 1);

                        while (local5 < local19)
                        {
                            if ((((!(tileMap[local2][local5] == local4)) || (local20[local2][local5])) || ((local2 > 0) && ((tileMap[(local2 - 1)][local5] == local4) == local8)))) break;
                            local5++;
                        };

                        local9 = ((local5 == local19) || (!(tileMap[local2][local5] == local4)));
                        local13 = false;
                        local6 = (local2 + 1);

                        while (((local6 < local18) && (!(local13))))
                        {
                            local10 = (!(tileMap[local6][local3] == local4));
                            local13 = (((local10) || ((local3 > 0) && ((tileMap[local6][(local3 - 1)] == local4) == local7))) || ((local5 < local19) && ((tileMap[local6][local5] == local4) == local9)));
                            local11 = local3;

                            while (local11 < local5)
                            {
                                if ((tileMap[local6][local11] == local4) == local10)
                                {
                                    local13 = true;
                                    local5 = local11;
                                    break;
                                };

                                local11++;
                            };

                            if (local13) break;
                            local6++;
                        };

                        if (!local10)
                        {
                            local10 = (local6 == local18);
                        };

                        local9 = ((local5 == local19) || (!(tileMap[local2][local5] == local4)));
                        local12 = local2;

                        while (local12 < local6)
                        {
                            local11 = local3;

                            while (local11 < local5)
                            {
                                local20[local12][local11] = true;
                                local11++;
                            };

                            local12++;
                        };

                        local14 = ((local3 / 4) - 0.5);
                        local15 = ((local2 / 4) - 0.5);
                        local16 = ((local5 - local3) / 4);
                        local17 = ((local6 - local2) / 4);
                        addFloor(new Vector3d((local14 + local16), (local15 + local17), (local4 / 4)), new Vector3d(-(local16), 0, 0), new Vector3d(0, -(local17), 0), local9, local7, local10, local8);
                    };

                    local3++;
                };

                local2++;
            };
        }

    }
}





