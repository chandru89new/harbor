module Main exposing (..)

import Harbor as H exposing (FileName(..), User)
import HarborGenerated as H


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
        [ H.send <| H.LogToConsole "log something to the console"
        , H.send <| H.StoreUserInLocal (User "1" "John")
        , H.send <| H.GetUserFromLocal
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

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ H.harborSubscription |> Sub.map PortMsg ]
