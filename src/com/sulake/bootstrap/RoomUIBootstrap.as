package com.sulake.bootstrap
{
    import com.sulake.habbo.ui.RoomUI;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class RoomUIBootstrap extends RoomUI 
    {

        public function RoomUIBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}