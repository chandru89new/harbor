port module HarborGenerated exposing (..)

import Harbor as H
import Json.Encode as Encode


port fromElm : ( String, Encode.Value ) -> Cmd msg


port toElm : (( String, Encode.Value ) -> msg) -> Sub msg


send : H.PortOutMsg -> Cmd msg
send msg =
    let
        portOutMsgToString : String
        portOutMsgToString =
            case msg of
                H.LogToConsole _ ->
                    "LogToConsole"

                H.StoreUserInLocal _ ->
                    "StoreUserInLocal"

                H.GetUserFromLocal ->
                    "GetUserFromLocal"

                H.ReadFile _ ->
                    "ReadFile"
    in
    fromElm ( portOutMsgToString, H.sendHandler msg )


harborSubscription : Sub H.PortInMsg
harborSubscription =
    toElm H.receiveHandler
