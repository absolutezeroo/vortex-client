package com.sulake.habbo.room.object.visualization.pet
{
    import com.sulake.habbo.room.object.visualization.furniture.AnimatedFurnitureVisualization;
    import com.sulake.habbo.room.object.visualization.data.AnimationStateData;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.habbo.room.object.visualization.data.AnimationData;
    import com.sulake.habbo.room.object.visualization.data.AnimationFrame;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualizationData;

    public class AnimatedPetVisualization extends AnimatedFurnitureVisualization
    {

        private static const HEAD_SPRITE_TAG:String = "head";
        private static const SADDLE_SPRITE_TAG:String = "saddle";
        private static const HAIR_SPRITE_TAG:String = "hair";
        private static const ADDITIONAL_SPRITE_COUNT:int = 1;
        private static const EXPERIENCE_BUBBLE_VISIBLE_IN_MS:int = 1000;
        private static const EXPERIENCE_BUBBLE_ASSET_NAME:String = "pet_experience_bubble_png";
        private static const POSTURE_ANIMATION_INDEX:int = 0;
        private static const GESTURE_ANIMATION_INDEX:int = 1;
        private static const _SafeStr_3407:int = 2;

        private var _posture:String = "";
        private var _gesture:String = "";
        private var _isSleeping:Boolean = false;
        private var _headDirection:int = 0;
        private var _experienceData:ExperienceData;
        private var _experienceTimeStamp:int = 0;
        private var _experience:int = 0;
        private var _animationData:AnimatedPetVisualizationData = null;
        private var _paletteName:String = "";
        private var _paletteIndex:int = -1;
        private var _customLayerIds:Array = [];
        private var _customPartIds:Array = [];
        private var _customPaletteIds:Array = [];
        private var _color:int = 0xFFFFFF;
        private var _headOnly:Boolean = false;
        private var _isRiding:Boolean = false;
        private var _animationStates:Array = [];
        private var _animationOver:Boolean = false;
        private var _headSprites:Array = [];
        private var _nonHeadSprites:Array = [];
        private var _saddleSprites:Array = [];
        private var _previousAnimationDirection:int = -1;

        public function AnimatedPetVisualization()
        {
            while (_animationStates.length < 2)
            {
                _animationStates.push(new AnimationStateData());
            };
        }

        override public function dispose():void
        {
            var i:int;
            var animationState:AnimationStateData;
            super.dispose();

            if (_animationStates != null)
            {
                i = 0;

                while (i < _animationStates.length)
                {
                    animationState = (_animationStates[i] as AnimationStateData);

                    if (animationState != null)
                    {
                        animationState.dispose();
                    };

                    i++;
                };

                _animationStates = null;
            };

            if (_experienceData)
            {
                _experienceData.dispose();
                _experienceData = null;
            };
        }

        override protected function getAnimationId(animationState:AnimationStateData):int
        {
            return (animationState.animationId);
        }

        override public function initialize(data:IRoomObjectVisualizationData):Boolean
        {
            var experienceBubbleAsset:BitmapDataAsset;

            if (!(data is AnimatedPetVisualizationData))
            {
                return (false);
            };

            _animationData = (data as AnimatedPetVisualizationData);

            var experienceBubbleBitmapData:BitmapData;

            if (_animationData.commonAssets != null)
            {
                experienceBubbleAsset = (_animationData.commonAssets.getAssetByName("pet_experience_bubble_png") as BitmapDataAsset);

                if (experienceBubbleAsset != null)
                {
                    experienceBubbleBitmapData = (experienceBubbleAsset.content as BitmapData).clone();
                    _experienceData = new ExperienceData(experienceBubbleBitmapData);
                };
            };

            if (super.initialize(data))
            {
                return (true);
            };

            return (false);
        }

        override public function update(geometry:IRoomGeometry, time:int, update:Boolean, skipUpdate:Boolean):void
        {
            super.update(geometry, time, update, skipUpdate);
            updateExperienceBubble(time);
        }

        override protected function updateAnimation(elapsedTime:Number):int
        {
            var direction:int;
            var roomObject:IRoomObject = object;

            if (roomObject != null)
            {
                direction = roomObject.getDirection().x;

                if (direction != _previousAnimationDirection)
                {
                    _previousAnimationDirection = direction;
                    resetAllAnimationFrames();
                };
            };

            return (super.updateAnimation(elapsedTime));
        }

        override protected function updateModel(_arg_1:Number):Boolean
        {
            var _local_5:String;
            var _local_10:String;
            var _local_11:Number;
            var _local_7:int;
            var _local_2:Number;
            var _local_6:int;
            var _local_8:Number;
            var _local_4:Number;
            var _local_16:int;
            var _local_15:Array;
            var _local_12:Array;
            var _local_17:Array;
            var _local_9:int;
            var _local_3:Number;
            var _local_13:IRoomObject = object;

            if (_local_13 == null)
            {
                return (false);
            };

            var _local_14:IRoomObjectModel = _local_13.getModel();

            if (_local_14 == null)
            {
                return (false);
            };

            if (_local_14.getUpdateID() != _SafeStr_3270)
            {
                _local_5 = _local_14.getString("figure_posture");
                _local_10 = _local_14.getString("figure_gesture");
                _local_11 = _local_14.getNumber("figure_posture");

                if (!isNaN(_local_11))
                {
                    _local_7 = _animationData.getPostureCount(_SafeStr_3272);

                    if (_local_7 > 0)
                    {
                        _local_5 = _animationData.getPostureForAnimation(_SafeStr_3272, (_local_11 % _local_7), true);
                        _local_10 = null;
                    };
                };

                _local_2 = _local_14.getNumber("figure_gesture");

                if (!isNaN(_local_2))
                {
                    _local_6 = _animationData.getGestureCount(_SafeStr_3272);

                    if (_local_6 > 0)
                    {
                        _local_10 = _animationData.getGestureForAnimation(_SafeStr_3272, (_local_2 % _local_6));
                    };
                };

                validateActions(_local_5, _local_10);
                _local_8 = _local_14.getNumber("furniture_alpha_multiplier");

                if (isNaN(_local_8))
                {
                    _local_8 = 1;
                };

                if (_local_8 != _SafeStr_1257)
                {
                    _SafeStr_1257 = _local_8;
                    _SafeStr_3382 = true;
                };

                _isSleeping = (_local_14.getNumber("figure_sleep") > 0);
                _local_4 = _local_14.getNumber("head_direction");

                if (((!(isNaN(_local_4))) && (_animationData.isAllowedToTurnHead)))
                {
                    _headDirection = _local_4;
                }

                else
                {
                    _headDirection = _local_13.getDirection().x;
                };

                _experienceTimeStamp = _local_14.getNumber("figure_experience_timestamp");
                _experience = _local_14.getNumber("figure_gained_experience");
                _local_16 = _local_14.getNumber("pet_palette_index");

                if (_local_16 != _paletteIndex)
                {
                    _paletteIndex = _local_16;
                    _paletteName = _paletteIndex.toString();
                };

                _local_15 = _local_14.getNumberArray("pet_custom_layer_ids");
                _customLayerIds = ((_local_15 != null) ? _local_15 : []);
                _local_12 = _local_14.getNumberArray("pet_custom_part_ids");
                _customPartIds = ((_local_12 != null) ? _local_12 : []);
                _local_17 = _local_14.getNumberArray("pet_custom_palette_ids");
                _customPaletteIds = ((_local_17 != null) ? _local_17 : []);
                _local_9 = _local_14.getNumber("pet_is_riding");
                _isRiding = ((!(isNaN(_local_9))) && (_local_9 > 0));
                _local_3 = _local_14.getNumber("pet_color");

                if (((!(isNaN(_local_3))) && (!(_local_3 == _color))))
                {
                    _color = _local_3;
                };

                _headOnly = (_local_14.getNumber("pet_head_only") > 0);
                _SafeStr_3270 = _local_14.getUpdateID();
                return (true);
            };

            return (false);
        }

        private function updateExperienceBubble(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:IRoomObjectSprite;

            if (_experienceData != null)
            {
                _experienceData.alpha = 0;

                if (_experienceTimeStamp > 0)
                {
                    _local_2 = (_arg_1 - _experienceTimeStamp);

                    if (_local_2 < 1000)
                    {
                        _experienceData.alpha = int((Math.sin(((_local_2 / 1000) * 3.14159265358979)) * 0xFF));
                        _experienceData.setExperience(_experience);
                    }

                    else
                    {
                        _experienceTimeStamp = 0;
                    };

                    _local_3 = getSprite((spriteCount - 1));

                    if (_local_3 != null)
                    {
                        if (_experienceData.alpha > 0)
                        {
                            _local_3.asset = _experienceData.image;
                            _local_3.offsetX = -20;
                            _local_3.offsetY = -80;
                            _local_3.alpha = _experienceData.alpha;
                            _local_3.visible = true;
                        }

                        else
                        {
                            _local_3.asset = null;
                            _local_3.visible = false;
                        };
                    };
                };
            };
        }

        private function validateActions(_arg_1:String, _arg_2:String):void
        {
            var _local_3:int;

            if (_arg_1 != _posture)
            {
                _posture = _arg_1;
                _local_3 = _animationData.getAnimationForPosture(_SafeStr_3272, _arg_1);
                setAnimationForIndex(0, _local_3);
            };

            if (_animationData.getGestureDisabled(_SafeStr_3272, _arg_1))
            {
                _arg_2 = null;
            };

            if (_arg_2 != _gesture)
            {
                _gesture = _arg_2;
                _local_3 = _animationData.getAnimationForGesture(_SafeStr_3272, _arg_2);
                setAnimationForIndex(1, _local_3);
            };
        }

        override protected function updateLayerCount(_arg_1:int):void
        {
            super.updateLayerCount(_arg_1);
            _headSprites = [];
        }

        override protected function getAdditionalSpriteCount():int
        {
            return (super.getAdditionalSpriteCount() + 1);
        }

        override protected function setAnimation(_arg_1:int):void
        {
        }

        private function getAnimationStateData(_arg_1:int):AnimationStateData
        {
            var _local_2:AnimationStateData;

            if (((_arg_1 >= 0) && (_arg_1 < _animationStates.length)))
            {
                return (_animationStates[_arg_1]);
            };

            return (null);
        }

        private function setAnimationForIndex(_arg_1:int, _arg_2:int):void
        {
            var _local_3:AnimationStateData = getAnimationStateData(_arg_1);

            if (_local_3 != null)
            {
                if (setSubAnimation(_local_3, _arg_2))
                {
                    _animationOver = false;
                };
            };
        }

        override protected function resetAllAnimationFrames():void
        {
            var _local_2:int;
            var _local_1:AnimationStateData;
            _animationOver = false;
            _local_2 = (_animationStates.length - 1);

            while (_local_2 >= 0)
            {
                _local_1 = _animationStates[_local_2];

                if (_local_1 != null)
                {
                    _local_1.setLayerCount(animatedLayerCount);
                };

                _local_2--;
            };
        }

        override protected function updateAnimations(_arg_1:Number):int
        {
            var _local_5:int;
            var _local_4:AnimationStateData;
            var _local_6:int;

            if (_animationOver)
            {
                return (0);
            };

            var _local_3:Boolean = true;
            var _local_2:int;
            _local_5 = 0;

            while (_local_5 < _animationStates.length)
            {
                _local_4 = _animationStates[_local_5];

                if (_local_4 != null)
                {
                    if (!_local_4.animationOver)
                    {
                        _local_6 = updateFramesForAnimation(_local_4, _arg_1);
                        _local_2 = (_local_2 | _local_6);

                        if (!_local_4.animationOver)
                        {
                            _local_3 = false;
                        }

                        else
                        {
                            if (((AnimationData.isTransitionFromAnimation(_local_4.animationId)) || (AnimationData.isTransitionToAnimation(_local_4.animationId))))
                            {
                                setAnimationForIndex(_local_5, _local_4.animationAfterTransitionId);
                                _local_3 = false;
                            };
                        };
                    };
                };

                _local_5++;
            };

            _animationOver = _local_3;
            return (_local_2);
        }

        override protected function getFrameNumber(_arg_1:int, _arg_2:int):int
        {
            var _local_4:int;
            var _local_3:AnimationStateData;
            var _local_5:AnimationFrame;
            _local_4 = (_animationStates.length - 1);

            while (_local_4 >= 0)
            {
                _local_3 = _animationStates[_local_4];

                if (_local_3 != null)
                {
                    _local_5 = _local_3.getFrame(_arg_2);

                    if (_local_5 != null)
                    {
                        return (_local_5.id);
                    };
                };

                _local_4--;
            };

            return (super.getFrameNumber(_arg_1, _arg_2));
        }

        override protected function getPostureForAssetFile(_arg_1:int, _arg_2:String):String
        {
            var _local_5:int;
            var _local_6:String;
            var _local_4:Array = _arg_2.split("_");
            var _local_3:int = _local_4.length;
            _local_5 = 0;

            while (_local_5 < _local_4.length)
            {
                if (((_local_4[_local_5] == "64") || (_local_4[_local_5] == "32")))
                {
                    _local_3 = (_local_5 + 3);
                    break;
                };

                _local_5++;
            };

            var _local_7:String;

            if (_local_3 < _local_4.length)
            {
                _local_6 = _local_4[_local_3];
                _local_6 = _local_6.split("@")[0];
                _local_7 = _animationData.getPostureForAnimation(_arg_1, (Number(_local_6) / 100), false);

                if (_local_7 == null)
                {
                    _local_7 = _animationData.getGestureForAnimationId(_arg_1, (Number(_local_6) / 100));
                };
            };

            return (_local_7);
        }

        override protected function getSpriteXOffset(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            var _local_6:int;
            var _local_5:AnimationStateData;
            var _local_7:AnimationFrame;
            var _local_4:int = super.getSpriteXOffset(_arg_1, _arg_2, _arg_3);
            _local_6 = (_animationStates.length - 1);

            while (_local_6 >= 0)
            {
                _local_5 = _animationStates[_local_6];

                if (_local_5 != null)
                {
                    _local_7 = _local_5.getFrame(_arg_3);

                    if (_local_7 != null)
                    {
                        _local_4 = (_local_4 + _local_7.x);
                    };
                };

                _local_6--;
            };

            return (_local_4);
        }

        override protected function getSpriteYOffset(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            var _local_6:int;
            var _local_5:AnimationStateData;
            var _local_7:AnimationFrame;
            var _local_4:int = super.getSpriteYOffset(_arg_1, _arg_2, _arg_3);
            _local_6 = (_animationStates.length - 1);

            while (_local_6 >= 0)
            {
                _local_5 = _animationStates[_local_6];

                if (_local_5 != null)
                {
                    _local_7 = _local_5.getFrame(_arg_3);

                    if (_local_7 != null)
                    {
                        _local_4 = (_local_4 + _local_7.y);
                    };
                };

                _local_6--;
            };

            return (_local_4);
        }

        override protected function getAsset(_arg_1:String, _arg_2:int=-1):IGraphicAsset
        {
            var _local_3:int;
            var _local_5:String;
            var _local_6:int;
            var _local_7:int;
            var _local_4:IGraphicAsset;

            if (assetCollection != null)
            {
                _local_3 = _customLayerIds.indexOf(_arg_2);
                _local_5 = _paletteName;
                _local_6 = -1;
                _local_7 = -1;

                if (_local_3 > -1)
                {
                    _local_6 = _customPartIds[_local_3];
                    _local_7 = _customPaletteIds[_local_3];
                    _local_5 = ((_local_7 > -1) ? String(_local_7) : _paletteName);
                };

                if (((!(isNaN(_local_6))) && (_local_6 > -1)))
                {
                    _arg_1 = (_arg_1 + ("_" + _local_6));
                };

                _local_4 = assetCollection.getAssetWithPalette(_arg_1, _local_5);
                return (_local_4);
            };

            return (null);
        }

        override protected function getSpriteZOffset(_arg_1:int, _arg_2:int, _arg_3:int):Number
        {
            if (_animationData == null)
            {
                return (0);
            };

            var _local_4:Number = _animationData.getZOffset(_arg_1, getDirection(_arg_1, _arg_3), _arg_3);
            return (_local_4);
        }

        override protected function getSpriteAssetName(_arg_1:int, _arg_2:int):String
        {
            var _local_3:int;
            var _local_5:String;

            if (((_headOnly) && (isNonHeadSprite(_arg_2))))
            {
                return (null);
            };

            if (((_isRiding) && (isSaddleSprite(_arg_2))))
            {
                return (null);
            };

            var _local_4:int = spriteCount;

            if (_arg_2 < (_local_4 - 1))
            {
                _local_3 = getSize(_arg_1);

                if (_arg_2 < (_local_4 - (1 + 1)))
                {
                    if (_arg_2 >= FurnitureVisualizationData.LAYER_NAMES.length)
                    {
                        return (null);
                    };

                    _local_5 = FurnitureVisualizationData.LAYER_NAMES[_arg_2];

                    if (_local_3 == 1)
                    {
                        return ((type + "_icon_") + _local_5);
                    };

                    return ((((((((type + "_") + _local_3) + "_") + _local_5) + "_") + getDirection(_arg_1, _arg_2)) + "_") + getFrameNumber(_local_3, _arg_2));
                };

                return (((((type + "_") + _local_3) + "_sd_") + getDirection(_arg_1, _arg_2)) + "_0");
            };

            return (null);
        }

        override protected function getSpriteColor(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            if (_arg_2 < (spriteCount - 1))
            {
                return (_color);
            };

            return (0xFFFFFF);
        }

        private function getDirection(_arg_1:int, _arg_2:int):int
        {
            if (isHeadSprite(_arg_2))
            {
                return (_animationData.getDirectionValue(_arg_1, _headDirection));
            };

            return (direction);
        }

        private function isHeadSprite(_arg_1:int):Boolean
        {
            var _local_3:Boolean;
            var _local_2:Boolean;

            if (_headSprites[_arg_1] == null)
            {
                _local_3 = (_animationData.getTag(_SafeStr_3272, -1, _arg_1) == "head");
                _local_2 = (_animationData.getTag(_SafeStr_3272, -1, _arg_1) == "hair");

                if (((_local_3) || (_local_2)))
                {
                    _headSprites[_arg_1] = true;
                }

                else
                {
                    _headSprites[_arg_1] = false;
                };
            };

            return (_headSprites[_arg_1]);
        }

        private function isNonHeadSprite(_arg_1:int):Boolean
        {
            var _local_2:String;

            if (_nonHeadSprites[_arg_1] == null)
            {
                if (_arg_1 < (spriteCount - (1 + 1)))
                {
                    _local_2 = _animationData.getTag(_SafeStr_3272, -1, _arg_1);

                    if (((((!(_local_2 == null)) && (_local_2.length > 0)) && (!(_local_2 == "head"))) && (!(_local_2 == "hair"))))
                    {
                        _nonHeadSprites[_arg_1] = true;
                    }

                    else
                    {
                        _nonHeadSprites[_arg_1] = false;
                    };
                }

                else
                {
                    _nonHeadSprites[_arg_1] = true;
                };
            };

            return (_nonHeadSprites[_arg_1]);
        }

        private function isSaddleSprite(_arg_1:int):Boolean
        {
            if (_saddleSprites[_arg_1] == null)
            {
                if (_animationData.getTag(_SafeStr_3272, -1, _arg_1) == "saddle")
                {
                    _saddleSprites[_arg_1] = true;
                }

                else
                {
                    _saddleSprites[_arg_1] = false;
                };
            };

            return (_saddleSprites[_arg_1]);
        }

    }
}