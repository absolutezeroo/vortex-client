package onBoardingHc
{
    import onBoardingHcUi.IUIContext;
    import com.sulake.habbo.communication.login.AvatarData;
    import com.sulake.habbo.avatar.IAvatarRenderManager;

    public interface IOnBoardingHcContext extends IUIContext
    {
        function get avatarRenderManager():IAvatarRenderManager;
        function initLogin(email:String, password:String):void;
        function initLoginWithSsoToken(environmentId:String, token:String):void;
        function loginWithAvatar(avatar:AvatarData):void;
        function showScreen(screenType:int):void;
        function registerAccount(email:String, password:String):void;
        function createAvatar(name:String, figure:String, gender:String):void;
        function checkName(name:String):void;
    }
}
