package com.sulake.bootstrap
{
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboWindowManagerComponentBootstrap extends HabboWindowManagerComponent 
    {

        public function HabboWindowManagerComponentBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}