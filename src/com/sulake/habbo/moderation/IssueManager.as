package com.sulake.habbo.moderation
{
    import com.sulake.core.utils.Map;
    import flash.utils.Timer;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ReleaseIssuesMessageComposer;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModToolSanctionComposer;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CfhSanctionTypeData;
    import com.sulake.habbo.communication.messages.outgoing.moderator.CloseIssuesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.PickIssuesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.CloseIssueDefaultActionMessageComposer;

    public class IssueManager 
    {

        public static const _SafeStr_2852:String = "issue_bundle_open";
        public static const BUNDLE_MY:String = "issue_bundle_my";
        public static const _SafeStr_2853:String = "issue_bundle_picked";
        public static const PRIORITY_UPDATE_INTERVAL_MS:int = 15000;
        public static const RESOLUTION_USELESS:int = 1;
        public static const RESOLUTION_RESOLVED:int = 3;

        private var _moderationManager:ModerationManager;
        private var _issueBrowser:IssueBrowser;
        private var _issues:Map;
        private var _bundles:Map;
        private var _bundleIds:Map;
        private var _handleQueue:Array;
        private var _releaseQueue:Array;
        private var _issueHandlers:Map;
        private var _modActionViews:Map;
        private var _nextBundleId:int = 1;
        private var _priorityFactor:int;
        private var _priorityUpdater:Timer;
        private var _issueListLimit:int;
        private var _windowX:int;
        private var _windowY:int;
        private var _windowWidth:int;
        private var _windowHeight:int;
        private var _cfhtopics:Vector.<CallForHelpCategoryData>;

        public function IssueManager(_arg_1:ModerationManager)
        {
            _moderationManager = _arg_1;
            _issues = new Map();
            _bundles = new Map();
            _bundleIds = new Map();
            _issueBrowser = new IssueBrowser(this, _moderationManager.windowManager, _moderationManager.assets);
            _handleQueue = [];
            _releaseQueue = [];
            _issueHandlers = new Map();
            _modActionViews = new Map();
            _priorityFactor = _moderationManager.getInteger("chf.score.updatefactor", 60);
            _issueListLimit = _moderationManager.getInteger("max.call_for_help.results", 200);
            _priorityUpdater = new Timer(15000, 0);
            _priorityUpdater.addEventListener("timer", updateIssueBrowser);
            _priorityUpdater.start();
        }

        public function get issueListLimit():int
        {
            return (_issueListLimit);
        }

        public function init():void
        {
            _issueBrowser.show();
        }

        public function pickBundle(_arg_1:int, _arg_2:String, _arg_3:Boolean=false, _arg_4:int=0):void
        {
            var _local_5:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_5 == null)
            {
                return;
            };

            sendPick(_local_5.getIssueIds(), _arg_3, _arg_4, _arg_2);
            _handleQueue = _handleQueue.concat(_local_5.getIssueIds());
        }

        public function autoPick(_arg_1:String, _arg_2:Boolean=false, _arg_3:int=0):void
        {
            var _local_4:IssueBundle = null;
            var _local_6:IssueBundle;
            var _local_5:Array = _bundles.getValues();

            for each (_local_6 in _local_5)
            {
                if (((_local_6.state == 1) && ((_local_4 == null) || (isBundleHigherPriorityOrOlder(_local_6, _local_4)))))
                {
                    _local_4 = _local_6;
                };
            };

            if (_local_4 == null)
            {
                return;
            };

            pickBundle(_local_4.id, _arg_1, _arg_2, _arg_3);
        }

        private function isBundleHigherPriorityOrOlder(_arg_1:IssueBundle, _arg_2:IssueBundle):Boolean
        {
            if (_arg_1.highestPriority < _arg_2.highestPriority)
            {
                return (true);
            };

            return ((_arg_1.highestPriority == _arg_2.highestPriority) && (_arg_1.issueAgeInMilliseconds < _arg_2.issueAgeInMilliseconds));
        }

        public function releaseAll():void
        {
            var _local_3:IssueBundle;

            if (_bundles == null)
            {
                return;
            };

            var _local_1:int = _moderationManager.sessionDataManager.userId;
            var _local_2:Array = [];

            for each (_local_3 in _bundles)
            {
                if (((_local_3.state == 2) && (_local_3.pickerUserId == _local_1)))
                {
                    _local_2 = _local_2.concat(_local_3.getIssueIds());
                };
            };

            sendRelease(_local_2);
        }

        public function releaseBundle(_arg_1:int):void
        {
            if (_bundles == null)
            {
                return;
            };

            var _local_2:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_2 == null)
            {
                return;
            };

            sendRelease(_local_2.getIssueIds());
        }

        private function sendRelease(_arg_1:Array):void
        {
            if (((((_arg_1 == null) || (_arg_1.length == 0)) || (_moderationManager == null)) || (_moderationManager.connection == null)))
            {
                return;
            };

            _moderationManager.connection.send(new ReleaseIssuesMessageComposer(_arg_1));
            _releaseQueue = _releaseQueue.concat(_arg_1);
        }

        public function playSound(_arg_1:IssueMessageData):void
        {
            if (_issues[_arg_1.issueId] != null)
            {
                return;
            };

            if (((_issueBrowser == null) || (!(_issueBrowser.isOpen()))))
            {
                _moderationManager.soundManager.playSound("HBST_call_for_help");
            };
        }

        public function updateIssue(_arg_1:IssueMessageData):void
        {
            var _local_9:IssueBundle;
            var _local_3:IssueBundle;
            var _local_2:int;
            var _local_4:Array;
            var _local_5:Boolean;
            var _local_7:IssueBundle;
            var _local_8:int;

            if (_arg_1 == null)
            {
                return;
            };

            _issues.remove(_arg_1.issueId);
            _issues.add(_arg_1.issueId, _arg_1);

            var _local_6:int = _bundleIds.getValue(_arg_1.issueId);

            if (_local_6 != 0)
            {
                _local_9 = (_bundles.getValue(_local_6) as IssueBundle);

                if (_local_9 != null)
                {
                    if (_local_9.matches(_arg_1))
                    {
                        _local_9.updateIssue(_arg_1);
                    }

                    else
                    {
                        _local_9.removeIssue(_arg_1.issueId);

                        if (_local_9.getIssueCount() == 0)
                        {
                            _bundles.remove(_local_9.id);
                            removeHandler(_local_9.id);
                        };

                        _bundleIds.remove(_arg_1.issueId);
                        _local_9 = null;
                    };
                };
            };

            if (_arg_1.state == 3)
            {
                _issues.remove(_arg_1.issueId);
                return;
            };

            if (_local_9 == null)
            {
                for each (_local_3 in _bundles)
                {
                    if (_local_3.matches(_arg_1))
                    {
                        _local_9 = _local_3;
                        _local_9.updateIssue(_arg_1);
                        _bundleIds.add(_arg_1.issueId, _local_9.id);
                        break;
                    };
                };
            };

            if (_local_9 == null)
            {
                _local_6 = _nextBundleId++;
                _local_9 = new IssueBundle(_local_6, _arg_1);
                _bundleIds.add(_arg_1.issueId, _local_6);
                _bundles.add(_local_6, _local_9);
            };

            if (_local_9 == null)
            {
                return;
            };

            if (_handleQueue.indexOf(_arg_1.issueId) != -1)
            {
                handleBundle(_local_9.id);
                _local_2 = _moderationManager.sessionDataManager.userId;

                if (_local_2 != _arg_1.pickerUserId)
                {
                    if (_arg_1.state == 2)
                    {
                        unhandleBundle(_local_9.id);
                    };
                };
            };

            if (_arg_1.state == 1)
            {
                _local_4 = getBundles("issue_bundle_my");
                _local_5 = false;

                for each (_local_7 in _local_4)
                {
                    if (_local_7.matches(_arg_1, true))
                    {
                        _local_5 = true;
                        break;
                    };
                };

                _local_8 = _releaseQueue.indexOf(_arg_1.issueId);

                if (((_local_8 == -1) && (_local_5)))
                {
                    sendPick([_arg_1.issueId], false, 0, ("matches bundle with issue: " + _local_7.getHighestPriorityIssue().issueId));
                }

                else
                {
                    _releaseQueue.splice(_local_8, 1);
                };
            };

            updateHandler(_local_9.id);
            _issueBrowser.update();
        }

        public function updateIssueBrowser(_arg_1:Event=null):void
        {
            if (_moderationManager == null)
            {
                return;
            };

            if (_issueBrowser != null)
            {
                _issueBrowser.update();
            };
        }

        private function updateHandler(_arg_1:int):void
        {
            var _local_2:IIssueHandler = _issueHandlers.getValue(_arg_1);

            if (_local_2 != null)
            {
                _local_2.updateIssuesAndMessages();
            };
        }

        public function removeHandler(_arg_1:int):void
        {
            var _local_2:IIssueHandler = _issueHandlers.remove(_arg_1);

            if (_local_2 != null)
            {
                _local_2.dispose();
                _local_2 = null;
            };
        }

        public function addModActionView(_arg_1:int, _arg_2:ModActionCtrl):void
        {
            _modActionViews.add(_arg_1, _arg_2);
        }

        public function removeModActionView(_arg_1:int):void
        {
            _modActionViews.remove(_arg_1);
        }

        public function removeIssue(_arg_1:int):void
        {
            var _local_3:IssueBundle;

            if (_issues == null)
            {
                return;
            };

            var _local_2:int = _bundleIds.getValue(_arg_1);

            if (_local_2 != 0)
            {
                _local_3 = (_bundles.getValue(_local_2) as IssueBundle);

                if (_local_3 != null)
                {
                    _local_3.removeIssue(_arg_1);

                    if (_local_3.getIssueCount() == 0)
                    {
                        _bundles.remove(_local_3.id);
                    };
                };
            };

            _issues.remove(_arg_1);
            _issueBrowser.update();
        }

        public function getBundles(_arg_1:String):Array
        {
            var _local_4:IssueBundle;

            if (_bundles == null)
            {
                return ([]);
            };

            var _local_3:Array = [];
            var _local_2:int = _moderationManager.sessionDataManager.userId;

            for each (_local_4 in _bundles)
            {
                switch (_arg_1)
                {
                    case "issue_bundle_open":

                        if (_local_4.state == 1)
                        {
                            _local_3.push(_local_4);
                        };

                        break;
                    case "issue_bundle_my":

                        if (((_local_4.state == 2) && (_local_4.pickerUserId == _local_2)))
                        {
                            _local_3.push(_local_4);
                        };

                        break;
                    case "issue_bundle_picked":

                        if (((_local_4.state == 2) && (!(_local_4.pickerUserId == _local_2))))
                        {
                            _local_3.push(_local_4);
                        };
                };
            };

            return (_local_3);
        }

        public function handleBundle(_arg_1:int):void
        {
            var _local_5:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_5 == null)
            {
                return;
            };

            var _local_4:IIssueHandler = new IssueHandler(_moderationManager, _local_5, _cfhtopics, _windowX, _windowY, _windowWidth, _windowHeight);
            _moderationManager.windowTracker.show((_local_4 as ITrackedWindow), null, false, false, false, true, _windowX, _windowY, _windowWidth, _windowHeight);
            removeHandler(_arg_1);
            _issueHandlers.add(_arg_1, _local_4);

            var _local_2:Array = [];

            for each (var _local_3:int in _handleQueue)
            {
                if (!_local_5.contains(_local_3))
                {
                    _local_2 = _local_2.concat(_local_3);
                };
            };

            _handleQueue = _local_2;
        }

        public function unhandleBundle(_arg_1:int):void
        {
            var _local_3:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_3 == null)
            {
                return;
            };

            var _local_2:ITrackedWindow = _issueHandlers.remove(_arg_1);

            if (_local_2 != null)
            {
                _local_2.dispose();
            };
        }

        public function closeBundle(_arg_1:int, _arg_2:int):void
        {
            var _local_3:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_3 == null)
            {
                return;
            };

            sendClose(_local_3.getIssueIds(), _arg_2);
        }

        public function closeDefaultAction(_arg_1:int, _arg_2:int):void
        {
            var _local_6:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_6 == null)
            {
                return;
            };

            var _local_5:int = _local_6.getHighestPriorityIssue().issueId;
            var _local_4:Array = [];

            for each (var _local_3:int in _local_6.getIssueIds())
            {
                if (_local_3 != _local_5)
                {
                    _local_4.push(_local_3);
                };
            };

            sendCloseDefaultAction(_local_5, _local_4, _arg_2);
        }

        public function requestSanctionData(_arg_1:int, _arg_2:int):void
        {
            var _local_3:IssueBundle = (_bundles.getValue(_arg_1) as IssueBundle);

            if (_local_3 == null)
            {
                return;
            };

            if (_local_3.getHighestPriorityIssue() != null)
            {
                _moderationManager.connection.send(new ModToolSanctionComposer(_local_3.getHighestPriorityIssue().issueId, -1, _arg_2));
            };
        }

        public function requestSanctionDataForAccount(_arg_1:int, _arg_2:int):void
        {
            _moderationManager.connection.send(new ModToolSanctionComposer(-1, _arg_1, _arg_2));
        }

        public function updateSanctionData(_arg_1:int, _arg_2:int, _arg_3:CfhSanctionTypeData):void
        {
            var _local_4:IIssueHandler;
            var _local_5:ModActionCtrl;
            var _local_6:String = (_arg_3.name + ((_arg_3.avatarOnly) ? " (avatar) " : " "));

            if (_arg_3.sanctionLengthInHours > 24)
            {
                _local_6 = (_local_6 + ((_arg_3.sanctionLengthInHours / 24) + " days"));
            }

            else
            {
                _local_6 = (_local_6 + (_arg_3.sanctionLengthInHours + "h"));
            };

            if (!StringUtil.isEmpty(_arg_3.tradeLockInfo))
            {
                _local_6 = (_local_6 + (" & " + _arg_3.tradeLockInfo));
            };

            if (!StringUtil.isEmpty(_arg_3.machineBanInfo))
            {
                _local_6 = (_local_6 + (" & " + _arg_3.machineBanInfo));
            };

            if (_arg_1 > 0)
            {
                for each (var _local_7:IssueBundle in _bundles)
                {
                    if (_local_7.contains(_arg_1))
                    {
                        _local_4 = _issueHandlers.getValue(_local_7.id);

                        if (_local_4 != null)
                        {
                            _local_4.showDefaultSanction(_arg_2, _local_6);
                        };
                    };
                };
            }

            else
            {
                _local_5 = _modActionViews.getValue(_arg_2);

                if (_local_5 != null)
                {
                    _local_5.showDefaultSanction(_arg_2, _local_6);
                };
            };
        }

        private function sendClose(_arg_1:Array, _arg_2:int):void
        {
            if ((((_arg_1 == null) || (_moderationManager == null)) || (_moderationManager.connection == null)))
            {
                return;
            };

            _moderationManager.connection.send(new CloseIssuesMessageComposer(_arg_1, _arg_2));
        }

        private function sendPick(_arg_1:Array, _arg_2:Boolean, _arg_3:int, _arg_4:String):void
        {
            if ((((_arg_1 == null) || (_moderationManager == null)) || (_moderationManager.connection == null)))
            {
                return;
            };

            _moderationManager.connection.send(new PickIssuesMessageComposer(_arg_1, _arg_2, _arg_3, _arg_4));
        }

        private function sendCloseDefaultAction(_arg_1:int, _arg_2:Array, _arg_3:int):void
        {
            _moderationManager.connection.send(new CloseIssueDefaultActionMessageComposer(_arg_1, _arg_2, _arg_3));
        }

        public function autoHandle(_arg_1:int):void
        {
            var _local_3:IssueBundle = null;
            var _local_5:IssueBundle;
            var _local_4:Array = _bundles.getValues();
            var _local_2:int = _moderationManager.sessionDataManager.userId;

            for each (_local_5 in _local_4)
            {
                if (((((_local_5.state == 2) && (_local_5.pickerUserId == _local_2)) && (!(_local_5.id == _arg_1))) && ((_local_3 == null) || (_local_5.highestPriority < _local_3.highestPriority))))
                {
                    _local_3 = _local_5;
                };
            };

            if (_local_3 == null)
            {
                autoPick("issue manager pick next");
                return;
            };

            handleBundle(_local_3.id);
        }

        public function issuePickFailed(_arg_1:Array):Boolean
        {
            var _local_6:IssueMessageData;
            var _local_4:int;
            var _local_10:String;
            var _local_2:int;
            var _local_13:IssueBundle;
            var _local_5:IssueBundle;
            var _local_11:Array;
            var _local_12:int;
            var _local_8:int;
            var _local_3:IIssueHandler;

            if (!_arg_1)
            {
                return (false);
            };

            var _local_7:Boolean;
            var _local_9:int = _moderationManager.sessionDataManager.userId;

            for each (_local_6 in _arg_1)
            {
                _local_4 = _local_6.issueId;
                _local_10 = _local_6.pickerUserName;
                _local_2 = _local_6.pickerUserId;

                if (((!(_local_2 == -1)) && (!(_local_2 == _local_9))))
                {
                    _local_7 = true;
                };

                _local_13 = null;

                for each (_local_5 in _bundles)
                {
                    _local_11 = _local_5.getIssueIds();

                    if (_local_11 != null)
                    {
                        for each (_local_12 in _local_11)
                        {
                            if (_local_4 == _local_12)
                            {
                                _local_13 = _local_5;
                                break;
                            };
                        };
                    };
                };

                if (_local_13 != null)
                {
                    _local_8 = _local_13.id;
                    _local_3 = _issueHandlers.getValue(_local_8);

                    if (_local_3 != null)
                    {
                        _local_3.dispose();
                    };

                    releaseBundle(_local_8);
                };
            };

            return (_local_7);
        }

        public function setToolPreferences(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            _windowX = _arg_1;
            _windowY = _arg_2;
            _windowHeight = _arg_3;
            _windowWidth = _arg_4;
        }

        public function setCfhTopics(_arg_1:Vector.<CallForHelpCategoryData>):void
        {
            this._cfhtopics = _arg_1;
        }

        public function getCfhTopics():Vector.<CallForHelpCategoryData>
        {
            return (_cfhtopics);
        }

    }
}
