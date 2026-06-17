package com.sulake.bootstrap
{
    import com.sulake.habbo.session.RoomSessionManager;
    import com.sulake.core.runtime.IContext;

    public class RoomSessionManagerBootstrap extends RoomSessionManager 
    {

        public function RoomSessionManagerBootstrap(context:IContext, flags:uint=0)
        {
            super(context, flags);
        }

    }
}