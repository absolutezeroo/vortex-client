package com.sulake.bootstrap
{
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboSoundManagerFlash10Bootstrap extends HabboSoundManagerFlash10 
    {

        public function HabboSoundManagerFlash10Bootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}