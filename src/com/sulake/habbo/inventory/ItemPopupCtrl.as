package com.sulake.habbo.inventory
{
    import flash.utils.Timer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import com.sulake.habbo.inventory.trading.TradingModel;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.window.widgets.ILimitedItemPreviewOverlayWidget;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.utils.StringUtil;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.habbo.room.IStuffData;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import com.adobe.serialization.json.JSONDecoder;
    import flash.events.Event;
    import com.sulake.core.assets.loaders.BitmapFileLoader;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.*;

    public class ItemPopupCtrl 
    {

        public static const _SafeStr_2793:int = 1;
        public static const LOCATION_RIGHT:int = 2;
        private static const BOUNDS_MARGIN:int = -5;
        private static const OPEN_DELAY_MS:int = 250;
        private static const CLOSE_DELAY_MS:int = 100;
        private static const IMAGE_MAX_WIDTH:int = 180;
        private static const IMAGE_MAX_HEIGHT:int = 200;

        private var _openDelayTimer:Timer = new Timer(250, 1);
        private var _hideDelayTimer:Timer = new Timer(100, 1);
        private var _assets:IAssetLibrary;
        private var _popupWindow:IWindowContainer;
        private var _parent:IWindowContainer;
        private var _preferredLocation:int = 2;
        private var _arrowImgLeft:BitmapData;
        private var _arrowImgRight:BitmapData;
        private var _tradingModel:TradingModel;
        private var _windowManager:IHabboWindowManager;
        private var _expectingExtImage:Boolean = false;

        public function ItemPopupCtrl(_arg_1:IWindowContainer, _arg_2:IAssetLibrary, _arg_3:IHabboWindowManager, _arg_4:TradingModel)
        {
            if (((_arg_1 == null) || (_arg_2 == null)))
            {
                throw (new Error("Null pointers passed as argument!"));
            };

            _popupWindow = _arg_1;
            _popupWindow.visible = false;
            _assets = _arg_2;
            _windowManager = _arg_3;
            _openDelayTimer.addEventListener("timer", onDisplayTimer);
            _hideDelayTimer.addEventListener("timer", onHideTimer);
            _tradingModel = _arg_4;

            var _local_5:BitmapDataAsset = (_assets.getAssetByName("popup_arrow_right_png") as BitmapDataAsset);

            if (((!(_local_5 == null)) && (!(_local_5.content == null))))
            {
                _arrowImgRight = (_local_5.content as BitmapData);
            };

            _local_5 = (_assets.getAssetByName("popup_arrow_left_png") as BitmapDataAsset);

            if (((!(_local_5 == null)) && (!(_local_5.content == null))))
            {
                _arrowImgLeft = (_local_5.content as BitmapData);
            };
        }

        public function dispose():void
        {
            if (_openDelayTimer != null)
            {
                _openDelayTimer.removeEventListener("timer", onDisplayTimer);
                _openDelayTimer.stop();
                _openDelayTimer = null;
            };

            if (_hideDelayTimer != null)
            {
                _hideDelayTimer.removeEventListener("timer", onHideTimer);
                _hideDelayTimer.stop();
                _hideDelayTimer = null;
            };

            _assets = null;
            _popupWindow = null;
            _parent = null;
            _arrowImgLeft = null;
            _arrowImgRight = null;
        }

        public function updateContent(_arg_1:IWindowContainer, _arg_2:String, _arg_3:BitmapData, _arg_4:IStuffData=null, _arg_5:int=2, _arg_6:Boolean=false):void
        {
            var _local_14:String;
            var _local_12:String;
            var _local_10:String;
            var _local_8:BitmapData;
            var _local_11:ILimitedItemPreviewOverlayWidget;

            if (_popupWindow == null)
            {
                return;
            };

            if (_arg_1 == null)
            {
                return;
            };

            if (_arg_3 == null)
            {
                _arg_3 = new BitmapData(1, 1, true, 0xFFFFFF);
            };

            if (_parent != null)
            {
                _parent.removeChild(_popupWindow);
            };

            _parent = _arg_1;
            _preferredLocation = _arg_5;
            _expectingExtImage = false;

            var _local_13:ITextWindow = ITextWindow(_popupWindow.findChildByName("item_name_text"));

            if (_local_13)
            {
                _local_13.text = _arg_2;
            };

            var _local_7:IWidgetWindow = IWidgetWindow(_popupWindow.findChildByName("unique_item_overlay_widget"));
            var _local_9:IBitmapWrapperWindow = (_popupWindow.findChildByName("item_image") as IBitmapWrapperWindow);

            if (_local_9)
            {
                if (((_arg_6) && (_tradingModel)))
                {
                    _local_7.visible = false;
                    _local_9.bitmap = new BitmapData(1, 1, true, 0xFFFFFF);

                    if (_arg_4 != null)
                    {
                        _expectingExtImage = true;
                        _local_14 = _arg_4.getJSONValue("id");

                        if (!StringUtil.isBlank(_local_14))
                        {
                            loadExtraData(_local_14);
                        }

                        else
                        {
                            _local_12 = _arg_4.getJSONValue("w");

                            if (!StringUtil.isBlank(_local_12))
                            {
                                _local_10 = (_tradingModel.getInventory().getProperty("stories.image_url_base") + _local_12);
                                loadImage(_local_10);
                            };
                        };
                    };

                    return;
                };

                _local_8 = new BitmapData(Math.min(180, _arg_3.width), Math.min(200, _arg_3.height), true, 0xFFFFFF);
                _local_8.copyPixels(_arg_3, new Rectangle(0, 0, _local_8.width, _local_8.height), new Point(0, 0), null, null, true);
                _local_9.bitmap = _local_8;
                _local_9.width = _local_9.bitmap.width;
                _local_9.height = _local_9.bitmap.height;
                _local_9.x = ((_popupWindow.width - _local_9.width) / 2);
                _popupWindow.height = (_local_9.bottom + 10);
            };

            if (((!(_arg_4 == null)) && (_arg_4.uniqueSerialNumber > 0)))
            {
                _local_11 = ILimitedItemPreviewOverlayWidget(_local_7.widget);
                _local_11.serialNumber = _arg_4.uniqueSerialNumber;
                _local_11.seriesSize = _arg_4.uniqueSeriesSize;
            }

            else
            {
                _local_7.visible = false;
            };
        }

        private function loadExtraData(_arg_1:String):void
        {
            var _local_3:String = (_tradingModel.getInventory().getProperty("extra_data_service_url") + _arg_1);
            var _local_2:URLLoader = new URLLoader(new URLRequest(_local_3));
            _local_2.addEventListener("complete", onExtraDataLoaded);
        }

        private function onExtraDataLoaded(_arg_1:Event):void
        {
            var _local_2:Object;
            var _local_3:String = URLLoader(_arg_1.target).data;

            if (((_expectingExtImage) && (!(StringUtil.isBlank(_local_3)))))
            {
                try
                {
                    _local_2 = new JSONDecoder(_local_3, false).getValue();
                    loadImage(_local_2.url);
                }

                catch(error:Error)
                {
                };
            };
        }

        private function loadImage(_arg_1:String):void
        {
            var _local_2:BitmapFileLoader;

            if (!StringUtil.isBlank(_arg_1))
            {
                _local_2 = new BitmapFileLoader("image/png", new URLRequest(_arg_1));
                _local_2.addEventListener("AssetLoaderEventComplete", onExtImageLoaded);
            };
        }

        private function onExtImageLoaded(_arg_1:AssetLoaderEvent):void
        {
            if (((!(_popupWindow)) || (!(_expectingExtImage))))
            {
                return;
            };

            var _local_4:IBitmapWrapperWindow = (_popupWindow.findChildByName("item_image") as IBitmapWrapperWindow);

            if (((!(_local_4)) || (_assets == null)))
            {
                return;
            };

            var _local_6:DisplayObject = (BitmapFileLoader(_arg_1.target).content as DisplayObject);
            var _local_2:BitmapData = new BitmapData(Math.min(180, _local_6.width), Math.min(200, _local_6.height), true, 0xFFFFFF);
            var _local_3:Number = (180 / _local_6.width);
            var _local_5:Matrix = new Matrix();
            _local_5.scale(_local_3, _local_3);
            _local_2.draw(_local_6, _local_5);
            _local_4.bitmap = _local_2;
            _local_4.width = _local_4.bitmap.width;
            _local_4.height = _local_4.bitmap.height;
            _local_4.x = ((_popupWindow.width - _local_4.width) / 2);
            _popupWindow.height = (_local_4.bottom + 10);
        }

        public function show():void
        {
            _hideDelayTimer.reset();
            _openDelayTimer.reset();

            if (_parent == null)
            {
                return;
            };

            _popupWindow.visible = true;
            _parent.addChild(_popupWindow);
            refreshArrow(_preferredLocation);
            switch (_preferredLocation)
            {
                case 1:
                    _popupWindow.x = ((-1 * _popupWindow.width) - -5);
                    break;
                case 2:
                    _popupWindow.x = (_parent.width + -5);
                default:
            };

            _popupWindow.y = ((_parent.height - _popupWindow.height) / 2);
        }

        public function hide():void
        {
            _popupWindow.visible = false;
            _hideDelayTimer.reset();
            _openDelayTimer.reset();

            if (_parent != null)
            {
                _parent.removeChild(_popupWindow);
            };
        }

        public function showDelayed():void
        {
            _hideDelayTimer.reset();
            _openDelayTimer.reset();
            _openDelayTimer.start();
        }

        public function hideDelayed():void
        {
            _hideDelayTimer.reset();
            _openDelayTimer.reset();
            _hideDelayTimer.start();
        }

        private function refreshArrow(_arg_1:int=2):void
        {
            if (((_popupWindow == null) || (_popupWindow.disposed)))
            {
                return;
            };

            var _local_2:IBitmapWrapperWindow = IBitmapWrapperWindow(_popupWindow.findChildByName("arrow_pointer"));

            if (!_local_2)
            {
                return;
            };

            switch (_arg_1)
            {
                case 1:
                    _local_2.bitmap = _arrowImgRight.clone();
                    _local_2.width = _arrowImgRight.width;
                    _local_2.height = _arrowImgRight.height;
                    _local_2.y = ((_popupWindow.height - _arrowImgRight.height) / 2);
                    _local_2.x = (_popupWindow.width - 1);
                    break;
                case 2:
                    _local_2.bitmap = _arrowImgLeft.clone();
                    _local_2.width = _arrowImgLeft.width;
                    _local_2.height = _arrowImgLeft.height;
                    _local_2.y = ((_popupWindow.height - _arrowImgLeft.height) / 2);
                    _local_2.x = ((-1 * _arrowImgLeft.width) + 1);
                default:
            };

            _local_2.invalidate();
        }

        private function onDisplayTimer(_arg_1:TimerEvent):void
        {
            show();
        }

        private function onHideTimer(_arg_1:TimerEvent):void
        {
            hide();
        }

    }
}
