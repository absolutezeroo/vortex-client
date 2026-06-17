package com.sulake.room.object.visualization
{
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class RoomObjectSpriteVisualization implements IRoomObjectSpriteVisualization
    {

        protected static const ICON_LAYER_PREFIX:String = "_";
        protected static const ICON_LAYER_ID:String = "_icon_";

        private static var _nextInstanceId:int = 0;

        private var _layersInUse:Array;
        private var _object:IRoomObject;
        private var _assetCollection:IGraphicAssetCollection;
        protected var _cachedImageLeft:int = -1;
        protected var _cachedImageTop:int = -1;
        protected var _cachedLayerCount:int = -1;
        private var _instanceId:int = 0;
        private var _updateID:int = 0;

        public function RoomObjectSpriteVisualization()
        {
            _instanceId = _nextInstanceId++;
            _layersInUse = [];
            _object = null;
            _assetCollection = null;
        }

        public function dispose():void
        {
            var sprite:RoomObjectSprite;

            if (_layersInUse != null)
            {
                while (_layersInUse.length > 0)
                {
                    sprite = (_layersInUse[0] as RoomObjectSprite);

                    if (sprite != null)
                    {
                        sprite.dispose();
                    };

                    _layersInUse.pop();
                };

                _layersInUse = null;
            };

            _object = null;
            assetCollection = null;
        }

        public function set assetCollection(collection:IGraphicAssetCollection):void
        {
            if (_assetCollection != null)
            {
                _assetCollection.removeReference();
            };

            _assetCollection = collection;

            if (_assetCollection != null)
            {
                _assetCollection.addReference();
            };
        }

        public function setExternalBaseUrls(imageBaseUrl:String, extraDataBaseUrl:String, useExtraDataBatches:Boolean):void
        {
        }

        public function get assetCollection():IGraphicAssetCollection
        {
            return (_assetCollection);
        }

        public function getUpdateID():int
        {
            return (_updateID);
        }

        public function getInstanceId():int
        {
            return (_instanceId);
        }

        protected function createSprites(spriteCount:int):void
        {
            var sprite:RoomObjectSprite;

            while (_layersInUse.length > spriteCount)
            {
                sprite = (_layersInUse[(_layersInUse.length - 1)] as RoomObjectSprite);

                if (sprite != null)
                {
                    sprite.dispose();
                };

                _layersInUse.pop();
            };

            while (_layersInUse.length < spriteCount)
            {
                sprite = new RoomObjectSprite();
                _layersInUse.push(sprite);
            };
        }

        public function addSprite():IRoomObjectSprite
        {
            return (addSpriteAt(_layersInUse.length));
        }

        public function addSpriteAt(index:int):IRoomObjectSprite
        {
            var sprite:IRoomObjectSprite = new RoomObjectSprite();

            if (index >= _layersInUse.length)
            {
                _layersInUse.push(sprite);
            }

            else
            {
                _layersInUse.splice(index, 0, sprite);
            };

            return (sprite);
        }

        public function removeSprite(sprite:IRoomObjectSprite):void
        {
            var spriteIndex:int = _layersInUse.indexOf(sprite);

            if (spriteIndex == -1)
            {
                throw (new Error("Trying to remove non-existing sprite!"));
            };

            _layersInUse.splice(spriteIndex, 1);
            RoomObjectSprite(sprite).dispose();
        }

        public function get spriteCount():int
        {
            return (_layersInUse.length);
        }

        public function getSprite(index:int):IRoomObjectSprite
        {
            if (((index >= 0) && (index < _layersInUse.length)))
            {
                return (_layersInUse[index]);
            };

            return (null);
        }

        public function get object():IRoomObject
        {
            return (_object);
        }

        public function set object(roomObject:IRoomObject):void
        {
            _object = roomObject;
        }

        public function update(roomGeometry:IRoomGeometry, timeSinceLastUpdate:int, hasAnimation:Boolean, update:Boolean):void
        {
        }

        protected function increaseUpdateId():void
        {
            _updateID++;
        }

        protected function reset():void
        {
            _cachedImageLeft = 0xFFFFFFFF;
            _cachedImageTop = 0xFFFFFFFF;
            _cachedLayerCount = -1;
        }

        public function getSpriteList():Array
        {
            return (null);
        }

        public function initialize(data:IRoomObjectVisualizationData):Boolean
        {
            return (false);
        }

        public function get image():BitmapData
        {
            return (getImage(0, -1));
        }

        public function getImage(bgColor:int, originalId:int):BitmapData
        {
            var spriteColor:Number;
            var redChannel:Number;
            var greenChannel:Number;
            var blueChannel:Number;
            var spriteAlphaMultiplier:Number;
            var depth:Number;
            var sprite:IRoomObjectSprite;
            var colorTransform:ColorTransform;
            var drawMatrix:Matrix;
            var spriteRectangle:Rectangle = boundingRectangle;

            if ((spriteRectangle.width * spriteRectangle.height) == 0)
            {
                return (null);
            };

            var spriteTotal:int = spriteCount;
            var drawnSprite:IRoomObjectSprite;
            var orderedSprites:Array = [];
            var spriteIndex:int;
            var currentBitmap:BitmapData;
            spriteIndex = 0;

            while (spriteIndex < spriteTotal)
            {
                drawnSprite = getSprite(spriteIndex);

                if (((!(drawnSprite == null)) && (drawnSprite.visible)))
                {
                    currentBitmap = drawnSprite.asset;

                    if (currentBitmap != null)
                    {
                        orderedSprites.push(drawnSprite);
                    };
                };

                spriteIndex++;
            };

            orderedSprites.sortOn("relativeDepth", 16);
            orderedSprites.reverse();

            var output:BitmapData;
            try
            {
                output = new BitmapData(spriteRectangle.width, spriteRectangle.height, true, bgColor);
            }
            catch (e:ArgumentError)
            {
                Logger.log(("Unable to create BitmapData object! " + e));
            };

            if (!output)
            {
                return (new BitmapData(1, 1, true));
            };

            spriteIndex = 0;
            while (spriteIndex < orderedSprites.length)
            {
                drawnSprite = (orderedSprites[spriteIndex] as IRoomObjectSprite);
                currentBitmap = drawnSprite.asset;

                if (currentBitmap != null)
                {
                    spriteColor = drawnSprite.color;
                    redChannel = ((spriteColor >> 16) & 0xFF);
                    greenChannel = ((spriteColor >> 8) & 0xFF);
                    blueChannel = (spriteColor & 0xFF);
                    colorTransform = null;

                    if ((((redChannel < 0xFF) || (greenChannel < 0xFF)) || (blueChannel < 0xFF)))
                    {
                        redChannel = (redChannel / 0xFF);
                        greenChannel = (greenChannel / 0xFF);
                        spriteAlphaMultiplier = (blueChannel / 0xFF);
                        depth = (drawnSprite.alpha / 0xFF);
                        colorTransform = new ColorTransform(redChannel, greenChannel, spriteAlphaMultiplier, depth);
                    }
                    else
                    {
                        if (drawnSprite.alpha < 0xFF)
                        {
                            colorTransform = new ColorTransform(1, 1, 1, (drawnSprite.alpha / 0xFF));
                        };
                    };

                    drawMatrix = new Matrix();

                    if (drawnSprite.flipH)
                    {
                        drawMatrix.scale(-1, 1);
                        drawMatrix.translate(currentBitmap.width, 0);
                    };

                    if (drawnSprite.flipV)
                    {
                        drawMatrix.scale(1, -1);
                        drawMatrix.translate(0, currentBitmap.height);
                    };

                    drawMatrix.translate((drawnSprite.offsetX - spriteRectangle.left), (drawnSprite.offsetY - spriteRectangle.top));
                    output.draw(currentBitmap, drawMatrix, colorTransform, drawnSprite.blendMode, null, false);
                };

                spriteIndex++;
            };

            return (output);
        }

        public function get boundingRectangle():Rectangle
        {
            var position:Point;
            var layerCount:int = spriteCount;
            var sprite:IRoomObjectSprite;
            var bounds:Rectangle = new Rectangle();
            var index:int;
            var spriteBitmap:BitmapData;
            index = 0;

            while (index < layerCount)
            {
                sprite = getSprite(index);

                if (((!(sprite == null)) && (sprite.visible)))
                {
                    spriteBitmap = sprite.asset;

                    if (spriteBitmap != null)
                    {
                        position = new Point(sprite.offsetX, sprite.offsetY);

                        if (index == 0)
                        {
                            bounds.left = position.x;
                            bounds.top = position.y;
                            bounds.right = (position.x + sprite.width);
                            bounds.bottom = (position.y + sprite.height);
                        }

                        else
                        {
                            if (position.x < bounds.left)
                            {
                                bounds.left = position.x;
                            };

                            if (position.y < bounds.top)
                            {
                                bounds.top = position.y;
                            };

                            if ((position.x + sprite.width) > bounds.right)
                            {
                                bounds.right = (position.x + sprite.width);
                            };

                            if ((position.y + sprite.height) > bounds.bottom)
                            {
                                bounds.bottom = (position.y + sprite.height);
                            };
                        };
                    };
                };

                index++;
            };

            return (bounds);
        }

    }
}
