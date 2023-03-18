port module Harbor exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode


{-| Describe your PortIn and PortOut msgs here.
Make sure you have one `Unknown` PortInMsg which acts as a catch-all for incoming port messages.
-}
type PortInMsg
    = ReceiveString String
    | ReceiveBool Bool
    | ReceiveUser (Maybe User)
    | Unknown String


type PortOutMsg
    = LogToConsole String
    | ReadFile FileName
    | StoreUserInLocal User
    | GetUserFromLocal
    | ShowAlert AlertMsg


type AlertMsg
    = Error { code : Int, message : String }
    | Success String


type FileName
    = FilePath String


type alias User =
    { id : String, name : String }


{-| Describe how you want to encode the data going out of your ports
when you send it.

The signature for the `sendHandler` function is always:

    sendHandler : PortOutMsg -> Encode.Value

-}
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

        ShowAlert alertMsg ->
            case alertMsg of
                Error a ->
                    Encode.object
                        [ ( "code", Encode.int a.code )
                        , ( "message", Encode.string a.message )
                        ]

                Success string1 ->
                    Encode.string string1


{-| Convert each PortOutMsg to its string representation. You will then use this on your JS's `subscribe` function.
-}
portOutMsgToString : PortOutMsg -> String
portOutMsgToString msg =
    case msg of
        LogToConsole _ ->
            "LogToConsole"

        StoreUserInLocal _ ->
            "StoreUserInLocal"

        GetUserFromLocal ->
            "GetUserFromLocal"

        ReadFile _ ->
            "ReadFile"

        ShowAlert _ ->
            "ShowAlert"


{-| Describe how you wan to decode the data coming in via ports.
The signature for the `receiveHandler` is always:

    receiveHandler : ( String, String ) -> PortInMsg

That is, it receives a tuple where the first String is the exact literal string value
of `PortInMsg`s and the second String is the JSON-stringified data that the port sent.

-}
receiveHandler : ( String, String ) -> PortInMsg
receiveHandler ( key, jsonString ) =
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
            Unknown key



-- DO NOT EDIT AFTER THIS LINE


port fromElm : ( String, Encode.Value ) -> Cmd msg


port toElm : (( String, Encode.Value ) -> msg) -> Sub msg


send : PortOutMsg -> Cmd msg
send msg =
    fromElm ( portOutMsgToString msg, sendHandler msg )


harborSubscription : Sub PortInMsg
harborSubscription =
    toElm (Tuple.mapSecond (Encode.encode 0) >> receiveHandler)
