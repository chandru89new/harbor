port module PortIn exposing (..)

import Json.Decode as Decode


type PortInMsg
    = ReceiveString (Result String String)
    | ReceiveBool (Result String Bool)
    | ReceiveUser (Result String { id : String, name : String })
    | Unknown


port toElm : (( String, String ) -> msg) -> Sub msg


toElmHandler : ( String, String ) -> PortInMsg
toElmHandler ( key, val ) =
    case key of
        "ReceiveString" ->
            ReceiveString <| decodeAsString val

        "ReceiveBool" ->
            ReceiveBool <| decodeAsBool val

        "ReceiveUser" ->
            ReceiveUser <| decodeAsUser val

        _ ->
            Unknown


decodeAsString : String -> Result String String
decodeAsString str =
    Decode.decodeString Decode.string str |> Result.mapError Decode.errorToString


decodeAsBool : String -> Result String Bool
decodeAsBool str =
    Decode.decodeString Decode.bool str |> Result.mapError Decode.errorToString


decodeAsUser : String -> Result String { id : String, name : String }
decodeAsUser str =
    let
        idDecoder =
            Decode.field "id" Decode.string

        nameDecoder =
            Decode.field "name" Decode.string

        fn id name =
            { id = id, name = name }
    in
    Decode.decodeString
        (Decode.map2 fn idDecoder nameDecoder)
        str
        |> Result.mapError Decode.errorToString
