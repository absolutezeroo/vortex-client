package {
    import flash.display.Sprite;
    import com.sulake.core.runtime.ICore;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import com.sulake.core.Core;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.events.Event;
    import flash.system.Capabilities;
    import com.sulake.core.runtime.ICoreErrorReporter;
    import com.sulake.core.runtime.CoreComponentContext;
    import com.sulake.air.FileProxy;
    import com.sulake.habbo.utils.PlatformData;
    import com.sulake.air.NativeApplicationProxy;
    import flash.events.ProgressEvent;
    import flash.external.ExternalInterface;
    import flash.system.System;
    import com.sulake.core.runtime.IID;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.core.runtime.Component;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDRoomEngine;
    import flash.utils.setInterval;
    import com.sulake.habbo.utils.HabboWebTools;

    public class HabboAirMain extends Sprite {

        public static const RESTART_CLIENT:String = "HABBO_AIR_MAIN_RESTART_CLIENT";
        public static const CORE_RATIO:Number = 0.6;
        private static const INIT_STEPS:int = 3;

        private var _core:ICore;
        private var _loadingScreen:IHabboLoadingScreen;
        private var _totalProgressSteps:int = 3;
        private var _loadedFilesCount:int = 0;
        private var _completedInitSteps:int = 0;
        private var _roomEngineReady:Boolean = false;
        private var _coreRunning:Boolean = false;
        private var _parameters:Dictionary;
        private var _prepareCoreOnNextFrame:Boolean;
        private var _bootstrapComplete:Boolean;

        public function HabboAirMain(loadingScreen:IHabboLoadingScreen, parameters:Dictionary) {
            _loadingScreen = loadingScreen;
            _parameters = parameters;

            addEventListener("addedToStage", onAddedToStage);
            addEventListener("exitFrame", onExitFrame);

            Logger.log(((getQualifiedClassName(Core) + " version: ") + Core.version));
        }

        private function dispose():void {
            removeEventListener("progress", onProgressEvent);
            removeEventListener("complete", onCompleteEvent);
            removeEventListener("addedToStage", onAddedToStage);
            removeEventListener("exitFrame", onExitFrame);

            disposeLoadingScreen();

            if (_core != null) {
                _core.events.removeEventListener("COMPONENT_EVENT_RUNNING", onCoreRunning);
                _core.events.removeEventListener("COMPONENT_EVENT_ERROR", onCoreError);
                _core.events.removeEventListener("COMPONENT_EVENT_REBOOT", onCoreReboot);
            }
            ;

            if (parent) {
                parent.removeChild(this);
            }
            ;
        }

        public function unloading():void {
            try {
                if (((_core) && (!(_core.disposed)))) {
                    ErrorReportStorage.addDebugData("Unload", "Client unloading started");
                    _core.events.dispatchEvent(new Event("unload"));
                }
                ;
            }

            catch (error:Error) {
                ErrorReportStorage.addDebugData("Unload", ("Client unloading failed: " + error.message));
            }
            ;
        }

        protected function onAddedToStage(event:Event = null):void {
            try {
                init();
            }

            catch (error:Error) {
                HabboAir.trackLoginStep(ClientEnum.CLIENT_CORE_INIT_FAIL);
                HabboAir.reportCrash(("Failed to prepare the core: " + error.message), 10, true, error);
                Core.dispose();
            }
            ;
        }

        private function init():void {
            var platform:String = Capabilities.version.toLowerCase();

            if (((platform.indexOf("win") > -1) || (platform.indexOf("mac") > -1))) {
            }
            ;

            _prepareCoreOnNextFrame = true;
        }

        protected function onExitFrame(event:Event = null):void {
            if (_prepareCoreOnNextFrame) {
                _prepareCoreOnNextFrame = false;

                prepareCore();

                return;
            }
            ;

            if (((_roomEngineReady) && (_coreRunning) && (!(_bootstrapComplete)))) {
                completeBootstrap();
            }
            ;
        }

        private function prepareCore():void {
            var errorReporter:ICoreErrorReporter;
            var config:XML;

            try {
                errorReporter = ((Capabilities.playerType != "StandAlone") ? new HabboCoreErrorReporter() : null);

                _core = Core.instantiate(stage, 1, errorReporter, _parameters);
                _core.events.addEventListener("COMPONENT_EVENT_ERROR", onCoreError);
                _core.events.addEventListener("COMPONENT_EVENT_REBOOT", onCoreReboot);
                _core.prepareComponent(HabboTrackingLib);

                addEventListener("progress", onProgressEvent);
                addEventListener("complete", onCompleteEvent);

                config = <config>
                        <asset-libraries>
                            <library url="hh_human_body.swf"/>
                            <library url="hh_human_item.swf"/>
                        </asset-libraries>
                        <service-libraries/>
                        <component-libraries/>
                    </config>;

                config = new XML();
                _core.readConfigDocument(config, this);

                (_core as CoreComponentContext).fileProxy = new FileProxy();

                if (PlatformData.nativeApplicationProxy) {
                    PlatformData.nativeApplicationProxy.dispose();
                }
                ;

                PlatformData.nativeApplicationProxy = new NativeApplicationProxy();

                _totalProgressSteps = ((_core.getNumberOfFilesPending() + _core.getNumberOfFilesLoaded()) + 3);

                _core.prepareComponent(CoreCommunicationFrameworkLib);
                _core.prepareComponent(HabboRoomObjectLogicLib);
                _core.prepareComponent(HabboRoomObjectVisualizationLib);
                _core.prepareComponent(RoomManagerLib);
                _core.prepareComponent(RoomSpriteRendererLib);
                _core.prepareComponent(HabboRoomSessionManagerLib);
                _core.prepareComponent(HabboAvatarRenderLib);
                _core.prepareComponent(HabboSessionDataManagerLib);
                _core.prepareComponent(HabboConfigurationCom);
                _core.prepareComponent(HabboLocalizationCom);
                _core.prepareComponent(HabboWindowManagerCom);
                _core.prepareComponent(HabboCommunicationCom);
                _core.prepareComponent(HabboCommunicationDemoCom);
                _core.prepareComponent(HabboNavigatorCom);
                _core.prepareComponent(HabboFriendListCom);
                _core.prepareComponent(HabboMessengerCom);
                _core.prepareComponent(HabboInventoryCom);
                _core.prepareComponent(HabboToolbarCom);
                _core.prepareComponent(HabboCatalogCom);
                _core.prepareComponent(HabboRoomEngineCom);
                _core.prepareComponent(HabboRoomUICom);
                _core.prepareComponent(HabboAvatarEditorCom);
                _core.prepareComponent(HabboNotificationsCom);
                _core.prepareComponent(HabboHelpCom);
                _core.prepareComponent(HabboAdManagerCom);
                _core.prepareComponent(HabboModerationCom);
                _core.prepareComponent(HabboUserDefinedRoomEventsCom);
                _core.prepareComponent(HabboSoundManagerFlash10Com);
                _core.prepareComponent(HabboQuestEngineCom);
                _core.prepareComponent(HabboFriendBarCom);
                _core.prepareComponent(HabboGroupsCom);
                _core.prepareComponent(HabboGamesCom);
                _core.prepareComponent(HabboFreeFlowChatCom);
                _core.prepareComponent(HabboNewNavigatorCom);

                addInitializationProgressListeners();
            }

            catch (error:Error) {
                HabboAir.trackLoginStep(ClientEnum.CLIENT_CORE_INIT_FAIL);
                HabboAir.reportCrash(("Failed to prepare the core: " + error.message), 10, true, error);
                Core.dispose();
                requestClientRestart("generic.error");
            }
            ;
        }

        private function completeBootstrap():void {
            _bootstrapComplete = true;
            removeEventListener("progress", onProgressEvent);
            removeEventListener("complete", onCompleteEvent);
            removeEventListener("addedToStage", onAddedToStage);
            removeEventListener("exitFrame", onExitFrame);
            disposeLoadingScreen();
        }

        private function disposeLoadingScreen():void {
            if (_loadingScreen) {
                _loadingScreen.dispose();
                _loadingScreen = null;
            }
            ;
        }

        private function updateProgressBar():void {
            var progress:Number;

            if (_loadingScreen != null) {
                progress = (0.6 + (((_completedInitSteps + _loadedFilesCount) / _totalProgressSteps) * (1 - 0.6)));
                _loadingScreen.updateLoadingBar(progress);
            }
            ;
        }

        private function onProgressEvent(event:ProgressEvent):void {
            _loadedFilesCount = _core.getNumberOfFilesLoaded();
            updateProgressBar();
        }

        private function onCompleteEvent(event:Event):void {
            removeEventListener("progress", onProgressEvent);
            removeEventListener("complete", onCompleteEvent);
            initializeCore();
        }

        private function initializeCore():void {
            HabboAir.trackLoginStep(ClientEnum.CLIENT_CORE_INIT);
            try {
                _core.initialize();

                if (ExternalInterface.available) {
                    ExternalInterface.addCallback("unloading", unloading);
                }
                ;
            }

            catch (error:Error) {
                HabboAir.trackLoginStep(ClientEnum.CLIENT_CORE_INIT_FAIL);
                Core.crash(("Failed to initialize the core: " + error.message), 10, error);
            }
            ;
        }

        public function onCoreError(event:Event):void {
            Logger.log(("onCoreError " + event.type));
        }

        private function onCoreReboot(event:Event):void {
            Logger.log(("Reboot application! " + System.privateMemory), System.totalMemory, System.totalMemoryNumber);
            _core.events.removeEventListener("COMPONENT_EVENT_ERROR", onCoreError);
            _core.events.removeEventListener("COMPONENT_EVENT_REBOOT", onCoreReboot);
            unloading();
            Core.dispose();
            _core = null;
            Logger.log(("Application ready for restart! " + System.privateMemory), System.totalMemory, System.totalMemoryNumber);
            requestClientRestart();
        }

        private function requestClientRestart(errorKey:String = null):void {
            if (_parameters)
            {
                delete _parameters["sso.token"];

                if (((errorKey) && (errorKey.length > 0)))
                {
                    _parameters["client.restart.error"] = errorKey;
                };
            };

            dispatchEvent(new Event(RESTART_CLIENT));
            dispose();
        }

        private function simpleQueueInterface(iid:IID, callback:Function):void {
            var component:Object = _core.queueInterface(iid, callback);

            if (component != null) {
                (callback(iid, component));
            }
            ;
        }

        private function addInitializationProgressListeners():void {
            simpleQueueInterface(new IIDHabboLocalizationManager(), function(iid:IID, component:Component):void {
                component.events.addEventListener("complete", onLocalizationComplete);
            });
            simpleQueueInterface(new IIDHabboConfigurationManager(), onConfigurationComplete);
            simpleQueueInterface(new IIDRoomEngine(), function(iid:IID, component:Component):void {
                component.events.addEventListener("REE_ENGINE_INITIALIZED", onRoomEngineReady);
            });
            _core.events.addEventListener("COMPONENT_EVENT_RUNNING", onCoreRunning);
        }

        private function onLocalizationComplete(event:Event):void {
            HabboAir.trackLoginStep(ClientEnum.CLIENT_LOCALIZATION_LOADED);
            _completedInitSteps++;
            updateProgressBar();
        }

        private function onConfigurationComplete(iid:IID, component:Component):void {
            HabboAir.trackLoginStep(ClientEnum.CLIENT_CONFIG_LOADED);
            _completedInitSteps++;
            updateProgressBar();
        }

        private function onRoomEngineReady(event:Event):void {
            _roomEngineReady = true;
            HabboAir.trackLoginStep(ClientEnum.CLIENT_ROOM_ENGINE_READY);

            if (_core.getInteger("spaweb", 0) == 1) {
                startSendingHeartBeat();
            }
            ;
        }

        private function startSendingHeartBeat():void {
            sendHeartBeat();
            setInterval(sendHeartBeat, 10000); // not popped
        }

        private function sendHeartBeat():void {
            HabboWebTools.sendHeartBeat();
        }

        private function onCoreRunning(event:Event):void {
            _coreRunning = true;
            HabboAir.trackLoginStep(ClientEnum.CLIENT_CORE_RUNNING);
            _completedInitSteps++;
            updateProgressBar();
        }

    }
}

import com.sulake.core.runtime.ICoreErrorReporter;
import com.sulake.core.runtime.ICoreErrorLogger;

class HabboCoreErrorReporter implements ICoreErrorReporter {
    private var _logger:ICoreErrorLogger;

    public function logError(description:String, isFatal:Boolean, category:int = -1, error:Error = null):void {
        HabboAir.reportCrash(description, category, isFatal, error, _logger);
    }

    public function set errorLogger(value:ICoreErrorLogger):void {
        _logger = value;
    }
}
