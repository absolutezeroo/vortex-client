package com.sulake.habbo.friendbar.landingview.widget
{
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.landingview.PromoArticlesMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.landingview._SafeStr_43;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.habbo.communication.messages.incoming.landingview.PromoArticleData;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.events.WindowEvent;

    public class PromoArticleWidget implements ILandingViewWidget, ISettingsAwareWidget, IUpdateReceiver 
    {

        private static const REFRESH_PERIOD_IN_MILLIS:Number = 600000;
        private static const FADE_LENGTH:Number = 500;
        private static const MAX_ARTICLES:int = 10;

        private var _landingView:HabboLandingView;
        private var _container:IWindowContainer;
        private var _currentArticle:int = 0;
        private var _articles:Array = [];
        private var _lastRequestTime:Date;
        private var _articlesListener:IMessageEvent;
        private var _fadePhase:uint = 0;

        public function PromoArticleWidget(_arg_1:HabboLandingView)
        {
            _landingView = _arg_1;
        }

        public function initialize():void
        {
            _container = IWindowContainer(_landingView.getXmlWindow("promo_article"));
            _container.procedure = onMouse;
            _articlesListener = new PromoArticlesMessageEvent(onPromoArticles);
            _landingView.communicationManager.addHabboConnectionMessageEvent(_articlesListener);
        }

        public function refresh():void
        {
            if (((_lastRequestTime == null) || ((_lastRequestTime.time + 600000) < new Date().time)))
            {
                _landingView.send(new _SafeStr_43());
                _lastRequestTime = new Date();
            }

            else
            {
                goToArticle(_currentArticle);
            };
        }

        public function get container():IWindow
        {
            return (_container);
        }

        public function dispose():void
        {
            if (((_articlesListener) && (_landingView)))
            {
                _landingView.communicationManager.removeHabboConnectionMessageEvent(_articlesListener);
                _articlesListener.dispose();
                _articlesListener = null;
            };

            if (_container)
            {
                _container.dispose();
                _container = null;
            };

            _landingView = null;
        }

        public function get disposed():Boolean
        {
            return (_landingView == null);
        }

        public function set settings(_arg_1:CommonWidgetSettings):void
        {
            WidgetContainerLayout.applyCommonWidgetSettings(_container, _arg_1);
        }

        private function refreshContent():void
        {
            setArticleContent();
            setNavigationDisks();
        }

        private function setArticleContent():void
        {
            var _local_1:PromoArticleData = _articles[_currentArticle];

            if (_local_1)
            {
                _container.findChildByName("promo_title").caption = _local_1.title;
                _container.findChildByName("promo_text").caption = _local_1.bodyText;
                _container.findChildByName("button").visible = (!((_local_1.linkType == 2) || ((_local_1.linkType == 0) && (_local_1.linkContent == ""))));
                _container.findChildByName("button").immediateClickMode = true;
                _container.findChildByName("button").caption = _local_1.buttonText;
                _container.findChildByName("promo_image").visible = (!(_local_1.imageUrl == ""));
                try
                {
                    IStaticBitmapWrapperWindow(_container.findChildByName("promo_image")).assetUri = ("${image.library.url}" + _local_1.imageUrl);
                }

                catch(e:Error)
                {
                    _landingView.context.warning(("Missing image url for promo article with title: " + _local_1.title));
                };
            };
        }

        private function setNavigationDisks():void
        {
            var _local_3:int;
            var _local_4:IRegionWindow;
            var _local_2:IStaticBitmapWrapperWindow;
            var _local_1:IWindowContainer = IWindowContainer(_container.findChildByName("navigation"));
            _local_3 = 0;

            while (_local_3 < 10)
            {
                _local_4 = IRegionWindow(_local_1.getChildAt(_local_3));

                if (_articles.length > _local_3)
                {
                    _local_2 = IStaticBitmapWrapperWindow(_local_4.getChildAt(0));
                    _local_2.assetUri = ("progress_disk_flat_" + ((_currentArticle == _local_3) ? "on" : "off"));
                    _local_4.visible = true;
                }

                else
                {
                    _local_4.visible = false;
                };

                _local_3++;
            };
        }

        private function goToArticle(_arg_1:int):void
        {
            var _local_2:Boolean = (_arg_1 == _currentArticle);

            if (_articles.length == 0)
            {
                return;
            };

            if (_arg_1 < 0)
            {
                _currentArticle = (_articles.length - 1);
            }

            else
            {
                if (_arg_1 >= _articles.length)
                {
                    _currentArticle = 0;
                }

                else
                {
                    _currentArticle = _arg_1;
                };
            };

            if (_local_2)
            {
                refreshContent();
            }

            else
            {
                startFade();
            };
        }

        private function startFade():void
        {
            _fadePhase = 0;
            _landingView.registerUpdateReceiver(this, 1);
        }

        private function stopFade():void
        {
            _landingView.removeUpdateReceiver(this);
            setBlend(1);
        }

        private function followLink():void
        {
            var _local_1:PromoArticleData = _articles[_currentArticle];
            switch (_local_1.linkType)
            {
                case 0:
                    HabboWebTools.openWebPage(_local_1.linkContent);
                    return;
                case 1:
                    _landingView.context.createLinkEvent(_local_1.linkContent);
                default:
            };
        }

        private function onMouse(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_2.name == "article_navigation")
            {
                if (_arg_1.type == "WME_OVER")
                {
                    hoverOverNavigation(_arg_2, true);
                }

                else
                {
                    if (((_arg_1.type == "WME_OUT") && (!(_arg_2.id == _currentArticle))))
                    {
                        hoverOverNavigation(_arg_2, false);
                    };
                };
            };

            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            switch (_arg_2.name)
            {
                case "button":
                    followLink();
                    return;
                case "article_navigation":
                    goToArticle(_arg_2.id);
                    return;
            };
        }

        private function hoverOverNavigation(_arg_1:IWindow, _arg_2:Boolean):void
        {
            var _local_3:IStaticBitmapWrapperWindow = IStaticBitmapWrapperWindow(IWindowContainer(_arg_1).getChildAt(0));

            if (!_local_3)
            {
                return;
            };

            _local_3.assetUri = ("progress_disk_flat_" + ((_arg_2) ? "on" : "off"));
        }

        private function onPromoArticles(_arg_1:PromoArticlesMessageEvent):void
        {
            _articles = [];

            for each (var _local_2:PromoArticleData in _arg_1.getParser().articles)
            {
                _articles.push(_local_2);
            };

            refresh();
        }

        private function setBlend(_arg_1:Number):void
        {
            _container.findChildByName("promo_title").blend = _arg_1;
            _container.findChildByName("promo_text").blend = _arg_1;
            _container.findChildByName("button").blend = _arg_1;
            _container.findChildByName("promo_image").blend = _arg_1;
        }

        public function update(_arg_1:uint):void
        {
            var _local_2:uint = (_fadePhase + _arg_1);

            if (_fadePhase < 500)
            {
                setBlend(Math.max(0, (1 - (_fadePhase / 500))));

                if (_local_2 >= 500)
                {
                    refreshContent();
                };
            }

            else
            {
                setBlend(Math.min(1, ((_fadePhase - 500) / 500)));
            };

            _fadePhase = _local_2;

            if (_fadePhase >= (500 * 2))
            {
                stopFade();
            };
        }

    }
}
