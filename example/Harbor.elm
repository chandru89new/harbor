module Harbor exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode


type PortInMsg
    = ReceiveString String
    | ReceiveBool Bool
    | ReceiveUser (Maybe User)
    | Unknown


type PortOutMsg
    = LogToConsole String
    | ReadFile FileName
    | StoreUserInLocal User
    | GetUserFromLocal


type FileName
    = FilePath String


type alias User =
    { id : String, name : String }


sendHandler : PortOutMsg -> Encode.Value
sendHandler msg =
    case msg of
        LogToConsole str ->
            Encode.string str

        StoreUserInLocal usr ->
            Encode.object
                [ ( "id", Encode.string usr.id )
                , ( "name", Encode.string usr.name )
                ]

        ReadFile (FilePath str) ->
            Encode.string str

        GetUserFromLocal ->
            Encode.null


receiveHandler : ( String, Encode.Value ) -> PortInMsg
receiveHandler ( key, val ) =
    let
        jsonString =
            Encode.encode 0 val
    in
    case key of
        "ReceiveString" ->
            ReceiveString <|
                (Decode.decodeString Decode.string jsonString
                    |> Result.toMaybe
                    |> Maybe.withDefault ""
                )

        "ReceiveBool" ->
            ReceiveBool <|
                (Decode.decodeString Decode.bool jsonString
                    |> Result.toMaybe
                    |> Maybe.withDefault False
                )

        "ReceiveUser" ->
            ReceiveUser <|
                (Decode.decodeString
                    (Decode.map2 (\id name -> { id = id, name = name })
                        (Decode.field "id" Decode.string)
                        (Decode.field "name" Decode.string)
                    )
                    jsonString
                    |> Result.toMaybe
                )

        _ ->
            Unknown
