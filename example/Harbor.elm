module Harbor exposing (..)

import Json.Encode as Encode


type PortInMsg
    = ReceiveString String
    | ReceiveBool String
    | ReceiveUser String
    | Unknown


type PortOutMsg
    = Log String
    | Store ( String, Encode.Value )
    | Get String


sendHandler : PortOutMsg -> Encode.Value
sendHandler msg =
    case msg of
        Log str ->
            Encode.string str

        Store ( str, val ) ->
            Encode.object
                [ ( "key", Encode.string str )
                , ( "value", val )
                ]

        Get str ->
            Encode.string str


receiveHandler : ( String, Encode.Value ) -> PortInMsg
receiveHandler ( key, val ) =
    let
        jsonString =
            Encode.encode 0 val
    in
    case key of
        "ReceiveString" ->
            ReceiveString jsonString

        "ReceiveBool" ->
            ReceiveBool jsonString

        "ReceiveUser" ->
            ReceiveUser jsonString

        _ ->
            Unknown
