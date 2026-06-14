package com.sulake.habbo.help
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.guidehelp.HelpController;
    import com.sulake.habbo.help.guidehelp.GuideSessionController;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.parser.help.data.PendingGuideTicket;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;

    public class GuideHelpManager implements IDisposable 
    {

        private var _habboHelp:HabboHelp;
        private var _guideHelpController:HelpController;
        private var _guideSessionController:GuideSessionController;
        private var _chatReviewReporterFeedbackCtrl:ChatReviewReporterFeedbackCtrl;
        private var _disposed:Boolean = false;
        private var _seenTourPopupDuringSession:Boolean;
        private var _panicRoomId:int;
        private var _panicRoomName:String;
        private var _popupTimer:Timer;

        public function GuideHelpManager(_arg_1:HabboHelp)
        {
            _habboHelp = _arg_1;
            _guideHelpController = new HelpController(this);
            _guideSessionController = new GuideSessionController(this);
            _chatReviewReporterFeedbackCtrl = new ChatReviewReporterFeedbackCtrl(_habboHelp);
            _habboHelp.communicationManager.addHabboConnectionMessageEvent(new RoomEntryInfoMessageEvent(onRoomEnter));
        }

        public function get habboHelp():HabboHelp
        {
            return (_habboHelp);
        }

        private function onRoomEnter(_arg_1:IMessageEvent):void
        {
            if (((((_habboHelp.newUserTourEnabled) && (_habboHelp.newIdentity)) && (!(_seenTourPopupDuringSession))) && (!(_habboHelp.sessionDataManager.isRealNoob))))
            {
                _popupTimer = new Timer(getTourPopupDelay(), 1);
                _popupTimer.addEventListener("timer", onTourPopup);
                _popupTimer.start();
                _habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.create", "", getTourPopupDelay());
                _habboHelp.trackGoogle("newbieTourWindow", "timer_popupCreated");
            };
        }

        private function onTourPopup(_arg_1:TimerEvent):void
        {
            if (_disposed)
            {
                return;
            };

            _habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.show", "", getTourPopupDelay());
            _habboHelp.trackGoogle("newbieTourWindow", "timer_popupShown");
            openTourPopup();
        }

        public function openTourPopup():void
        {
            _guideHelpController.openTourPopup();
            _seenTourPopupDuringSession = true;
        }

        public function dispose():void
        {
            if (_disposed)
            {
                return;
            };

            if (_guideHelpController)
            {
                _guideHelpController.dispose();
                _guideHelpController = null;
            };

            if (_guideSessionController)
            {
                _guideSessionController.dispose();
                _guideSessionController = null;
            };

            if (_chatReviewReporterFeedbackCtrl)
            {
                _chatReviewReporterFeedbackCtrl.dispose();
                _chatReviewReporterFeedbackCtrl = null;
            };

            if (_popupTimer)
            {
                _popupTimer.reset();
                _popupTimer = null;
            };

            _disposed = true;
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function showGuideTool():void
        {
            _guideSessionController.showGuideTool();
        }

        public function showPendingTicket(_arg_1:PendingGuideTicket):void
        {
            _guideHelpController.showPendingTicket(_arg_1);
        }

        public function createHelpRequest(_arg_1:uint):void
        {
            _guideSessionController.createHelpRequest(_arg_1);
        }

        public function openReportWindow():void
        {
            _guideSessionController.openReportWindow();
        }

        public function showFeedback(_arg_1:String):void
        {
            _chatReviewReporterFeedbackCtrl.show(_arg_1);
        }

        private function getTourPopupDelay():int
        {
            return (_habboHelp.getInteger("guide.help.new.user.tour.popup.delay", 30) * 1000);
        }

        public function onHabboToolbarEvent(_arg_1:HabboToolbarEvent):void
        {
            if (_arg_1.type == "HTE_TOOLBAR_CLICK")
            {
                switch (_arg_1.iconId)
                {
                    case "HTIE_ICON_HELP":
                        _habboHelp.toggleNewHelpWindow();
                        return;
                    case "HTIE_ICON_GUIDE":
                        showGuideTool();
                        return;
                };
            };
        }

    }
}
