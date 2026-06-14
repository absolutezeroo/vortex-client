package com.sulake.habbo.toolbar.extensions
{
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.utils.Timer;
    import flash.display.BitmapData;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetHabboClubExtendOfferMessageComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.core.window.components.IIconWindow;

    public class ClubDiscountPromoExtension 
    {

        private static const _SafeStr_3789:String = "club_promo";
        private static const ICON_STYLE_VIP:int = 14;
        private static const LINK_COLOR_NORMAL:uint = 0xFFFFFF;
        private static const LINK_COLOR_HIGHLIGHT:uint = 12247545;

        private var _toolbar:HabboToolbar;
        private var _view:IWindowContainer;
        private var _disposed:Boolean = false;
        private var _animElement:IBitmapWrapperWindow;
        private var _animTimer:Timer;
        private var _animTickCount:int = 0;
        private var _animBlockMoveAmount:int;
        private var _triggerTimer:Timer;
        private var _animBitmap:BitmapData;
        private var _expirationTimer:Timer;

        public function ClubDiscountPromoExtension(_arg_1:HabboToolbar)
        {
            _toolbar = _arg_1;
        }

        private function createWindow():IWindowContainer
        {
            var _local_4:IAsset;
            var _local_2:IRegionWindow;
            var _local_1:IWindowContainer;
            var _local_3:XmlAsset = (_toolbar.assets.getAssetByName("club_discount_promotion_xml") as XmlAsset);

            if (_local_3)
            {
                _local_1 = (_toolbar.windowManager.buildFromXML((_local_3.content as XML), 1) as IWindowContainer);

                if (_local_1)
                {
                    _animElement = (_local_1.findChildByName("flashing_animation") as IBitmapWrapperWindow);

                    if (_animElement)
                    {
                        _local_4 = (_toolbar.assets.getAssetByName("extend_hilite_png") as IAsset);

                        if (_local_4)
                        {
                            _animBitmap = (_local_4.content as BitmapData);

                            if (_animBitmap)
                            {
                                _animElement.bitmap = _animBitmap.clone();
                            };
                        };

                        _animElement.visible = false;
                    };

                    _local_2 = (_local_1.findChildByName("text_region") as IRegionWindow);

                    if (_local_2)
                    {
                        _local_2.addEventListener("WME_CLICK", onTextRegionClicked);
                        _local_2.addEventListener("WME_OVER", onTextRegionMouseOver);
                        _local_2.addEventListener("WME_OUT", onTextRegionMouseOut);
                    };

                    assignState();
                };
            };

            return (_local_1);
        }

        private function destroyWindow():void
        {
            if (_view)
            {
                _view.dispose();
                _view = null;
                _animElement = null;
            };

            animate(false);
            destroyExpirationTimer();
        }

        public function dispose():void
        {
            if (((_disposed) || (!(_toolbar))))
            {
                return;
            };

            if (_toolbar.extensionView)
            {
                _toolbar.extensionView.detachExtension("club_promo");
            };

            clearAnimation();
            destroyWindow();
            _toolbar = null;
            _disposed = true;
        }

        private function onTextRegionClicked(_arg_1:WindowMouseEvent):void
        {
            if (_toolbar.inventory.clubLevel == 2)
            {
                _toolbar.connection.send(new EventLogMessageComposer("DiscountPromo", "discount", "client.club.extend.discount.clicked"));
                _toolbar.connection.send(new GetHabboClubExtendOfferMessageComposer());
            };
        }

        private function assignState():void
        {
            switch (_toolbar.inventory.clubLevel)
            {
                case 0:
                    setText("${discount.bar.no.club.promo}");
                    setClubIcon(14);
                    break;
                case 2:
                    setText("${discount.bar.vip.expiring}");
                    setClubIcon(14);
                default:
            };

            animate(true);
        }

        public function onClubChanged(_arg_1:HabboInventoryHabboClubEvent):void
        {
            if ((((_toolbar.inventory.clubIsExpiring) && (!(_view))) && (isExtensionEnabled())))
            {
                _view = createWindow();

                if (_expirationTimer != null)
                {
                    destroyExpirationTimer();
                };

                if (((_toolbar.inventory.clubMinutesUntilExpiration < 1440) && (_toolbar.inventory.clubMinutesUntilExpiration > 0)))
                {
                    _expirationTimer = new Timer(((_toolbar.inventory.clubMinutesUntilExpiration * 60) * 1000), 1);
                    _expirationTimer.addEventListener("timerComplete", onExtendOfferExpire);
                    _expirationTimer.start();
                };

                assignState();
                _toolbar.extensionView.attachExtension("club_promo", _view, 10);
            }

            else
            {
                _toolbar.extensionView.detachExtension("club_promo");
                destroyWindow();
            };
        }

        private function destroyExpirationTimer():void
        {
            if (_expirationTimer)
            {
                _expirationTimer.stop();
                _expirationTimer.removeEventListener("timerComplete", onExtendOfferExpire);
                _expirationTimer = null;
            };
        }

        private function onExtendOfferExpire(_arg_1:TimerEvent):void
        {
            _toolbar.extensionView.detachExtension("club_promo");
            destroyWindow();
        }

        private function isExtensionEnabled():Boolean
        {
            if (((_toolbar.inventory.clubLevel == 2) && (_toolbar.getBoolean("club.membership.extend.vip.promotion.enabled"))))
            {
                return (true);
            };

            return (false);
        }

        private function setText(_arg_1:String):void
        {
            var _local_2:ITextWindow;
            var _local_3:ITextWindow;

            if (_view)
            {
                _local_2 = (_view.findChildByName("promo_text") as ITextWindow);
                _local_3 = (_view.findChildByName("promo_text_shadow") as ITextWindow);

                if (_local_2)
                {
                    _local_2.text = _arg_1;
                };

                if (_local_3)
                {
                    _local_3.text = _arg_1;
                };
            };
        }

        private function animate(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                Logger.log("Animate window");

                if (_triggerTimer)
                {
                    _triggerTimer.stop();
                };

                _triggerTimer = new Timer(15000);
                _triggerTimer.addEventListener("timer", onTriggerTimer);
                _triggerTimer.start();
            }

            else
            {
                if (_triggerTimer)
                {
                    _triggerTimer.stop();
                    _triggerTimer = null;
                };

                clearAnimation();
            };
        }

        private function clearAnimation():void
        {
            if (_animElement)
            {
                _animElement.visible = false;
                _animElement.bitmap = null;
                _animElement = null;
                _view.invalidate();

                if (_animTimer)
                {
                    _animTimer.stop();
                    _animTimer = null;
                };
            };
        }

        private function onTriggerTimer(_arg_1:TimerEvent):void
        {
            if (_animElement)
            {
                if (_animElement.context)
                {
                    _animElement.visible = true;
                    resetAnimationVariables();
                    startAnimationTimer();
                };
            };
        }

        private function resetAnimationVariables():void
        {
            _animElement.x = 3;
            _animElement.y = 3;
            _animElement.bitmap = _animBitmap.clone();
            _animElement.height = (_view.height - 6);
            _animElement.width = _animElement.bitmap.width;
            _animElement.invalidate();
            _animBlockMoveAmount = ((_view.width - 7) - _animElement.bitmap.width);
            _animTickCount = 0;
        }

        private function startAnimationTimer():void
        {
            _animTimer = new Timer(25, 26);
            _animTimer.addEventListener("timer", onAnimationTimer);
            _animTimer.addEventListener("timerComplete", onAnimationTimerComplete);
            _animTimer.start();
        }

        private function onAnimationTimer(_arg_1:TimerEvent):void
        {
            var _local_2:int;
            var _local_3:BitmapData;

            if (_animElement)
            {
                _animElement.x = (3 + ((_animTickCount / 20) * _animBlockMoveAmount));

                if (_animElement.x > _animBlockMoveAmount)
                {
                    _local_2 = ((_view.width - 4) - _animElement.x);
                    _local_3 = new BitmapData(_local_2, _animBitmap.height);
                    _local_3.copyPixels(_animBitmap, new Rectangle(0, 0, _local_2, _animBitmap.height), new Point(0, 0));
                    _animElement.bitmap = _local_3;
                    _animElement.width = _local_2;
                };

                _animElement.invalidate();
                _animTickCount++;
            };
        }

        private function onAnimationTimerComplete(_arg_1:TimerEvent):void
        {
            clearAnimation();
        }

        private function setClubIcon(_arg_1:int):void
        {
            var _local_2:IIconWindow;

            if (_view)
            {
                _local_2 = (_view.findChildByName("club_icon") as IIconWindow);

                if (_local_2)
                {
                    _local_2.style = _arg_1;
                    _local_2.invalidate();
                };
            };
        }

        private function onTextRegionMouseOver(_arg_1:WindowMouseEvent):void
        {
            var _local_2:ITextWindow;

            if (_view)
            {
                _local_2 = (_view.findChildByName("promo_text") as ITextWindow);
                _local_2.textColor = 12247545;
            };
        }

        private function onTextRegionMouseOut(_arg_1:WindowMouseEvent):void
        {
            var _local_2:ITextWindow;

            if (_view)
            {
                _local_2 = (_view.findChildByName("promo_text") as ITextWindow);
                _local_2.textColor = 0xFFFFFF;
            };
        }

    }
}
