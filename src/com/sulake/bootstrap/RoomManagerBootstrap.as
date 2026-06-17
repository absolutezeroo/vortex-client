package com.sulake.bootstrap
{
    import com.sulake.room.RoomManager;
    import com.sulake.core.runtime.IContext;

    public class RoomManagerBootstrap extends RoomManager 
    {

        public function RoomManagerBootstrap(context:IContext, flags:uint=0)
        {
            super(context, flags);
        }

    }
}