package com.sulake.habbo.session.events
{
    import com.sulake.habbo.session.IRoomSession;

    public class RoomSessionPetFigureUpdateEvent extends RoomSessionEvent 
    {

        public static const PET_FIGURE_UPDATE:String = "RSPFUE_PET_FIGURE_UPDATE";

        private var _petId:int;
        private var _figure:String;

        public function RoomSessionPetFigureUpdateEvent(_arg_1:IRoomSession, id:int, figure:String, bubbles:Boolean=false, cancellable:Boolean=false)
        {
            super("RSPFUE_PET_FIGURE_UPDATE", _arg_1, bubbles, cancellable);
            _petId = id;
            _figure = figure;
        }

        public function get petId():int
        {
            return (_petId);
        }

        public function get figure():String
        {
            return (_figure);
        }

    }
}