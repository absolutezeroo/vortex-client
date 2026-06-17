package com.sulake.bootstrap
{
    import com.sulake.habbo.room.RoomObjectFactory;
    import com.sulake.core.runtime.IContext;

    public class RoomObjectFactoryBootstrap extends RoomObjectFactory 
    {

        public function RoomObjectFactoryBootstrap(context:IContext, flags:uint=0)
        {
            super(context, flags);
        }

    }
}