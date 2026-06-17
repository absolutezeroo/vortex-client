package com.sulake.bootstrap
{
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboHelpBootstrap extends HabboHelp 
    {

        public function HabboHelpBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}