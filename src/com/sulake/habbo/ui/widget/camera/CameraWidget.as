package com.sulake.habbo.ui.widget.camera
{
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.ui.RoomUI;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ICoreConfiguration;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.handler.CameraWidgetHandler;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.session.IRoomSession;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.parser.camera.CameraPublishStatusMessageEvent;
    import com.sulake.habbo.communication.messages.parser.camera.CompetitionStatusMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.camera.RenderRoomMessageComposer;

    public class CameraWidget extends RoomWidgetBase 
    {

        private var _component:RoomUI;
        private var _viewFinder:CameraViewFinder;
        private var _photoLab:CameraPhotoLab;
        public var url:String;

        public function CameraWidget(_arg_1:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:ICoreConfiguration, _arg_5:IHabboLocalizationManager, _arg_6:RoomUI)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_5);
            _component = _arg_6;
            this.handler.widget = this;
            _viewFinder = new CameraViewFinder(this);

            if (roomEngine)
            {
                roomEngine.events.addEventListener("REE_DISPOSED", onRoomDisposed);
                roomEngine.events.addEventListener("REE_ROOM_ZOOMED", onRoomZoomed);
            };

            this.handler.sendInitCameraMessage();

            var _local_7:IHabboQuestEngine = this.handler.roomDesktop.questEngine;

            if (_local_7 != null)
            {
                _local_7.ensureAchievementsInitialized();
            };
        }

        public function get catalog():IHabboCatalog
        {
            return (_component.catalog);
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            };

            if (_viewFinder)
            {
                _viewFinder.dispose();
                _viewFinder = null;
            };

            if (_photoLab)
            {
                _photoLab.dispose();
                _photoLab = null;
            };

            super.dispose();
        }

        public function get container():IRoomWidgetHandlerContainer
        {
            return ((handler) ? handler.container : null);
        }

        public function get handler():CameraWidgetHandler
        {
            return (_SafeStr_3915 as CameraWidgetHandler);
        }

        public function get roomEngine():IRoomEngine
        {
            return ((container) ? container.roomEngine : null);
        }

        public function startTakingPhoto(_arg_1:String):void
        {
            if (((roomEngine) && (!(roomEngine.getRoomCanvasScale() == 1))))
            {
                windowManager.alert(_SafeStr_819.getLocalization("camera.zoom.missing.header"), _SafeStr_819.getLocalization("camera.zoom.missing.body"), 0, null);
                return;
            };

            if (component.getProperty("camera.effects.enabled") == "true")
            {
                CameraPhotoLab.preloadEffects(_component.context.configuration.getProperty("image.library.url"), _component.getProperty("camera.available.effects"), _SafeStr_819);
            };

            if (_photoLab)
            {
                _photoLab.dispose();
            };

            _viewFinder.toggleVisible(_arg_1);
        }

        public function get component():RoomUI
        {
            return (_component);
        }

        public function getXmlWindow(name:String, layer:uint=1):IWindow
        {
            var _local_5:IAsset;
            var _local_3:XmlAsset;
            var _local_4:IWindow;
            try
            {
                _local_5 = assets.getAssetByName((name + "_xml"));
                _local_3 = XmlAsset(_local_5);
                _local_4 = windowManager.buildFromXML(XML(_local_3.content), layer);
            }

            catch(e:Error)
            {
                ErrorReportStorage.addDebugData("HabboNavigator", (((((("Failed to build window " + name) + "_xml, ") + _local_5) + ", ") + windowManager) + "!"));
                throw (e);
            };

            return (_local_4);
        }

        private function onRoomDisposed(_arg_1:RoomEngineEvent):void
        {
            hide();
        }

        private function onRoomZoomed(_arg_1:RoomEngineEvent):void
        {
            if (((roomEngine) && (!(roomEngine.getRoomCanvasScale() == 1))))
            {
                hide();
            };
        }

        private function hide():void
        {
            if (_viewFinder)
            {
                _viewFinder.hide();
            };

            if (_photoLab)
            {
                _photoLab.dispose();
            };
        }

        public function snapShotRoomCanvas(_arg_1:BitmapData, _arg_2:Matrix, _arg_3:Boolean):Boolean
        {
            var _local_4:IRoomSession = container.roomSession;
            return (roomEngine.snapshotRoomCanvasToBitmap(_local_4.roomId, container.getFirstCanvasId(), _arg_1, _arg_2, _arg_3));
        }

        public function triggetCameraShutterSound():void
        {
            container.soundManager.playSound("CAMERA_shutter");
        }

        public function editPhoto(_arg_1:BitmapData):void
        {
            _photoLab = new CameraPhotoLab(this);
            _photoLab.openPhotoLab(_arg_1);
        }

        public function changeCaptionFieldText(_arg_1:String, _arg_2:Boolean=false):void
        {
            if (_photoLab)
            {
                _photoLab.setCaptionText(_arg_1);

                if (_arg_2)
                {
                    _photoLab.show();
                    _photoLab.closePurchaseConfirmation();
                };
            };
        }

        public function getViewPort():Rectangle
        {
            if (_viewFinder)
            {
                return (_viewFinder.getViewPort());
            };

            return (new Rectangle(0, 0, 0, 0));
        }

        public function purchaseSuccessful():void
        {
            if (_photoLab)
            {
                _photoLab.animateSuccessfulPurchase();
            };
        }

        public function setRenderedPhotoUrl(_arg_1:String):void
        {
            if (_photoLab)
            {
                _photoLab.setRenderedPhotoUrl(_arg_1);
            };
        }

        public function publishingStatus(_arg_1:CameraPublishStatusMessageEvent):void
        {
            if (_photoLab)
            {
                _photoLab.publishingStatus(_arg_1);
            };
        }

        public function competitionStatus(_arg_1:CompetitionStatusMessageEvent):void
        {
            if (_photoLab)
            {
                _photoLab.competitionStatus(_arg_1);
            };
        }

        public function sendPhotoData():Boolean
        {
            var _local_1:RenderRoomMessageComposer = _viewFinder.getRenderRoomMessage();

            if (_photoLab)
            {
                _local_1.addEffectData(_photoLab.getEffectDataJson());
                _local_1.setZoom(_photoLab.getZoom());
            };

            _local_1.compressData();

            if (_local_1.isSendable())
            {
                handler.sendPhotoData(_local_1);
                return (true);
            };

            return (false);
        }

    }
}
