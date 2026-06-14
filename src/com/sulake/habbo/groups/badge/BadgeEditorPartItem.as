package com.sulake.habbo.groups.badge
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.assets.IAssetReceiver;
    import com.sulake.habbo.groups.HabboGroupsManager;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import com.sulake.habbo.communication.messages.incoming.users.BadgePartData;
    import com.sulake.core.assets.IResourceManager;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.communication.messages.incoming.users.GuildColorData;
    import flash.geom.Point;

    public class BadgeEditorPartItem implements IDisposable, IAssetReceiver 
    {

        public static var BASE_PART:int = 0;
        public static var LAYER_PART:int = 1;
        public static var IMAGE_WIDTH:Number = 39;
        public static var IMAGE_HEIGHT:Number = 39;
        public static var CELL_WIDTH:Number = 13;
        public static var CELL_HEIGHT:Number = 13;

        private var _manager:HabboGroupsManager;
        private var _parentCtrl:BadgeSelectPartCtrl;
        private var _partIndex:int;
        private var _type:int;
        private var _sourceUrl:String;
        private var _disposed:Boolean;
        private var _fileName:String;
        private var _maskFileName:String;
        private var _image:BitmapData;
        private var _mask:BitmapData;
        private var _composite:BitmapData;
        private var _colorTransform:ColorTransform = new ColorTransform(1, 1, 1);
        private var _hasMask:Boolean = false;
        private var _isLoaded:Boolean = false;
        private var _isStatic:Boolean = false;

        public function BadgeEditorPartItem(_arg_1:HabboGroupsManager, _arg_2:BadgeSelectPartCtrl, _arg_3:int, _arg_4:int, _arg_5:BadgePartData=null)
        {
            _partIndex = _arg_3;
            _manager = _arg_1;
            _parentCtrl = _arg_2;
            _type = _arg_4;
            _sourceUrl = _manager.getProperty("image.library.badgepart.url");
            _composite = new BitmapData(IMAGE_WIDTH, IMAGE_HEIGHT);

            if (_arg_5 == null)
            {
                _isLoaded = true;
                _isStatic = true;
                _image = _manager.getButtonImage("badge_part_empty");
            }

            else
            {
                _fileName = _arg_5.fileName.replace(".gif", "").replace(".png", "");
                _maskFileName = _arg_5.maskFileName.replace(".gif", "").replace(".png", "");
                _hasMask = (_maskFileName.length > 0);
                _composite = new BitmapData(IMAGE_WIDTH, IMAGE_HEIGHT);
                _fileName = (((_sourceUrl + "badgepart_") + _fileName) + ".png");
                _maskFileName = (((_sourceUrl + "badgepart_") + _maskFileName) + ".png");
                _manager.windowManager.resourceManager.retrieveAsset(_fileName, this);
                _manager.windowManager.resourceManager.retrieveAsset(_maskFileName, this);
            };
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get partIndex():int
        {
            return (_partIndex);
        }

        public function receiveAsset(_arg_1:IAsset, _arg_2:String):void
        {
            var _local_3:IResourceManager = _manager.windowManager.resourceManager;

            if (_local_3.isSameAsset(_fileName, _arg_2))
            {
                _image = (_arg_1.content as BitmapData);
            };

            if (_local_3.isSameAsset(_maskFileName, _arg_2))
            {
                _mask = (_arg_1.content as BitmapData);
            };

            checkIsImageLoaded();
        }

        public function dispose():void
        {
            if (!disposed)
            {
                if (_image)
                {
                    _image.dispose();
                    _image = null;
                };

                if (_mask)
                {
                    _mask.dispose();
                    _mask = null;
                };

                if (_composite)
                {
                    _composite.dispose();
                    _composite = null;
                };

                _fileName = null;
                _maskFileName = null;
                _colorTransform = null;
                _parentCtrl = null;
                _manager = null;
                _disposed = true;
            };
        }

        private function checkIsImageLoaded():void
        {
            if (_image == null)
            {
                return;
            };

            if (((_hasMask) && (_mask == null)))
            {
                return;
            };

            _isLoaded = true;

            if (_type == BASE_PART)
            {
                _parentCtrl.onBaseImageLoaded(this);
            }

            else
            {
                _parentCtrl.onLayerImageLoaded(this);
            };
        }

        public function getComposite(_arg_1:BadgeLayerOptions):BitmapData
        {
            if (!_isLoaded)
            {
                return (null);
            };

            if (_isStatic)
            {
                return (_image);
            };

            var _local_2:GuildColorData = (_manager.guildEditorData.badgeColors[_arg_1.colorIndex] as GuildColorData);
            _colorTransform.redMultiplier = (_local_2.red / 0xFF);
            _colorTransform.greenMultiplier = (_local_2.green / 0xFF);
            _colorTransform.blueMultiplier = (_local_2.blue / 0xFF);

            var _local_3:Point = getPosition(_arg_1);
            _composite.dispose();
            _composite = new BitmapData(IMAGE_WIDTH, IMAGE_HEIGHT, true, 0);
            _composite.copyPixels(_image, _image.rect, _local_3);
            _composite.colorTransform(_composite.rect, _colorTransform);

            if (_hasMask)
            {
                _composite.copyPixels(_mask, _mask.rect, _local_3, null, null, true);
            };

            return (_composite);
        }

        private function getPosition(_arg_1:BadgeLayerOptions):Point
        {
            var _local_2:Number = (((CELL_WIDTH * _arg_1.gridX) + (CELL_WIDTH / 2)) - (_image.width / 2));
            var _local_3:Number = (((CELL_HEIGHT * _arg_1.gridY) + (CELL_HEIGHT / 2)) - (_image.height / 2));

            if (_local_2 < 0)
            {
                _local_2 = 0;
            };

            if ((_local_2 + _image.width) > IMAGE_WIDTH)
            {
                _local_2 = (IMAGE_WIDTH - _image.width);
            };

            if (_local_3 < 0)
            {
                _local_3 = 0;
            };

            if ((_local_3 + _image.height) > IMAGE_HEIGHT)
            {
                _local_3 = (IMAGE_HEIGHT - _image.height);
            };

            return (new Point(Math.floor(_local_2), Math.floor(_local_3)));
        }

    }
}
