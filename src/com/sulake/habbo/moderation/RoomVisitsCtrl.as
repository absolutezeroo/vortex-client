package com.sulake.habbo.moderation
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetRoomVisitsMessageComposer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomVisitsData;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomVisitData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import flash.events.TimerEvent;

    public class RoomVisitsCtrl implements IDisposable, ITrackedWindow 
    {

        private static var ROOM_ROW_POOL:Array = [];
        private static var ROOM_ROW_POOL_MAX_SIZE:int = 200;

        private var _main:ModerationManager;
        private var _frame:IFrameWindow;
        private var _list:IItemListWindow;
        private var _userId:int;
        private var _rooms:Array;
        private var _disposed:Boolean;
        private var _row:IWindowContainer;
        private var _resizeTimer:Timer;
        private var _roomRows:Array = [];

        public function RoomVisitsCtrl(_arg_1:ModerationManager, _arg_2:int)
        {
            _main = _arg_1;
            _userId = _arg_2;
        }

        public static function getFormattedTime(_arg_1:int, _arg_2:int):String
        {
            return ((padToTwoDigits(_arg_1) + ":") + padToTwoDigits(_arg_2));
        }

        public static function padToTwoDigits(_arg_1:int):String
        {
            return ((_arg_1 < 10) ? ("0" + _arg_1) : ("" + _arg_1));
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function show():void
        {
            _resizeTimer = new Timer(300, 1);
            _resizeTimer.addEventListener("timer", onResizeTimer);
            _main.messageHandler.addRoomVisitsListener(this);
            _main.connection.send(new GetRoomVisitsMessageComposer(_userId));
            _frame = IFrameWindow(_main.getXmlWindow("roomvisits_frame"));
            _list = IItemListWindow(_frame.findChildByName("visits_list"));
            _row = (_list.getListItemAt(0) as IWindowContainer);
            _list.removeListItems();
            _frame.procedure = onWindow;

            var _local_1:IWindow = _frame.findChildByTag("close");
            _local_1.procedure = onClose;
        }

        public function onRoomVisits(_arg_1:RoomVisitsData):void
        {
            if (_arg_1.userId != _userId)
            {
                return;
            };

            if (_disposed)
            {
                return;
            };

            this._rooms = _arg_1.rooms;
            _frame.caption = ("Room visits: " + _arg_1.userName);
            populate();
            onResizeTimer(null);
            _frame.visible = true;
            _main.messageHandler.removeRoomVisitsListener(this);
        }

        public function getType():int
        {
            return (6);
        }

        public function getId():String
        {
            return ("" + _userId);
        }

        public function getFrame():IFrameWindow
        {
            return (_frame);
        }

        private function populate():void
        {
            var _local_2:RoomVisitData;
            var _local_1:Boolean = true;

            for each (_local_2 in _rooms)
            {
                populateRoomRow(_local_2, _local_1);
                _local_1 = (!(_local_1));
            };
        }

        private function populateRoomRow(_arg_1:RoomVisitData, _arg_2:Boolean):void
        {
            var _local_4:IWindowContainer = getRoomRowWindow();
            var _local_3:uint = ((_arg_2) ? 4288861930 : 0xFFFFFFFF);
            _local_4.color = _local_3;

            var _local_7:IWindow = _local_4.findChildByName("room_name_txt");
            _local_7.caption = _arg_1.roomName;
            new OpenRoomTool(_frame, _main, _local_7, _arg_1.roomId);
            _local_7.color = _local_3;

            var _local_5:ITextWindow = ITextWindow(_local_4.findChildByName("time_txt"));
            _local_5.text = getFormattedTime(_arg_1.enterHour, _arg_1.enterMinute);

            var _local_6:ITextWindow = ITextWindow(_local_4.findChildByName("view_room_txt"));
            new OpenRoomInSpectatorMode(_main, _local_6, _arg_1.roomId);
            _local_6.color = _local_3;
            addRoomRowToList(_local_4, _list);
        }

        private function addRoomRowToList(_arg_1:IWindowContainer, _arg_2:IItemListWindow):void
        {
            _arg_2.addListItem(_arg_1);
            _roomRows.push(_arg_1);
        }

        private function getRoomRowWindow():IWindowContainer
        {
            if (ROOM_ROW_POOL.length > 0)
            {
                return (ROOM_ROW_POOL.pop() as IWindowContainer);
            };

            return (IWindowContainer(_row.clone()));
        }

        private function storeRoomRowWindow(_arg_1:IWindowContainer):void
        {
            var _local_3:IWindow;
            var _local_2:IWindow;

            if (ROOM_ROW_POOL.length < ROOM_ROW_POOL_MAX_SIZE)
            {
                _local_3 = _arg_1.findChildByName("room_name_txt");
                _local_3.procedure = null;
                _local_2 = _arg_1.findChildByName("view_room_txt");
                _local_2.procedure = null;
                _arg_1.width = _row.width;
                _arg_1.height = _row.height;
                ROOM_ROW_POOL.push(_arg_1);
            }

            else
            {
                _arg_1.dispose();
            };
        }

        private function onClose(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (_arg_1.type != "WME_CLICK")
            {
                return;
            };

            dispose();
        }

        private function onWindow(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            if (((!(_arg_1.type == "WE_RESIZED")) || (!(_arg_2 == _frame))))
            {
                return;
            };

            if (!this._resizeTimer.running)
            {
                this._resizeTimer.reset();
                this._resizeTimer.start();
            };
        }

        private function onResizeTimer(_arg_1:TimerEvent):void
        {
            var _local_3:IWindowContainer = IWindowContainer(_list.parent);
            var _local_5:IWindow = (_local_3.getChildByName("scroller") as IWindow);
            var _local_4:Boolean = (_list.scrollableRegion.height > _list.height);
            var _local_2:int = 17;

            if (_local_5.visible)
            {
                if (!_local_4)
                {
                    _local_5.visible = false;
                    _list.width = (_list.width + _local_2);
                };
            }

            else
            {
                if (_local_4)
                {
                    _local_5.visible = true;
                    _list.width = (_list.width - _local_2);
                };
            };
        }

        public function dispose():void
        {
            var _local_1:IWindowContainer;

            if (_disposed)
            {
                return;
            };

            _disposed = true;

            if (_list != null)
            {
                _list.removeListItems();
                _list.dispose();
                _list = null;
            };

            if (_frame != null)
            {
                _frame.destroy();
                _frame = null;
            };

            _main = null;

            if (_resizeTimer != null)
            {
                _resizeTimer.stop();
                _resizeTimer.removeEventListener("timer", onResizeTimer);
                _resizeTimer = null;
            };

            for each (_local_1 in _roomRows)
            {
                storeRoomRowWindow(_local_1);
            };

            if (_row != null)
            {
                _row.dispose();
                _row = null;
            };

            _roomRows = [];
        }

    }
}
