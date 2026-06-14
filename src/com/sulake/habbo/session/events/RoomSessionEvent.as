package com.sulake.habbo.session.events
{
    import flash.events.Event;
    import com.sulake.habbo.session.IRoomSession;

    public class RoomSessionEvent extends Event 
    {

        public static const _SafeStr_3683:String = "RSE_CREATED";
        public static const _SafeStr_3684:String = "RSE_STARTED";
        public static const _SafeStr_3685:String = "RSE_ENDED";
        public static const SESSION_ROOM_DATA:String = "RSE_ROOM_DATA";

        private var _session:IRoomSession;
        private var _openLandingPage:Boolean;

        public function RoomSessionEvent(_arg_1:String, session:IRoomSession, _arg_3:Boolean=true, bubbles:Boolean=false, cancellable:Boolean=false)
        {
            super(_arg_1, bubbles, cancellable);
            _session = session;
            _openLandingPage = _arg_3;
        }

        public function get session():IRoomSession
        {
            return (_session);
        }

        public function get openLandingPage():Boolean
        {
            return (_openLandingPage);
        }

    }
}
