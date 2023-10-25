package grimoire.game
{
   import grimoire.Root;
   
   public class Network
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function Network()
      {
         super();
      }
      
      public static function isTemporarilyKicked() : String
      {
         var _loc1_:* = game.mcLogin;
         return _loc1_ != null && _loc1_.btnLogin != null && !_loc1_.btnLogin.visible ? Root.trueString : Root.falseString;
      }
      
      public static function login() : void
      {
         game.removeAllChildren();
         game.gotoAndPlay("Login");
         game.login(Root.username,Root.password);
      }
      
      public static function logout() : void
      {
         game.logout();
      }
      
      public static function showServers() : void
      {
         game.showServerList();
      }
      
      public static function resetServers() : String
      {
         try
         {
            game.serialCmd.servers = [];
            game.world.strMapName = "";
            return Root.trueString;
         }
         catch(e:*)
         {
            return Root.falseString;
         }
      }
      
      public static function areServersLoaded() : String
      {
         var _loc1_:* = game.serialCmd;
         return _loc1_ != null && _loc1_.servers && _loc1_.servers.length > 0 ? Root.trueString : Root.falseString;
      }
      
      public static function connect(param1:String) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in game.serialCmd.servers)
         {
            if(_loc2_.sName == param1)
            {
               game.objServerInfo = _loc2_;
               game.chatF.iChat = _loc2_.iChat;
               break;
            }
         }
         game.connectTo(game.objServerInfo.sIP,game.objServerInfo.iPort);
      }
      
      public static function onLoginExecute() : void
      {
         Root.username = game.mcCharSelect != null ? String(game.mcCharSelect.mngr.displayAvts[game.mcCharSelect.pos].loginInfo.strUsername) : String(game.mcLogin.ni.text);
         Root.password = game.mcCharSelect != null ? String(game.mcCharSelect.mngr.displayAvts[game.mcCharSelect.pos].loginInfo.strPassword) : String(game.mcLogin.pi.text);
         game.removeAllChildren();
         game.gotoAndPlay("Login");
         game.login(Root.username,Root.password);
      }
      
      public static function realAddress() : String
      {
         return "\"" + game.objServerInfo.RealAddress + "\"";
      }
      
      public static function realPort() : String
      {
         return "\"" + game.objServerInfo.RealPort + "\"";
      }
      
      public static function serverTime() : String
      {
         return "\"" + game.date_server.toLocaleTimeString() + "\"";
      }
      
      public static function serverName() : String
      {
         return "\"" + game.objServerInfo.sName + "\"";
      }
      
      public static function serverIP() : String
      {
         return "\"" + game.objServerInfo.sIP + "\"";
      }
   }
}
