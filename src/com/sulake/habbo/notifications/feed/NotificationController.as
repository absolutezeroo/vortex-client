package com.sulake.habbo.notifications.feed
{
    import com.sulake.habbo.notifications.HabboNotifications;
    import com.sulake.habbo.notifications.feed.view.content.EntityFactory;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.notifications.feed.view.content.IFeedEntity;
    import com.sulake.habbo.notifications.feed.data.GenericNotificationItemData;
    import com.sulake.habbo.utils.HabboWebTools;

    public class NotificationController 
    {

        private var _component:HabboNotifications;
        private var _baseView:NotificationView;
        private var _settings:FeedSettings;
        private var _entityFactory:EntityFactory;

        public function NotificationController(_arg_1:HabboNotifications)
        {
            _component = _arg_1;
            _settings = new FeedSettings(this);
            _baseView = new NotificationView(this, _arg_1);
            _entityFactory = new EntityFactory();
            _component.roomSessionManager.events.addEventListener("RSE_CREATED", roomSessionStateEventHandler);
            _component.roomSessionManager.events.addEventListener("RSE_STARTED", roomSessionStateEventHandler);
            _component.roomSessionManager.events.addEventListener("RSE_ENDED", roomSessionStateEventHandler);
        }

        public function dispose():void
        {
            if (_baseView)
            {
                _baseView.dispose();
                _baseView = null;
            };

            _component.roomSessionManager.events.removeEventListener("RSE_CREATED", roomSessionStateEventHandler);
            _component.roomSessionManager.events.removeEventListener("RSE_STARTED", roomSessionStateEventHandler);
            _component.roomSessionManager.events.removeEventListener("RSE_ENDED", roomSessionStateEventHandler);
            _component = null;

            if (_settings)
            {
                _settings.dispose();
                _settings = null;
            };

            if (_entityFactory)
            {
                _entityFactory.dispose();
                _entityFactory = null;
            };
        }

        private function roomSessionStateEventHandler(_arg_1:RoomSessionEvent):void
        {
            switch (_arg_1.type)
            {
                case "RSE_CREATED":
                case "RSE_STARTED":
                case "RSE_ENDED":

                    if (_baseView)
                    {
                        _baseView.setGameMode(_arg_1.session.isGameSession);
                    };

                    return;
            };
        }

        public function setFeedEnabled(_arg_1:Boolean):void
        {
            if (_baseView)
            {
                _baseView.setViewEnabled(_arg_1);
            };
        }

        public function getSettings():FeedSettings
        {
            return (_settings);
        }

        public function updateFeedCategoryFiltering():void
        {
        }

        public function addFeedItem(_arg_1:int, _arg_2:GenericNotificationItemData):void
        {
            var _local_3:IFeedEntity = _entityFactory.createNotificationEntity(_arg_2);
            _baseView.addNotificationFeedItem(_arg_1, _local_3);
        }

        public function executeAction(_arg_1:String):void
        {
            if (_arg_1.indexOf("http") == 0)
            {
                HabboWebTools.openWebPage(_arg_1);
            };
        }

    }
}
