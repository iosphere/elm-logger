module Utils.Debug
    exposing
        ( log
        , logVerbose
        , logInfo
        , logWarning
        , logError
        )

{-|
This is the template implementation of a logger helper that should reside in the
elm app's code base. It sets the minimum log level and provides convenience
log functions to avoid importing `Logger` at the call sites.
-}

import Logger


{-| Create the Logger.Config used in this app.
-}
loggerConfig : Logger.Config
loggerConfig =
    Logger.config Logger.Info



{- We provide convenience log functions to avoid knowledge about
   Utils.Logger at the call site.
-}


log : String -> a -> a
log =
    Logger.log loggerConfig Logger.Debug


logVerbose : String -> a -> a
logVerbose =
    Logger.log loggerConfig Logger.Verbose


logInfo : String -> a -> a
logInfo =
    Logger.log loggerConfig Logger.Info


logWarning : String -> a -> a
logWarning =
    Logger.log loggerConfig Logger.Warning


logError : String -> a -> a
logError =
    Logger.log loggerConfig Logger.Error
