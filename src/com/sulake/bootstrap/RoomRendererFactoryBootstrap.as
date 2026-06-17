package com.sulake.bootstrap
{
    import com.sulake.room.renderer.RoomRendererFactory;
    import com.sulake.core.runtime.IContext;

    public class RoomRendererFactoryBootstrap extends RoomRendererFactory 
    {

        public function RoomRendererFactoryBootstrap(context:IContext, flags:uint=0)
        {
            super(context, flags);
        }

    }
}