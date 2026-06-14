package com.sulake.habbo.toolbar
{
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.toolbar.extensions.PurseAreaExtension;
    import com.sulake.habbo.toolbar.extensions.SettingsExtension;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.navigator.IHabboNewNavigator;
    import com.sulake.habbo.toolbar.extensions.purse.indicators.SeasonalCurrencyIndicator;
    import com.sulake.habbo.toolbar.extensions.ClubDiscountPromoExtension;
    import com.sulake.habbo.toolbar.extensions.CitizenshipVipQuestsPromoExtension;
    import com.sulake.habbo.toolbar.extensions.CitizenshipVipDiscountPromoExtension;
    import com.sulake.habbo.toolbar.extensions.VideoOfferExtension;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.toolbar.offers.OfferExtension;
    import flash.utils.Timer;
    import com.sulake.habbo.phonenumber.HabboPhoneNumber;
    import com.sulake.iid.IIDHabboPhoneNumber;
    import com.sulake.habbo.nux.HabboNuxDialogs;
    import com.sulake.iid.IIDHabboNuxDialogs;
    import com.sulake.habbo.campaign.HabboCampaigns;
    import com.sulake.iid.IIDHabboCampaigns;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDCoreLocalizationManager;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboFreeFlowChat;
    import com.sulake.iid.IIDHabboRoomUI;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboQuestEngine;
    import com.sulake.iid.IIDHabboMessenger;
    import com.sulake.iid.IIDHabboGroupForumController;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboNewNavigator;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import com.sulake.habbo.session.events.PerksUpdatedEvent;
    import com.sulake.habbo.catalog.event.CatalogEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.room.utils.RoomEnterEffect;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.purse.PurseEvent;
    import com.sulake.core.window.IWindow;
    import flash.geom.Rectangle;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.habbo.messenger.events.MiniMailMessageEvent;
    import com.sulake.habbo.quest.events.UnseenAchievementsCountUpdateEvent;
    import com.sulake.habbo.friendbar.groupforums.UnseenForumsCountUpdatedEvent;
    import com.sulake.habbo.inventory.events.HabboUnseenItemsUpdatedEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.core.runtime.CoreComponentContext;

    public class HabboToolbar extends Component implements IHabboToolbar 
    {

        private var _windowManager:IHabboWindowManager;
        private var _communicationManager:IHabboCommunicationManager;
        private var _view:BottomBarLeft;
        private var _bottomBarBackground:BottomBackgroundBorder;
        private var _isInitialized:Boolean;
        private var _purseExtension:PurseAreaExtension;
        private var _settingsExtension:SettingsExtension;
        private var _connection:IConnection;
        private var _catalog:IHabboCatalog;
        private var _messenger:IHabboMessenger;
        private var _navigator:IHabboNavigator;
        private var _newNavigator:IHabboNewNavigator;
        private var _seasonalCurrencyExtension:SeasonalCurrencyIndicator;
        private var _clubDiscountPromoExtension:ClubDiscountPromoExtension;
        private var _citizenShipVipQuestsPromo:CitizenshipVipQuestsPromoExtension;
        private var _citizenshipVipExtendPromo:CitizenshipVipDiscountPromoExtension;
        private var _videoOfferExtension:VideoOfferExtension;
        private var _localization:ICoreLocalizationManager;
        private var _inventory:IHabboInventory;
        private var _extensionView:ExtensionView;
        private var _soundManager:IHabboSoundManager;
        private var _sessionDataManager:ISessionDataManager;
        private var _habboHelp:IHabboHelp;
        private var _avatarRenderManager:IAvatarRenderManager;
        private var _questEngine:IHabboQuestEngine;
        private var _freeFlowChat:IHabboFreeFlowChat;
        private var _roomUI:IRoomUI;
        private var _offerExtension:OfferExtension;
        private var _removeDimmerTimer:Timer;
        private var _clientPromoTimer:Timer;
        private var _ownRoomPromoTimer:Timer;

        public function HabboToolbar(_arg_1:IContext, _arg_2:uint=0, _arg_3:IAssetLibrary=null)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_1.attachComponent(new HabboPhoneNumber(_arg_1, 0, _arg_3), [new IIDHabboPhoneNumber()]);
            _arg_1.attachComponent(new HabboNuxDialogs(_arg_1, 0, _arg_3), [new IIDHabboNuxDialogs()]);
            _arg_1.attachComponent(new HabboCampaigns(_arg_1, 0, _arg_3), [new IIDHabboCampaigns()]);
        }

        override protected function get dependencies():Vector.<ComponentDependency>
        {
            return (super.dependencies.concat(new <ComponentDependency>[new ComponentDependency(new IIDHabboConfigurationManager(), null, true, [{
                "type":"complete",
                "callback":onConfigurationComplete
            }]), new ComponentDependency(new IIDHabboCommunicationManager(), function (_arg_1:IHabboCommunicationManager):void
            {
                _communicationManager = _arg_1;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (_arg_1:IHabboWindowManager):void
            {
                _windowManager = _arg_1;
            }, true), new ComponentDependency(new IIDHabboCatalog(), function (_arg_1:IHabboCatalog):void
            {
                _catalog = _arg_1;
            }, true, [{
                "type":"CATALOG_INITIALIZED",
                "callback":onCatalogEvent
            }, {
                "type":"CATALOG_NOT_READY",
                "callback":onCatalogEvent
            }, {
                "type":"CATALOG_NEW_ITEMS_SHOW",
                "callback":onCatalogEvent
            }, {
                "type":"CATALOG_NEW_ITEMS_HIDE",
                "callback":onCatalogEvent
            }]), new ComponentDependency(new IIDCoreLocalizationManager(), function (_arg_1:ICoreLocalizationManager):void
            {
                _localization = _arg_1;
            }), new ComponentDependency(new IIDHabboInventory(), function (_arg_1:IHabboInventory):void
            {
                _inventory = _arg_1;
            }, false, [{
                "type":"HUIUE_UNSEEN_ITEMS_CHANGED",
                "callback":onUnseenItemsUpdate
            }, {
                "type":"HIHCE_HABBO_CLUB_CHANGED",
                "callback":onClubChanged
            }]), new ComponentDependency(new IIDHabboSoundManager(), function (_arg_1:IHabboSoundManager):void
            {
                _soundManager = _arg_1;
            }), new ComponentDependency(new IIDSessionDataManager(), function (_arg_1:ISessionDataManager):void
            {
                _sessionDataManager = _arg_1;
            }, true, [{
                "type":"PUE_perks_updated",
                "callback":onPerksUpdated
            }]), new ComponentDependency(new IIDHabboHelp(), function (_arg_1:IHabboHelp):void
            {
                _habboHelp = _arg_1;
            }, false), new ComponentDependency(new IIDHabboFreeFlowChat(), function (_arg_1:IHabboFreeFlowChat):void
            {
                _freeFlowChat = _arg_1;
            }, false), new ComponentDependency(new IIDHabboRoomUI(), function (_arg_1:IRoomUI):void
            {
                _roomUI = _arg_1;
            }, false), new ComponentDependency(new IIDAvatarRenderManager(), function (_arg_1:IAvatarRenderManager):void
            {
                _avatarRenderManager = _arg_1;
            }, false), new ComponentDependency(new IIDHabboQuestEngine(), function (_arg_1:IHabboQuestEngine):void
            {
                _questEngine = _arg_1;
            }, false, [{
                "type":"qe_uacue",
                "callback":onUnseenAchievementsCountUpdate
            }]), new ComponentDependency(new IIDHabboMessenger(), function (_arg_1:IHabboMessenger):void
            {
                _messenger = _arg_1;
            }, false, [{
                "type":"MMME_new",
                "callback":onMiniMailUpdate
            }, {
                "type":"MMME_unread",
                "callback":onMiniMailUpdate
            }, {
                "type":"HUIUE_UNSEEN_ITEMS_CHANGED",
                "callback":onUnseenItemsUpdate
            }]), new ComponentDependency(new IIDHabboGroupForumController(), null, false, [{
                "type":"UNSEEN_FORUMS_COUNT",
                "callback":onUnseenForumsCountUpdate
            }]), new ComponentDependency(new IIDHabboNavigator(), function (_arg_1:IHabboNavigator):void
            {
                _navigator = _arg_1;
            }, false), new ComponentDependency(new IIDHabboNewNavigator(), function (_arg_1:IHabboNewNavigator):void
            {
                _newNavigator = _arg_1;
            }, false)]));
        }

        override public function dispose():void
        {
            _isInitialized = false;
            _connection = null;
            destroyClientPromoTimer();
            destroyDimmerTimer();
            destroyOwnRoomPromoTimer();

            if (_extensionView)
            {
                _extensionView.dispose();
                _extensionView = null;
            };

            if (_purseExtension)
            {
                _purseExtension.dispose();
                _purseExtension = null;
            };

            if (_settingsExtension)
            {
                _settingsExtension.dispose();
                _settingsExtension = null;
            };

            if (_offerExtension != null)
            {
                _offerExtension.dispose();
                _offerExtension = null;
            };

            if (_clubDiscountPromoExtension)
            {
                _clubDiscountPromoExtension.dispose();
                _clubDiscountPromoExtension = null;
            };

            if (_citizenShipVipQuestsPromo)
            {
                _citizenShipVipQuestsPromo.dispose();
                _citizenShipVipQuestsPromo = null;
            };

            if (_citizenshipVipExtendPromo)
            {
                _citizenshipVipExtendPromo.dispose();
                _citizenshipVipExtendPromo = null;
            };

            if (_videoOfferExtension)
            {
                _videoOfferExtension.dispose();
                _videoOfferExtension = null;
            };

            if (_messenger != null)
            {
                if (_messenger.events)
                {
                    _messenger.events.removeEventListener("MMME_new", onMiniMailUpdate);
                    _messenger.events.removeEventListener("MMME_unread", onMiniMailUpdate);
                };

                _messenger = null;
            };

            if (_view != null)
            {
                _view.dispose();
                _view = null;
            };

            super.dispose();
        }

        private function onConfigurationComplete(_arg_1:Event):void
        {
        }

        override protected function initComponent():void
        {
            var _local_1:int;
            var _local_2:int;
            _connection = _communicationManager.connection;
            _communicationManager.addHabboConnectionMessageEvent(new UserRightsMessageEvent(onUserRights));
            _bottomBarBackground = new BottomBackgroundBorder(this);
            _view = new BottomBarLeft(this, _windowManager, assets, events);
            _view.window.visible = false;
            initRoomEnterEffect();
            _extensionView = new ExtensionView(_windowManager, assets, this);

            if (_view == null)
            {
                Logger.log("Error, toolbar view was not available");
                return;
            };

            var _local_3:String = getProperty("new.user.wing");

            if (_local_3 != "")
            {
                _local_1 = (getInteger("new.user.promo.delay", 10) * 1000);

                if (((_local_1 > 0) && (_clientPromoTimer == null)))
                {
                    _clientPromoTimer = new Timer(_local_1, 1);
                    _clientPromoTimer.addEventListener("timerComplete", onShowClientPromo);
                    _clientPromoTimer.start();
                };

                if (((((_local_3 == "social") || (_local_3 == "quest")) || (_local_3 == "group")) || (_local_3 == "game")))
                {
                    _local_2 = (getInteger("new.user.promo.room.delay", 180) * 1000);

                    if (((_local_2 > 0) && (_ownRoomPromoTimer == null)))
                    {
                        _ownRoomPromoTimer = new Timer(_local_2, 1);
                        _ownRoomPromoTimer.addEventListener("timerComplete", onShowOwnRoomPromo);
                        _ownRoomPromoTimer.start();
                    };
                };
            };
        }

        private function onPerksUpdated(_arg_1:PerksUpdatedEvent):void
        {
            if (((_extensionView) && (!(_isInitialized))))
            {
                initPurseAreaExtension();
                initSeasonalCurrencyExtension();
                initVipExtendExtension();
                initCitizenshipVipExtendExtension();
                initCitizenshipVipQuestsExtension();
                initVideoOfferExtension();
                initOfferExtension();
                initSettingsExtension();
                _isInitialized = true;
            };
        }

        private function onCatalogEvent(_arg_1:CatalogEvent):void
        {
            if (_view)
            {
                _view.onCatalogEvent(_arg_1);
            };
        }

        private function onUserRights(_arg_1:IMessageEvent):void
        {
            if (!_videoOfferExtension)
            {
                initVideoOfferExtension();
            };
        }

        private function onShowClientPromo(_arg_1:TimerEvent):void
        {
            var _local_3:String;
            var _local_2:String;
            destroyClientPromoTimer();

            var _local_5:String = getProperty("new.user.wing");
            var _local_4:int;
            var _local_6:String;
            switch (_local_5)
            {
                case "social":
                    _local_3 = "new.user.promo.social";
                    _local_2 = "HTIE_ICON_NAVIGATOR";
                    _local_6 = "NAVIGATOR";
                    break;
                case "group":
                    _local_3 = "new.user.promo.group";
                    _local_2 = "HTIE_EXT_GROUP";
                    _local_4 = 1;
                    break;
                case "quest":
                    _local_3 = "new.user.promo.quest";
                    _local_2 = "HTIE_ICON_QUESTS";
                    _local_6 = "QUESTS";
                    break;
                case "game":
                    _local_3 = "new.user.promo.game";
                    _local_2 = "HTIE_ICON_GAMES";
                    _local_6 = "GAMES";
                    break;
                default:
                    return;
            };

            if (getIconLocation(_local_2) != null)
            {
                _habboHelp.showWelcomeScreen(_local_2, _local_3, _local_4, _local_6);
            };
        }

        private function onShowOwnRoomPromo(_arg_1:TimerEvent):void
        {
            destroyOwnRoomPromoTimer();
            _habboHelp.showWelcomeScreen("HTIE_ICON_NAVIGATOR", "new.user.promo.room", 0, "NAVIGATOR_ME_TAB");
        }

        private function initRoomEnterEffect():void
        {
            var _local_1:int;
            var _local_2:int;

            if (!isNewIdentity())
            {
                return;
            };

            if (getBoolean("room.enter.effect.enabled"))
            {
                _local_1 = getInteger("room.enter.effect.delay", 4000);
                _local_2 = getInteger("room.enter.effect.duration", 2000);
                RoomEnterEffect.init(_local_1, _local_2);
                createAndAttachDimmerWindow(IWindowContainer(_view.window));

                if (_removeDimmerTimer == null)
                {
                    _removeDimmerTimer = new Timer((_local_1 + _local_2), 1);
                    _removeDimmerTimer.addEventListener("timerComplete", onRemoveDimmer);
                    _removeDimmerTimer.start();
                };
            };
        }

        private function initPurseAreaExtension():void
        {
            _purseExtension = new PurseAreaExtension(this, _catalog);
            _purseExtension.getClubArea().onClubChanged();
        }

        private function initSettingsExtension():void
        {
            _settingsExtension = new SettingsExtension(this);
        }

        private function initSeasonalCurrencyExtension():void
        {
            var _local_1:PurseEvent;

            if (getBoolean("seasonalcurrencyindicator.enabled"))
            {
                _seasonalCurrencyExtension = new SeasonalCurrencyIndicator(this, _windowManager, assets, _catalog, _localization);
                _local_1 = new PurseEvent("catalog_purse_activity_point_balance", _catalog.getPurse().getActivityPointsForType(101), 101);
                _seasonalCurrencyExtension.onBalance(_local_1);
            };
        }

        private function initVipExtendExtension():void
        {
            if (getBoolean("club.membership.extend.vip.promotion.enabled"))
            {
                _clubDiscountPromoExtension = new ClubDiscountPromoExtension(this);
            };
        }

        private function initCitizenshipVipQuestsExtension():void
        {
            if (getBoolean("citizenship.vip.quest.promotion.enabled"))
            {
                _citizenShipVipQuestsPromo = new CitizenshipVipQuestsPromoExtension(this, _windowManager, assets, events, _localization, _connection);
            };
        }

        private function initCitizenshipVipExtendExtension():void
        {
            if (getBoolean("club.membership.extend.vip.promotion.enabled"))
            {
                _citizenshipVipExtendPromo = new CitizenshipVipDiscountPromoExtension(this);
            };
        }

        private function initVideoOfferExtension():void
        {
            var _local_1:Boolean = ((!(isNewIdentity())) || (!(getBoolean("new.identity.hide.ui"))));

            if ((((_catalog.videoOffers.enabled) && (getBoolean("toolbar.extension.video.promo.enabled"))) && (_local_1)))
            {
                _videoOfferExtension = new VideoOfferExtension(this);
            };
        }

        private function initOfferExtension():void
        {
            var _local_1:Boolean = ((!(isNewIdentity())) || (!(getBoolean("new.identity.hide.ui"))));

            if ((((getBoolean("offers.enabled")) && (_local_1)) && (!(getBoolean("offers.habboclub.enabled")))))
            {
                _offerExtension = new OfferExtension(this, _windowManager, assets, _catalog);
            };
        }

        public function toggleSettingVisibility():void
        {
            if (((_settingsExtension) && (_settingsExtension.window)))
            {
                _settingsExtension.window.visible = (!(_settingsExtension.window.visible));
            };

            extensionView.refreshItemWindow();
        }

        private function onRemoveDimmer(_arg_1:TimerEvent):void
        {
            destroyDimmerTimer();

            if (_view)
            {
                removeDimmer((_view.window as IWindowContainer));
            };

            if (_extensionView)
            {
                _extensionView.removeDimmers();
            };
        }

        public function createAndAttachDimmerWindow(_arg_1:IWindowContainer):void
        {
            var _local_2:IWindow;

            if (RoomEnterEffect.isRunning())
            {
                if (_arg_1 == null)
                {
                    return;
                };

                _local_2 = _windowManager.createWindow("toolbar_dimmer", "", 30, 1, ((0x80 | 0x0800) | 0x01), new Rectangle(0, 0, _arg_1.width, _arg_1.height), null, 0);
                _local_2.color = 0;
                _local_2.blend = 0.3;
                _arg_1.addChild(_local_2);
                _arg_1.invalidate();
            };
        }

        public function removeDimmer(_arg_1:IWindowContainer):void
        {
            if (_arg_1 == null)
            {
                return;
            };

            var _local_2:IWindow = _arg_1.findChildByName("toolbar_dimmer");

            if (_local_2 != null)
            {
                _arg_1.removeChild(_local_2);
                _arg_1.invalidate();
                _windowManager.destroy(_local_2);
            };
        }

        public function toggleWindowVisibility(_arg_1:String):void
        {
            var _local_4:HabboToolbarEvent;
            var _local_5:HabboToolbarEvent;
            var _local_2:String = HabboToolbarIconEnum[_arg_1];

            if (_local_2 == "HTIE_ICON_CAMERA")
            {
                _local_4 = new HabboToolbarEvent("HTE_ICON_CAMERA");
                _local_4.iconName = "toolBarCameraIcon";
                events.dispatchEvent(_local_4);
            }

            else
            {
                _local_5 = new HabboToolbarEvent("HTE_TOOLBAR_CLICK");
                _local_5.iconId = _local_2;
                _local_5.iconName = _arg_1;
                events.dispatchEvent(_local_5);
            };

            var _local_3:EventLogMessageComposer = new EventLogMessageComposer("Toolbar", _arg_1, "client.toolbar.clicked");

            if (_connection)
            {
                _connection.send(_local_3);
            };
        }

        public function getIconLocation(_arg_1:String):Rectangle
        {
            var _local_2:Rectangle;

            if (_arg_1 == "HTIE_EXT_GROUP")
            {
                _local_2 = _extensionView.getIconLocation(_arg_1);
            }

            else
            {
                if (_view)
                {
                    _local_2 = _view.getIconLocation(_arg_1);
                };
            };

            if (((!(_local_2)) && (_purseExtension)))
            {
                _local_2 = _purseExtension.getIconLocation(_arg_1);
            };

            return (_local_2);
        }

        public function getIcon(_arg_1:String):IWindow
        {
            var _local_2:IWindow;

            if (_arg_1 == "HTIE_EXT_GROUP")
            {
                _local_2 = _extensionView.getIcon(_arg_1);
            }

            else
            {
                if (_view)
                {
                    _local_2 = _view.geIcon(_arg_1);
                    (trace(_arg_1, _local_2));

                    if ((_local_2 as IStaticBitmapWrapperWindow))
                    {
                        _local_2 = _local_2.parent;
                    };

                    (trace("toka", _local_2));
                };
            };

            if (((!(_local_2)) && (_purseExtension)))
            {
                _local_2 = _purseExtension.getIcon(_arg_1);
            };

            return (_local_2);
        }

        public function setUnseenItemCount(_arg_1:String, _arg_2:int):void
        {
            if (_view)
            {
                _view.setUnseenItemCount(_arg_1, _arg_2);
            };
        }

        public function setToolbarState(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case "HTE_STATE_HOTEL_VIEW":
                case "HTE_STATE_GAME_CENTER_VIEW":
                    showExtensions(true);
                    break;
                case "HTE_STATE_ROOM_VIEW":
                    showExtensions(true);
                    break;
                case "HTE_STATE_HIDDEN":
                    showExtensions(false);
            };

            if (_extensionView != null)
            {
                _extensionView.landingView = (_arg_1 == "HTE_STATE_HOTEL_VIEW");
            };

            if (_view)
            {
                _view.setToolbarState(_arg_1);
                _view.window.visible = true;
            };

            if (_habboHelp != null)
            {
                _habboHelp.outsideRoom = (!(_arg_1 == "HTE_STATE_ROOM_VIEW"));
            };

            var _local_2:HabboToolbarEvent = new HabboToolbarEvent("HTE_RESIZED");
            events.dispatchEvent(_local_2);
        }

        private function showExtensions(_arg_1:Boolean):void
        {
            if (_extensionView)
            {
                _extensionView.visible = _arg_1;
            };
        }

        public function setIconBitmap(_arg_1:String, _arg_2:BitmapData):void
        {
            var _local_3:BitmapData;

            if (_arg_2 != null)
            {
                _local_3 = _arg_2.clone();
            };

            if (_view)
            {
                _view.setIconBitmap(_arg_1, _arg_2);
            };
        }

        public function getRect():Rectangle
        {
            if (_view)
            {
                return (_view.window.rectangle);
            };

            return (new Rectangle());
        }

        public function get extensionView():IExtensionView
        {
            return (_extensionView);
        }

        public function get soundManager():IHabboSoundManager
        {
            return (_soundManager);
        }

        public function createTransitionToIcon(_arg_1:String, _arg_2:BitmapData, _arg_3:int, _arg_4:int):Motion
        {
            if (((_view) && (!(_view.disposed))))
            {
                return (_view.animateToIcon(_arg_1, _arg_2, _arg_3, _arg_4));
            };

            _arg_2.dispose();
            return (null);
        }

        public function isXmasEnabled():Boolean
        {
            return (getBoolean("xmas11.enabled"));
        }

        public function isValentinesEnabled():Boolean
        {
            return (getBoolean("valentines.enabled"));
        }

        public function isNewIdentity():Boolean
        {
            return (getInteger("new.identity", 0) > 0);
        }

        public function setIconVisibility(_arg_1:String, _arg_2:Boolean):void
        {
            if (_view)
            {
                _view.iconVisibility(_arg_1, _arg_2);
            };
        }

        private function destroyDimmerTimer():void
        {
            if (_removeDimmerTimer)
            {
                _removeDimmerTimer.removeEventListener("timerComplete", onRemoveDimmer);
                _removeDimmerTimer.stop();
                _removeDimmerTimer = null;
            };
        }

        private function destroyClientPromoTimer():void
        {
            if (_clientPromoTimer)
            {
                _clientPromoTimer.removeEventListener("timerComplete", onShowClientPromo);
                _clientPromoTimer.stop();
                _clientPromoTimer = null;
            };
        }

        private function destroyOwnRoomPromoTimer():void
        {
            if (_ownRoomPromoTimer)
            {
                _ownRoomPromoTimer.removeEventListener("timerComplete", onShowOwnRoomPromo);
                _ownRoomPromoTimer.stop();
                _ownRoomPromoTimer = null;
            };
        }

        private function onMiniMailUpdate(_arg_1:MiniMailMessageEvent):void
        {
            if (((!(_messenger)) || (!(_view))))
            {
                return;
            };

            if (_view != null)
            {
                _view.unseenMiniMailMessageCount = _messenger.getUnseenMiniMailMessageCount();
                _view.memenu.unseenMinimailsCount = _messenger.getUnseenMiniMailMessageCount();
                setUnseenItemCount("HTIE_ICON_MEMENU", _view.unseenMeMenuCount);
            };
        }

        private function onUnseenAchievementsCountUpdate(_arg_1:UnseenAchievementsCountUpdateEvent):void
        {
            if (_view != null)
            {
                _view.unseenAchievementCount = _arg_1.count;
                _view.memenu.unseenAchievementsCount = _arg_1.count;
                setUnseenItemCount("HTIE_ICON_MEMENU", _view.unseenMeMenuCount);
            };
        }

        private function onUnseenForumsCountUpdate(_arg_1:UnseenForumsCountUpdatedEvent):void
        {
            if (_view != null)
            {
                _view.unseenForumsCount = _arg_1.unseenForumsCount;
                _view.memenu.unseenForumsCount = _arg_1.unseenForumsCount;
                setUnseenItemCount("HTIE_ICON_MEMENU", _view.unseenMeMenuCount);
            };
        }

        public function set onDuty(_arg_1:Boolean):void
        {
            if (_view != null)
            {
                _view.onDuty = _arg_1;
            };
        }

        private function onUnseenItemsUpdate(_arg_1:HabboUnseenItemsUpdatedEvent):void
        {
            setUnseenItemCount("HTIE_ICON_INVENTORY", _arg_1.inventoryCount);
            setUnseenItemCount("HTIE_ICON_GAMES", _arg_1.getCategoryCount(6));
        }

        public function onClubChanged(_arg_1:HabboInventoryHabboClubEvent):void
        {
            if (_purseExtension != null)
            {
                _purseExtension.getClubArea().onClubChanged(_arg_1);
            };

            if (_citizenshipVipExtendPromo != null)
            {
                _citizenshipVipExtendPromo.onClubChanged(_arg_1);
            };

            if (_videoOfferExtension != null)
            {
                _videoOfferExtension.onClubChanged(_arg_1);
            };

            if (_clubDiscountPromoExtension != null)
            {
                _clubDiscountPromoExtension.onClubChanged(_arg_1);
            };
        }

        public function get toolBarAreaWidth():int
        {
            if (_view)
            {
                return (_view.getToolbarAreaWidth());
            };

            return (0);
        }

        public function get windowManager():IHabboWindowManager
        {
            return (_windowManager);
        }

        public function get avatarRenderManager():IAvatarRenderManager
        {
            return (_avatarRenderManager);
        }

        public function get sessionDataManager():ISessionDataManager
        {
            return (_sessionDataManager);
        }

        public function get communicationManager():IHabboCommunicationManager
        {
            return (_communicationManager);
        }

        public function get connection():IConnection
        {
            return (_connection);
        }

        public function get navigator():IHabboNavigator
        {
            if (_newNavigator != null)
            {
                return (_newNavigator.legacyNavigator);
            };

            return (null);
        }

        public function get questEngine():IHabboQuestEngine
        {
            return (_questEngine);
        }

        public function get freeFlowChat():IHabboFreeFlowChat
        {
            return (_freeFlowChat);
        }

        public function get roomUI():IRoomUI
        {
            return (_roomUI);
        }

        public function get inventory():IHabboInventory
        {
            return (_inventory);
        }

        public function get localization():ICoreLocalizationManager
        {
            return (_localization);
        }

        public function get catalog():IHabboCatalog
        {
            return (_catalog);
        }

        public function get messenger():IHabboMessenger
        {
            return (_messenger);
        }

        public function reboot():void
        {
            (context as CoreComponentContext).reboot();
        }

    }
}
