port module PortOut exposing (..)

import Json.Encode as Encode


type PortOutMsg
    = Log Encode.Value
    | Store Encode.Value
    | Get Encode.Value


port fromElm : ( String, Encode.Value ) -> Cmd msg


send : PortOutMsg -> Cmd msg
send msg =
    fromElm (toJsTuple msg)


toJsTuple : PortOutMsg -> ( String, Encode.Value )
toJsTuple msg =
    case msg of
        Log val ->
            ( "Log", val )

        Store val ->
            ( "Store", val )

        Get val ->
            ( "Get", val )
