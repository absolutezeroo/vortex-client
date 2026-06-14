package com.sulake.habbo.catalog.viewer.widgets
{
    import com.sulake.habbo.catalog.club.ClubGiftController;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.viewer.Product;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubGiftData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components._SafeStr_101;
    import com.sulake.habbo.catalog.viewer.IProductContainer;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Rectangle;
    import com.sulake.habbo.room._SafeStr_147;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.assets.XmlAsset;

    public class ClubGiftWidget extends CatalogWidget implements ICatalogWidget 
    {

        private const DAYS_IN_MONTH:int = 31;

        private var _controller:ClubGiftController;
        private var _offers:Map;
        private var _preview:IWindowContainer;
        private var _catalog:HabboCatalog;

        public function ClubGiftWidget(_arg_1:IWindowContainer, _arg_2:ClubGiftController, _arg_3:HabboCatalog)
        {
            super(_arg_1);
            _catalog = _arg_3;
            _controller = _arg_2;
            _offers = new Map();
        }

        override public function dispose():void
        {
            super.dispose();
            _controller = null;
            _catalog = null;

            if (_preview)
            {
                _preview.dispose();
                _preview = null;
            };
        }

        override public function init():Boolean
        {
            if (!window)
            {
                return (false);
            };

            if (!super.init())
            {
                return (false);
            };

            _controller.widget = this;
            attachWidgetView("clubGiftWidget");
            _window.findChildByName("info_text").caption = "";
            _window.findChildByName("past_club_days").caption = "";
            _window.findChildByName("past_vip_days").caption = "";
            update();
            return (true);
        }

        public function update():void
        {
            updateInfo();
            updateList();
        }

        private function updateInfo():void
        {
            var _local_6:String;
            var _local_4:int;
            var _local_1:int;
            var _local_5:int;

            if (((!(_controller)) || (!(window))))
            {
                return;
            };

            var _local_7:IWindow = window.findChildByName("info_text");

            if (!_local_7)
            {
                return;
            };

            if (_controller.giftsAvailable > 0)
            {
                _local_6 = "catalog.club_gift.available";
                _controller.localization.registerParameter(_local_6, "amount", _controller.giftsAvailable.toString());
            }

            else
            {
                if (_controller.daysUntilNextGift > 0)
                {
                    _local_6 = "catalog.club_gift.days_until_next";
                    _controller.localization.registerParameter(_local_6, "days", _controller.daysUntilNextGift.toString());
                }

                else
                {
                    if (_controller.hasClub)
                    {
                        _local_6 = "catalog.club_gift.not_available";
                    }

                    else
                    {
                        _local_6 = "catalog.club_gift.no_club";
                    };
                };
            };

            _local_7.caption = _controller.localization.getLocalization(_local_6);

            if (!_controller.purse)
            {
                return;
            };

            var _local_2:IWindow = window.findChildByName("past_club_days");

            if (_local_2)
            {
                _local_5 = (_controller.purse.pastClubDays + _controller.purse.pastVipDays);
                _local_6 = ((_local_5 >= 31) ? "catalog.club_gift.past_club.long" : "catalog.club_gift.past_club");
                _local_4 = (_local_5 % 31);
                _local_1 = int((_local_5 / 31));
                _controller.localization.registerParameter(_local_6, "days", _local_4.toString());
                _controller.localization.registerParameter(_local_6, "months", _local_1.toString());
                _local_2.caption = _controller.localization.getLocalization(_local_6);
            };

            var _local_3:IWindow = window.findChildByName("past_vip_days");

            if (_local_3)
            {
                _local_6 = ((_controller.purse.pastVipDays >= 31) ? "catalog.club_gift.past_vip.long" : "catalog.club_gift.past_vip");
                _local_4 = (_controller.purse.pastVipDays % 31);
                _local_1 = int((_controller.purse.pastVipDays / 31));
                _controller.localization.registerParameter(_local_6, "days", _local_4.toString());
                _controller.localization.registerParameter(_local_6, "months", _local_1.toString());
                _local_3.caption = _controller.localization.getLocalization(_local_6);
            };
        }

        private function updateList():void
        {
            var _local_1:IPurchasableOffer;
            var _local_3:IWindow;
            var _local_11:Vector.<IProduct> = undefined;
            var _local_12:IProductData;
            var _local_9:IFurnitureData;
            var _local_5:Product;
            var _local_6:ClubGiftData;

            if ((((!(_controller)) || (!(window))) || (!(page))))
            {
                return;
            };

            for each (_local_1 in _offers)
            {
                _local_1.dispose();
            };

            _offers.reset();

            var _local_2:Array = _controller.getOffers();

            if (!_local_2)
            {
                return;
            };

            var _local_4:Map = _controller.getGiftData();

            if (!_local_4)
            {
                return;
            };

            var _local_10:IItemListWindow = (window.findChildByName("gift_list") as IItemListWindow);

            if (!_local_10)
            {
                return;
            };

            _local_10.destroyListItems();

            for each (var _local_7:CatalogPageMessageOfferData in _local_2)
            {
                _local_11 = new Vector.<IProduct>(0);
                _local_12 = _controller.catalog.getProductData(_local_7.localizationId);

                for each (var _local_8:CatalogPageMessageProductData in _local_7.products)
                {
                    _local_9 = _controller.catalog.getFurnitureData(_local_8.furniClassId, _local_8.productType);
                    _local_5 = new Product(_local_8.productType, _local_8.furniClassId, _local_8.extraParam, _local_8.productCount, _local_12, _local_9, _catalog);
                    _local_11.push(_local_5);
                };

                _local_1 = new Offer(_local_7.offerId, _local_7.localizationId, _local_7.isRent, _local_7.priceInCredits, _local_7.priceInActivityPoints, _local_7.activityPointType, _local_7.giftable, _local_7.clubLevel, _local_11, _local_7.bundlePurchaseAllowed, _catalog);
                _local_1.page = page;
                _local_6 = (_local_4.getValue(_local_1.offerId) as ClubGiftData);
                _local_3 = createListItem(_local_1, _local_6);

                if (_local_3)
                {
                    _local_10.addListItem(_local_3);
                    _offers.add(_local_1.offerId, _local_1);
                };
            };
        }

        private function createListItem(_arg_1:IPurchasableOffer, _arg_2:ClubGiftData):IWindow
        {
            var _local_9:int;
            var _local_13:String;
            var _local_8:int;
            var _local_12:int;

            if ((((!(_arg_1)) || (!(_arg_1.product))) || (!(_arg_2))))
            {
                return (null);
            };

            var _local_3:IWindowContainer = (createWindow("club_gift_list_item") as IWindowContainer);

            if (!_local_3)
            {
                return (null);
            };

            _local_3.procedure = clickHandler;

            var _local_4:IProduct = _arg_1.product;

            if (!_local_4)
            {
                return (null);
            };

            var _local_6:IProductData = _local_4.productData;

            if (!_local_6)
            {
                return (null);
            };

            setText(_local_3.findChildByName("gift_name"), _local_6.name);
            setText(_local_3.findChildByName("gift_desc"), _local_6.description);

            if (_arg_2.isVip)
            {
                _local_9 = (_arg_2.daysRequired - _controller.purse.pastVipDays);
            }

            else
            {
                _local_9 = (_arg_2.daysRequired - (_controller.purse.pastClubDays + _controller.purse.pastVipDays));
            };

            if (((!(_arg_2.isSelectable)) && (_local_9 > 0)))
            {
                if (_arg_2.isVip)
                {
                    _local_13 = "catalog.club_gift.vip_missing";
                }

                else
                {
                    _local_13 = "catalog.club_gift.club_missing";
                };

                if (_local_9 >= 31)
                {
                    _local_13 = (_local_13 + ".long");
                };

                _local_8 = (_local_9 % 31);
                _local_12 = int((_local_9 / 31));
                _controller.localization.registerParameter(_local_13, "days", _local_8.toString());
                _controller.localization.registerParameter(_local_13, "months", _local_12.toString());
            }

            else
            {
                if (_controller.giftsAvailable > 0)
                {
                    _local_13 = "catalog.club_gift.selectable";
                }

                else
                {
                    _local_13 = "";
                };
            };

            setText(_local_3.findChildByName("months_required"), ((_local_13.length > 0) ? _controller.localization.getLocalization(_local_13) : ""));

            var _local_10:IIconWindow = (_local_3.findChildByName("vip_icon") as IIconWindow);

            if (_local_10)
            {
                _local_10.visible = _arg_2.isVip;
            };

            var _local_11:_SafeStr_101 = (_local_3.findChildByName("select_button") as _SafeStr_101);

            if (_local_11)
            {
                if (((_arg_2.isSelectable) && (_controller.giftsAvailable > 0)))
                {
                    _local_11.enable();
                }

                else
                {
                    _local_11.disable();
                };

                _local_11.id = _arg_1.offerId;
            };

            var _local_7:IProductContainer = _arg_1.productContainer;

            if (!_local_7)
            {
                return (null);
            };

            if ((((!(page)) || (!(page.viewer))) || (!(page.viewer.roomEngine))))
            {
                return (null);
            };

            var _local_5:IWindowContainer = (_local_3.findChildByName("image_container") as IWindowContainer);

            if (_local_5)
            {
                _local_7.view = _local_5;
                _local_7.initProductIcon(page.viewer.roomEngine);
                _local_5.procedure = mouseOverHandler;
                _local_5.id = _arg_1.offerId;
            };

            return (_local_3);
        }

        private function setText(_arg_1:IWindow, _arg_2:String):void
        {
            _arg_1.caption = _arg_2;
        }

        private function clickHandler(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (((((!(_arg_1)) || (!(_arg_2))) || (!(_offers))) || (!(_controller))))
            {
                return;
            };

            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            if (_arg_2.name != "select_button")
            {
                return;
            };

            var _local_3:IPurchasableOffer = _offers.getValue(_arg_2.id);

            if (!_local_3)
            {
                return;
            };

            _controller.selectGift(_local_3);
        }

        private function mouseOverHandler(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_4:Rectangle;

            if ((((!(_arg_1)) || (!(_arg_2))) || (!(_offers))))
            {
                return;
            };

            if (_arg_2.name != "image_container")
            {
                return;
            };

            var _local_3:IPurchasableOffer = _offers.getValue(_arg_2.id);

            if (!_local_3)
            {
                return;
            };

            if (_arg_1.type == "WME_OVER")
            {
                _local_4 = new Rectangle();
                _arg_2.getGlobalRectangle(_local_4);
            };

            if (_arg_1.type == "WME_OUT")
            {
                hidePreview();
            };
        }

        private function showPreview(_arg_1:Offer, _arg_2:Rectangle):void
        {
            var _local_6:_SafeStr_147;

            if (((!(_arg_1)) || (!(_arg_1.productContainer))))
            {
                return;
            };

            if ((((!(page)) || (!(page.viewer))) || (!(page.viewer.roomEngine))))
            {
                return;
            };

            var _local_4:IProduct = _arg_1.product;

            if (!_local_4)
            {
                return;
            };

            if (!_preview)
            {
                _preview = (createWindow("club_gift_preview") as IWindowContainer);
            };

            if (!_preview)
            {
                return;
            };

            var _local_3:IBitmapWrapperWindow = (_preview.findChildByName("image") as IBitmapWrapperWindow);

            if (!_local_3)
            {
                return;
            };

            switch (_local_4.productType)
            {
                case "s":
                    _local_6 = page.viewer.roomEngine.getFurnitureImage(_local_4.productClassId, new Vector3d(90), 64, null, 0, _local_4.extraParam);
                    break;
                case "i":
                    _local_6 = page.viewer.roomEngine.getWallItemImage(_local_4.productClassId, new Vector3d(90), 64, null, 0, _local_4.extraParam);
                    break;
                default:
                    return;
            };

            if (((!(_local_6)) || (!(_local_6.data))))
            {
                return;
            };

            _local_3.width = _local_6.data.width;
            _local_3.height = _local_6.data.height;

            if (_local_3.bitmap)
            {
                _local_3.bitmap.dispose();
            };

            _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height);
            _local_3.bitmap.draw(_local_6.data);
            _local_6.data.dispose();

            var _local_5:Point = Point.interpolate(_arg_2.topLeft, _arg_2.bottomRight, 0.5);
            _preview.setGlobalPosition(_local_5.subtract(new Point((_preview.width / 2), (_preview.height / 2))));
            _preview.visible = true;
            _preview.activate();
        }

        private function hidePreview():void
        {
            if (_preview)
            {
                _preview.visible = false;
            };
        }

        private function createWindow(_arg_1:String):IWindow
        {
            if ((((!(_controller)) || (!(_controller.assets))) || (!(_controller.windowManager))))
            {
                return (null);
            };

            var _local_3:XmlAsset = (_controller.assets.getAssetByName(_arg_1) as XmlAsset);

            if (((!(_local_3)) || (!(_local_3.content))))
            {
                return (null);
            };

            var _local_2:XML = (_local_3.content as XML);

            if (!_local_2)
            {
                return (null);
            };

            return (_controller.windowManager.buildFromXML(_local_2));
        }

    }
}
