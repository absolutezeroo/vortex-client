package splash
{
        import flash.display.Sprite;
        import __AS3__.vec.Vector;
        import flash.display.Bitmap;
        import flash.display.DisplayObjectContainer;

    public class PhotoSplashScreen extends Sprite 
    {

        private var backgroundBitmapClass:Class = HabboPhotoSplashScreen_Habbosplash_bg_class_png;
        private var topImageClass:Class = HabboPhotoSplashScreen_Habbosplash_top_class_png;
        private var splashImageClass1:Class = HabboPhotoSplashScreen_Habbosplash_img1_png;
        private var splashImageClass2:Class = HabboPhotoSplashScreen_Habbosplash_img2_png;
        private var splashImageClass3:Class = HabboPhotoSplashScreen_Habbosplash_img3_png;
        private var splashImageClass4:Class = HabboPhotoSplashScreen_Habbosplash_img4_png;
        private var splashImageClass5:Class = HabboPhotoSplashScreen_Habbosplash_img5_png;
        private var splashImageClass6:Class = HabboPhotoSplashScreen_Habbosplash_img6_png;
        private var splashImageClass7:Class = HabboPhotoSplashScreen_Habbosplash_img7_png;
        private var splashImageClass8:Class = HabboPhotoSplashScreen_Habbosplash_img8_png;
        private var splashImageClass9:Class = HabboPhotoSplashScreen_Habbosplash_img9_png;
        private var splashImageClass10:Class = HabboPhotoSplashScreen_Habbosplash_img10_png;
        private var splashImageClass11:Class = HabboPhotoSplashScreen_Habbosplash_img11_png;
        private var splashImageClass12:Class = HabboPhotoSplashScreen_Habbosplash_img12_png;
        private var splashImageClass13:Class = HabboPhotoSplashScreen_Habbosplash_img13_png;
        private var splashImageClass14:Class = HabboPhotoSplashScreen_Habbosplash_img14_png;
        private var splashImageClass15:Class = HabboPhotoSplashScreen_Habbosplash_img15_png;
        private var splashImageClass16:Class = HabboPhotoSplashScreen_Habbosplash_img16_png;
        private var splashImageClass17:Class = HabboPhotoSplashScreen_Habbosplash_img17_png;
        private var splashImageClass18:Class = HabboPhotoSplashScreen_Habbosplash_img18_png;
        private var splashImageClass19:Class = HabboPhotoSplashScreen_Habbosplash_img19_png;
        private var splashImageClass20:Class = HabboPhotoSplashScreen_Habbosplash_img20_png;
        private var splashImageClass21:Class = HabboPhotoSplashScreen_Habbosplash_img21_png;
        private var splashImageClass22:Class = HabboPhotoSplashScreen_Habbosplash_img22_png;
        private var splashImageClass23:Class = HabboPhotoSplashScreen_Habbosplash_img23_png;
        private var splashImageClass24:Class = HabboPhotoSplashScreen_Habbosplash_img24_png;
        private var splashImageClass25:Class = HabboPhotoSplashScreen_Habbosplash_img25_png;
        private var splashImageClass26:Class = HabboPhotoSplashScreen_Habbosplash_img26_png;
        private var splashImageClass27:Class = HabboPhotoSplashScreen_Habbosplash_img27_png;
        private var splashImageClass28:Class = HabboPhotoSplashScreen_Habbosplash_img28_png;
        private var splashImageClass29:Class = HabboPhotoSplashScreen_Habbosplash_img29_png;
        private var splashImageClass30:Class = HabboPhotoSplashScreen_Habbosplash_img30_png;

        public function PhotoSplashScreen(parentContainer:DisplayObjectContainer)
        {
            super();

            var fallbackBackground:Bitmap = null;
            var bitmapLayers:Vector.<Bitmap> = new Vector.<Bitmap>(0);
            fallbackBackground = (new backgroundBitmapClass() as Bitmap);
            bitmapLayers.push(fallbackBackground);

            var randomImageIndex:int = int(1 + Math.floor((Math.random() * 30)));
            var randomImageClass:Class = (this[("splashImageClass" + randomImageIndex)] as Class);
            var selectedSplashBitmap:Bitmap = null;

            if (randomImageClass != null)
            {
                selectedSplashBitmap = new randomImageClass();
                selectedSplashBitmap.x = 96;
                selectedSplashBitmap.y = 51;
                bitmapLayers.push(selectedSplashBitmap);
            };

            bitmapLayers.push(new topImageClass() as Bitmap);

            for each (fallbackBackground in bitmapLayers)
            {
                addChild(fallbackBackground);
            };
        }

    }
}
