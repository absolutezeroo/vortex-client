package com.sulake.habbo.notifications.feed
{
    import __AS3__.vec.Vector;

    public class FeedSettings 
    {

        public static const _SafeStr_3017:int = 0;
        public static const _SafeStr_3018:int = 1;
        public static const _SafeStr_3019:int = 2;
        public static const _SafeStr_3020:int = 3;
        public static const FEED_CATEGORY_ME:int = 0;
        public static const _SafeStr_3021:int = 1;
        public static const FEED_CATEGORY_HOTEL:int = 2;

        private var _feed:NotificationController;
        private var _visibleFeedCategories:Vector.<int>;

        public function FeedSettings(_arg_1:NotificationController)
        {
            _visibleFeedCategories = new Vector.<int>();
            _visibleFeedCategories.push(1);
            _visibleFeedCategories.push(0);
            _visibleFeedCategories.push(2);
        }

        public function dispose():void
        {
            _feed = null;
            _visibleFeedCategories = null;
        }

        public function getVisibleFeedCategories():Vector.<int>
        {
            return (_visibleFeedCategories);
        }

        public function toggleVisibleFeedCategory(_arg_1:int):void
        {
            _feed.updateFeedCategoryFiltering();
        }

    }
}
