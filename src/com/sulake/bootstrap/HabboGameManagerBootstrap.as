package com.sulake.bootstrap
{
    import com.sulake.habbo.game.HabboGameManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboGameManagerBootstrap extends HabboGameManager 
    {

        public function HabboGameManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}