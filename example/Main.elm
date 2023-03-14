module Main exposing (..)

import Harbor as H
import HarborGenerated as H
import Json.Encode as Encode


main =
    Platform.worker
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


type alias Model =
    Int


type Msg
    = NoOp
    | PortMsg H.PortInMsg


init : () -> ( Model, Cmd Msg )
init _ =
    ( 1
    , Cmd.batch
        [ H.send <| H.Log "log something to the console"
        , H.send <| H.Store ( "data", Encode.object [ ( "id", Encode.int 1 ) ] )
        , H.send <| H.Get "data"
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PortMsg inMsg ->
            let
                _ =
                    Debug.log "PortInMsg" inMsg
            in
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ H.harborSubscription |> Sub.map PortMsg ]
