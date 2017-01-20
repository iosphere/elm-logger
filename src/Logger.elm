module Logger
    exposing
        ( Config
        , Level(..)
        , config
        , log
        )

{-| This module provides a generic logger with log levels. Logs will only be
printed if the log level matches or exceeds the minimum log level in the
Configuration. Log are also displayed colored according to their level in the
browser's console.

The package's concept is that some other module in the implementation scope of
the app implements convenience functions wrapping a `Config` and `Level`s into
single functions. See the following template for an example:

    module MyUtils

    import Logger

    loggerConfig : Logger.Config
    loggerConfig =
        Logger.config Logger.Info

    log : String -> a -> a
    log =
        Logger.log loggerConfig Logger.Debug

    logVerbose : String -> a -> a
    logVerbose =
        Logger.log loggerConfig Logger.Verbose


The value `loggerConfig` should be created using `Logger.config` with the
minimum log level. By changing the minimum log level in a central module
you can silence any logs in code that fall below that level. The above template
implementation allows you to replace calls to `Debug.log` with `MyUtils.log`.

@docs Config, Level, config, log
-}

import Native.Logger


{-| Log levels can be used to differentiate between the importance of logs.
Calls to `log` with a lower log level than the `minimumLevel` specified in the
`Config` will be silent.
setting the minimum log level in the Config,
-}
type Level
    = Error
    | Warning
    | Info
    | Debug
    | Verbose


{-| Create a default config with a given minimum log level.
At a later stage we might allow to configure the color scheme and
string representation of the loglevel.
-}
config : Level -> Config
config minimumLevel =
    Config
        { minimumLevel = minimumLevel
        , toColor = toColor
        , toString = toString
        }


{-| Public interface for the configuration to hide the implementation details
of the internal configuration. Use `config` to create a configuration.
-}
type Config
    = Config InternalConfig


type alias InternalConfig =
    { minimumLevel : Level
    , toColor : Level -> String
    , toString : Level -> String
    }


{-| Logs the given string and value at the provided log level only if it exceeds
the minimumLevel of the Config. Returns the value provided.
-}
log : Config -> Level -> String -> a -> a
log config =
    case config of
        Config internalConfig ->
            internalLog internalConfig


internalLog : InternalConfig -> Level -> String -> a -> a
internalLog config messageLevel message value =
    if toInt messageLevel >= toInt config.minimumLevel then
        let
            stringLevel =
                config.toString messageLevel

            color =
                config.toColor messageLevel
        in
            nativeLog stringLevel color message value
    else
        value


nativeLog : String -> String -> String -> a -> a
nativeLog level color message value =
    Native.Logger.log level color message value


toColor : Level -> String
toColor logLevel =
    case logLevel of
        Error ->
            "red"

        Warning ->
            "orange"

        Info ->
            "green"

        Debug ->
            "purple"

        Verbose ->
            "LightBlue"


toString : Level -> String
toString logLevel =
    case logLevel of
        Error ->
            "Error"

        Warning ->
            "Warning"

        Info ->
            "Info"

        Debug ->
            "Debug"

        Verbose ->
            "Verbose"


toInt : Level -> Int
toInt logLevel =
    case logLevel of
        Error ->
            4

        Warning ->
            3

        Info ->
            2

        Debug ->
            1

        Verbose ->
            0
