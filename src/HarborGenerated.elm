port module HarborGenerated exposing (..)

import Harbor as H
import Json.Encode as Encode


port fromElm : ( String, Encode.Value ) -> Cmd msg


port receive : (( String, String ) -> msg) -> Sub msg


receiveHandler =
    H.receiveHandler


sendHandler =
    H.sendHandler


send : H.PortOutMsg -> Cmd msg
send msg =
    let
        portOutMsgToString : String
        portOutMsgToString =
            case msg of
                H.Log _ ->
                    "Log"

                H.Store _ ->
                    "Store"

                H.Get _ ->
                    "Get"
    in
    fromElm ( portOutMsgToString, sendHandler msg )


harborSubscription : Sub H.PortInMsg
harborSubscription =
    receive receiveHandler
