package com.sulake.habbo.moderation
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;

    public class OpenRoomInSpectatorMode 
    {

        private var _main:ModerationManager;
        private var _roomId:int;

        public function OpenRoomInSpectatorMode(_arg_1:ModerationManager, _arg_2:IWindow, _arg_3:int)
        {
            _main = _arg_1;
            _roomId = _arg_3;
            _arg_2.procedure = onClick;
        }

        private function onClick(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            _main.goToRoom(_roomId);
        }

    }
}
