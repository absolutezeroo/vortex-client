package com.sulake.habbo.catalog.club
{
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;

    public class ClubGiftConfirmationDialog 
    {

        private var _offer:IPurchasableOffer;
        private var _controller:ClubGiftController;
        private var _view:IFrameWindow;

        public function ClubGiftConfirmationDialog(_arg_1:ClubGiftController, _arg_2:IPurchasableOffer)
        {
            _offer = _arg_2;
            _controller = _arg_1;
            showConfirmation();
        }

        public function dispose():void
        {
            _controller = null;
            _offer = null;

            if (_view)
            {
                _view.dispose();
                _view = null;
            };
        }

        public function showConfirmation():void
        {
            if (((!(_offer)) || (!(_controller))))
            {
                return;
            };

            _view = (createWindow("club_gift_confirmation") as IFrameWindow);

            if (!_view)
            {
                return;
            };

            _view.procedure = windowEventHandler;
            _view.center();

            var _local_2:ITextWindow = (_view.findChildByName("item_name") as ITextWindow);

            if (_local_2)
            {
                _local_2.text = getProductName();
            };

            var _local_1:IWindowContainer = (_view.findChildByName("image_border") as IWindowContainer);

            if (!_local_1)
            {
                return;
            };

            if (!_offer.productContainer)
            {
                return;
            };

            _offer.productContainer.view = _local_1;
            _offer.productContainer.initProductIcon(_controller.roomEngine);
        }

        private function getProductName():String
        {
            var _local_1:IProductData;

            if (((_offer) && (_offer.product)))
            {
                _local_1 = _offer.product.productData;

                if (_local_1)
                {
                    return (_local_1.name);
                };
            };

            return ("");
        }

        private function windowEventHandler(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (((((!(_arg_1)) || (!(_arg_2))) || (!(_controller))) || (!(_offer))))
            {
                return;
            };

            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            switch (_arg_2.name)
            {
                case "select_button":
                    _controller.confirmSelection(_offer.localizationId);
                    return;
                case "header_button_close":
                case "cancel_button":
                    _controller.closeConfirmation();
                    return;
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
