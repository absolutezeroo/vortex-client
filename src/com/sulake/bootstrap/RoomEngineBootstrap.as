package com.sulake.bootstrap
{
    import com.sulake.habbo.room.RoomEngine;
    import com.sulake.core.runtime.IContext;

    public class RoomEngineBootstrap extends RoomEngine 
    {

        public function RoomEngineBootstrap(context:IContext, flags:uint=0)
        {
            super(context, flags);
        }

    }
}